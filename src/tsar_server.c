/*******************************************************************************
 *
 * tsar_server.c - Data center Sql Acceptor
 *
 * Command line: tsar_server
 *
 * similar as NSCA.C - Nagios Service Check Acceptor 
******************************************************************************/

#include "../include/config.h"
#include "../include/netutils.h"
#include "../include/tsar_server.h"
#include "/usr/include/mysql/mysql.h"

static int server_port=DEFAULT_SERVER_PORT;
static char server_address[MAX_IP_ADDRESS_LENGTH]=DEFAULT_SERVER_HOST;
static int db_port=3306;
static char db_address[MAX_IP_ADDRESS_LENGTH]="127.0.0.1";
static int socket_timeout=2;
static char command_file[MAX_INPUT_BUFFER]="/tmp/data";
static int debug=TRUE;
//static char config_file[MAX_INPUT_BUFFER]="/home/like/trunk/tsar2db/conf/tsar2db.cfg";
static char config_file[MAX_INPUT_BUFFER]="/etc/tsar2db/tsar2db.cfg";

char    *user="root";
char    *group="root";
char    *dbname="tsar";
char    *dbuser="tsaruser";
char    *dbpw="tsarpw";

char    *pid_file="/tmp/tsar2db.pid";
int     wrote_pid_file=FALSE;
char    *tsar_chroot=NULL;

int     sigrestart=FALSE;
int     sigshutdown=FALSE;
int	append2file=FALSE;
int	append2db=TRUE;

static FILE *command_file_fp=NULL;

MYSQL mysql,*mysql_sock;
struct handler_entry *rhand=NULL;
struct handler_entry *whand=NULL;
struct pollfd *pfds=NULL;
int     maxrhand=0;
int     maxwhand=0;
int     maxpfds=0;
int     nrhand=0;
int     nwhand=0;
int     npfds=0;

int main(int argc, char **argv){
	char buffer[MAX_INPUT_BUFFER];
	int result;
	uid_t uid=-1;
	gid_t gid=-1;

	sighandler(SIGTERM);
	
	/* open a connection to the syslog facility */
	openlog("tsar_server",LOG_PID|LOG_NDELAY,LOG_DAEMON);

	/* make sure the config file uses an absolute path */
	if(config_file[0]!='/'){
		/* save the name of the config file */
		strncpy(buffer,config_file,sizeof(buffer));
		buffer[sizeof(buffer)-1]='\0';

		/* get absolute path of current working directory */
		strcpy(config_file,"");
		getcwd(config_file,sizeof(config_file));

		/* append a forward slash */
		strncat(config_file,"/",sizeof(config_file)-2);
		config_file[sizeof(config_file)-1]='\0';

		/* append the config file to the path */
		strncat(config_file,buffer,sizeof(config_file)-strlen(config_file)-1);
		config_file[sizeof(config_file)-1]='\0';
	}
	
	/* read the config file */
        result=read_config_file(config_file);
 
        /* exit if there are errors... */
        if(result==ERROR)
                do_exit(STATE_CRITICAL);

	/*init mysql connect*/
	if(append2db==TRUE){
		mysql_init(&mysql);
		#if MYSQL_VERSION_ID >= 50013 
		char value = 1;
                mysql_options(&mysql, MYSQL_OPT_RECONNECT, (char *)&value);
                #endif
		if (!(mysql_sock = mysql_real_connect(&mysql,db_address,dbuser,dbpw,dbname,db_port,NULL,0))) {
			syslog(LOG_ERR,"Connect mysql db tsar error, check username and pwd and mysql status!");
			return ERROR;
		}
	}
	/* daemonize and start listening for requests... */
	if(fork()==0){
		/* we're a daemon - set up a new process group */
		setsid();

		/* handle signals */
		signal(SIGQUIT,sighandler);
		signal(SIGTERM,sighandler);
		signal(SIGHUP,sighandler);

		/* close standard file descriptors */
		close(0);
		close(1);
		close(2);

		/* redirect standard descriptors to /dev/null */
		open("/dev/null",O_RDONLY);
		open("/dev/null",O_WRONLY);
		open("/dev/null",O_WRONLY);

		/* get group information before chrooting */
		get_user_info(user,&uid);
		get_group_info(group,&gid);

		/* write pid file */
		if(write_pid_file(uid,gid)==ERROR)
			return STATE_CRITICAL;

		/* chroot if configured */
		do_chroot();

		/* drop privileges */
		if(drop_privileges(user,uid,gid)==ERROR)
			do_exit(STATE_CRITICAL);
		do{
			/* reset flags */
			sigrestart=FALSE;
			sigshutdown=FALSE;
			/* wait for connections */
			wait_for_connections();
		}while(sigrestart==TRUE && sigshutdown==FALSE);

		/* remove pid file */
		remove_pid_file();

		syslog(LOG_ERR,"Daemon shutdown\n");

		/* we are now running in daemon mode, or the connection handed over by inetd has been completed, so the parent process exits */
		do_exit(STATE_OK);

		/* keep the compilers happy... */
		return STATE_OK;
	}
}


/* cleanup */
static void do_cleanup(void){
	/* close the command file if its still open */
	if(command_file_fp!=NULL)
		close_command_file();
	return;
}

/* exit cleanly */
static void do_exit(int return_code){
	do_cleanup();
	exit(return_code);
}

/* get rid of all the children we can... */
static void reap_children(int sig){
	while(waitpid(-1,NULL,WNOHANG)>0);
	return;
}
/* install reap_children() signal handler */
static void install_child_handler(void){
	struct sigaction sa;
	sa.sa_handler=reap_children;
	sa.sa_flags=SA_NOCLDSTOP;
	sigaction(SIGCHLD,&sa,NULL);
	return;
}

/* register a file descriptor to be polled for an event set */
static void register_poll(short events, int fd){
	int i;
	/* if it's already in the list, just flag the events */
	for(i=0;i<npfds;i++){
		if(pfds[i].fd==fd){
			pfds[i].events|=events;
			return;
		}
	}
	/* else add it to the list */
	if(maxpfds==0){
		maxpfds++;
		pfds=malloc(sizeof(struct pollfd));
	}
	else if(npfds+1 > maxpfds){
		maxpfds++;
		pfds=realloc(pfds, sizeof(struct pollfd) * maxpfds);
	}

	pfds[npfds].fd=fd;
	pfds[npfds].events=events;
	npfds++;
}



/* register a read handler */
static void register_read_handler(int fd, void (*fp)(int, void *), void *data){
	int i;
	/* register our interest in this descriptor */
	register_poll(POLLIN,fd);
	/* if it's already in the list, just update the handler */
	for(i=0;i<nrhand;i++){
		if(rhand[i].fd==fd){
			rhand[i].handler=fp;
			rhand[i].data=data;
			return;
		}
	}
	/* else add it to the list */
	if(maxrhand==0){
		maxrhand++;
		rhand=malloc(sizeof(struct handler_entry));
	}
	else if(nrhand+1 > maxrhand){
		maxrhand++;
		rhand=realloc(rhand, sizeof(struct handler_entry) * maxrhand);
	}

	rhand[nrhand].fd=fd;
	rhand[nrhand].handler=fp;
	rhand[nrhand].data=data;
	nrhand++;
}

/* register a write handler */
static void register_write_handler(int fd, void (*fp)(int, void *), void *data){
	int i;
	/* register our interest in this descriptor */
	register_poll(POLLOUT,fd);
	/* if it's already in the list, just update the handler */
	for(i=0;i<nwhand;i++){
		if(whand[i].fd==fd){
			whand[i].handler=fp;
			whand[i].data=data;
			return;
		}
	}
	/* else add it to the list */
	if(maxwhand==0){
		maxwhand++;
		whand=malloc(sizeof(struct handler_entry));
	}
	else if(nwhand+1 > maxwhand){
		maxwhand++;
		whand=realloc(whand, sizeof(struct handler_entry) * maxwhand);
	}
	whand[nwhand].fd=fd;
	whand[nwhand].handler=fp;
	whand[nwhand].data=data;
	nwhand++;
}

/* find read handler */
static int find_rhand(int fd){
	int i;
	for(i=0;i<nrhand;i++){
		if(rhand[i].fd==fd)
			return i;
	}
	/* we couldn't find the read handler */
	syslog(LOG_ERR, "Handler stack corrupt - aborting");
	do_exit(STATE_CRITICAL);
}

/* find write handler */
static int find_whand(int fd){
	int i;
	for(i=0;i<nwhand;i++){
		if(whand[i].fd==fd)
			return i;
	}
	/* we couldn't find the write handler */
	syslog(LOG_ERR, "Handler stack corrupt - aborting");
	do_exit(STATE_CRITICAL);
}


/* handle pending events */
static void handle_events(void){
	void (*handler)(int, void *);
	void *data;
	int i, hand;

	/* bail out if necessary */
	if(sigrestart==TRUE || sigshutdown==TRUE)
		return;

	poll(pfds,npfds,-1);
	for(i=0;i<npfds;i++){
		if((pfds[i].events&POLLIN) && (pfds[i].revents&(POLLIN|POLLERR|POLLHUP|POLLNVAL))){
			pfds[i].events&=~POLLIN;
			hand=find_rhand(pfds[i].fd);
			handler=rhand[hand].handler;
			data=rhand[hand].data;
			rhand[hand].handler=NULL;
			rhand[hand].data=NULL;
			handler(pfds[i].fd,data);
		}
		if((pfds[i].events&POLLOUT) && (pfds[i].revents&(POLLOUT|POLLERR|POLLHUP|POLLNVAL))){
			pfds[i].events&=~POLLOUT;
			hand=find_whand(pfds[i].fd);
			handler=whand[hand].handler;
			data=whand[hand].data;
			whand[hand].handler=NULL;
			whand[hand].data=NULL;
			handler(pfds[i].fd,data);
		}
	}

	for(i=0;i<npfds;i++){
		if(pfds[i].events==0){
			npfds--;
			pfds[i].fd=pfds[npfds].fd;
			pfds[i].events=pfds[npfds].events;
		}
	}

	return;
}



/* wait for incoming connection requests */
static void wait_for_connections(void) {
	struct sockaddr_in myname;
	int sock=0;
	int flag=1;

	/* create a socket for listening */
	sock=socket(AF_INET,SOCK_STREAM,0);

	/* exit if we couldn't create the socket */
	if(sock<0){
		syslog(LOG_ERR,"Network server socket failure (%d: %s)",errno,strerror(errno));
		do_exit(STATE_CRITICAL);
	}

	/* set the reuse address flag so we don't get errors when restarting */
	flag=1;
	if(setsockopt(sock,SOL_SOCKET,SO_REUSEADDR,(char *)&flag,sizeof(flag))<0){
		syslog(LOG_ERR,"Could not set reuse address option on socket!\n");
		do_exit(STATE_CRITICAL);
	}

	myname.sin_family=AF_INET;
	myname.sin_port=htons(server_port);
	bzero(&myname.sin_zero,8);

	/* what address should we bind to? */
	if(!strlen(server_address))
		myname.sin_addr.s_addr=INADDR_ANY;
	else if(!my_inet_aton(server_address,&myname.sin_addr)){
		syslog(LOG_ERR,"Server address is not a valid IP address\n");
		do_exit(STATE_CRITICAL);
	}


	/* bind the address to the Internet socket */
	if(bind(sock,(struct sockaddr *)&myname,sizeof(myname))<0){
		syslog(LOG_ERR,"Network server bind failure (%d: %s)\n",errno,strerror(errno));
		do_exit(STATE_CRITICAL);
	}

	/* open the socket for listening */
	if(listen(sock,2)<0){
	//if(listen(sock,SOMAXCONN)<0){
		syslog(LOG_ERR,"Network server listen failure (%d: %s)\n",errno,strerror(errno));
		do_exit(STATE_CRITICAL);
	}

	/* log info to syslog facility */
	syslog(LOG_ERR,"Starting up daemon");

	if(debug==TRUE){
		syslog(LOG_ERR,"Listening for connections on port %d\n",htons(myname.sin_port));
	}

	register_read_handler(sock,accept_connection,NULL);
	while(1){

		/* bail out if necessary */
		if(sigrestart==TRUE || sigshutdown==TRUE){
			/* close the socket we're listening on */
			close(sock);
			/*close mysql*/
			if(append2db==TRUE){
				mysql_close(mysql_sock);
			}
			break;
		}
		/* handle the new connection (if any) */
		else
			handle_events();
	}

	return;
}



static void accept_connection(int sock, void *unused){
	int new_sd;
	pid_t pid;
	struct sockaddr addr;
	struct sockaddr_in *nptr;
	socklen_t addrlen;
	int rc;
#ifdef HAVE_LIBWRAP
	struct request_info req;
#endif

	/* DO NOT REMOVE! 01/29/2007 single process daemon will fail if this is removed */
	register_read_handler(sock,accept_connection,NULL);

	/* wait for a connection request */
	while(1){

		/* we got a live one... */
		if((new_sd=accept(sock,0,0))>=0)
			break;

		/* handle the error */
		else{

			/* bail out if necessary */
			if(sigrestart==TRUE || sigshutdown==TRUE)
				return;

			/* try and handle temporary errors */
			if(errno==EWOULDBLOCK || errno==EINTR || errno==ECHILD){
				return;
			}
			else
				break;
		}
	}

	/* hey, there was an error... */
	if(new_sd<0){

		/* log error to syslog facility */
		syslog(LOG_ERR,"Network server accept failure (%d: %s)",errno,strerror(errno));

		/* close socket prior to exiting */
		close(sock);
		return;
	}

#ifdef HAVE_LIBWRAP

	/* Check whether or not connections are allowed from this host */
	request_init(&req,RQ_DAEMON,"tsar2db",RQ_FILE,new_sd,0);
	fromhost(&req);

	if(!hosts_access(&req)){
		/* refuse the connection */
		syslog(LOG_ERR, "refused connect from %s", eval_client(&req));
		close(new_sd);
		return;
	}
#endif


	/* find out who just connected... */
	addrlen=sizeof(addr);
	rc=getpeername(new_sd,&addr,&addrlen);

	if(rc<0){
		/* log error to syslog facility */
		syslog(LOG_ERR,"Error: Network server getpeername() failure (%d: %s)",errno,strerror(errno));

		/* close socket prior to exiting */
		close(new_sd);
		return;
	}

	nptr=(struct sockaddr_in *)&addr;

	/* log info to syslog facility */
	if(debug==TRUE)
		syslog(LOG_ERR,"Connection from %s port %d",inet_ntoa(nptr->sin_addr),nptr->sin_port);

	/* handle the connection */
	register_write_handler(new_sd, handle_connection, NULL);
	return;
}



/* handle a client connection */
static void handle_connection(int sock, void *data){
	int bytes_to_send;
	int rc;
	int flags;
	time_t packet_send_time;
	struct crypt_instance *CI;

	/* log info to syslog facility */
	if(debug==TRUE)
		syslog(LOG_ERR,"Handling the connection...");

	/* socket should be non-blocking */
	fcntl(sock,F_GETFL,&flags);
	fcntl(sock,F_SETFL,flags|O_NONBLOCK);

	register_read_handler(sock, handle_connection_read, NULL);
	return;
}



/* handle reading from a client connection */
static void handle_connection_read(int sock, void *data){
	//data_packet receive_packet;
	char receive_packet[MAX_OUTPUT_LENGTH];
	u_int32_t packet_crc32;
	u_int32_t calculated_crc32;
	time_t packet_time;
	time_t current_time;
	int16_t return_code;
	unsigned long packet_age=0L;
	int bytes_to_recv;
	int rc=1;
	char sql_data[MAX_OUTPUT_LENGTH];

	/* process all data we get from the client... */

	/* read the packet from the client */
	bytes_to_recv=sizeof(receive_packet);
	rc=recvall(sock,(char *)&receive_packet,&bytes_to_recv,socket_timeout);
	
	/* plugin output */
	strncpy(sql_data,receive_packet,sizeof(sql_data)-1);
	sql_data[sizeof(sql_data)-1]='\0';
	
	/* recv() error or client disconnect */
	if(rc<=0){
		if(debug==TRUE && rc<0)
			syslog(LOG_ERR,"End of connection...");
		close(sock);
		if(rc<0)
			return;
	}
	
	/* if we're single-process, we need to set things up so we handle the next packet after this one... */
	register_read_handler(sock, handle_connection_read, NULL);

	/* log info to syslog facility */
	if(debug==TRUE&&sql_data[0]!=0){
			syslog(LOG_ERR,"this is the packet get from client :'%s',size:%d\n",sql_data,bytes_to_recv);
	}

	/* write the check result to the external command file.
	 * Note: it's OK to hang at this point if the write doesn't succeed, as there's
	 * no way we could handle any other connection properly anyway.  so we don't
	 * use poll() - which fails on a pipe with any data, so it would cause us to
	 * only ever write one command at a time into the pipe.
	 */
	if(append2file==TRUE&&sql_data[0]!=0)
		write_check_result(sql_data,time(NULL));
	if(append2db==TRUE&&sql_data[0]!=0)
		write_to_db(sql_data);
	return;
}

/* writes results to DB*/
static int write_to_db(char *sql_data){
	/*reconnet if the link lost*/
	mysql_ping(mysql_sock);
	/*split the sql to single*/
	static char sql_line[1024] = {0};
	static char *a_ptr = NULL;
	char *p_split;
	a_ptr = NULL;
	int insert_error = 0;
	p_split = strtok_r(sql_data, ";",&a_ptr);
	while(p_split) {
		if(strlen(p_split) < 10)
		{
			p_split = strtok_r(NULL,";",&a_ptr);
			continue;
		}
		sql_line[0]='\0';
		strcat(sql_line, p_split);
		strcat(sql_line, ";");
		/*execute the sql*/
		if(debug == TRUE){
                	syslog(LOG_ERR,"insert sql:%s",sql_line);
		}
		if(mysql_query(mysql_sock,sql_line) != 0) {
			syslog(LOG_ERR,"insert wrong, check sql:%s",sql_line);
			insert_error = 1;
		}
		/*get the next sql*/
		p_split = strtok_r(NULL,";",&a_ptr);
	}
	if(insert_error == 1)
		return ERROR;
	return OK;
}



/* writes service/host check results to the Nagios command file */
static int write_check_result(char *sql_data, time_t check_time){
	if(open_command_file()==ERROR)
		return ERROR;
	fprintf(command_file_fp,"[%lu]:%s\n",(unsigned long)check_time,sql_data);
	close_command_file();
	return OK;
}


/* opens the command file for writing */
static int open_command_file(void){
	struct stat statbuf;

	/* file is already open */
	if(command_file_fp!=NULL)
		return OK;
	
	/* open the command file for writing or appending */
	command_file_fp=fopen(command_file,"a");

	/* command file doesn't exist - monitoring app probably isn't running... */
	if(stat(command_file,&statbuf)){
		syslog(LOG_ERR,"Command file '%s' does not exist for output",command_file);
		return ERROR;
	}
	if(command_file_fp==NULL){
		if(debug==TRUE)
			syslog(LOG_ERR,"Could not open command file '%s' for %s",command_file,"appending");
		return ERROR;
	}

	return OK;
}



/* closes the command file */
static void close_command_file(void){

	fclose(command_file_fp);
	command_file_fp=NULL;

	return;
}


static int write_pid_file(uid_t usr, gid_t grp){
	int fd;
	int result=0;
	pid_t pid=0;
	char pbuf[16];

	/* no pid file was specified */
	if(pid_file==NULL)
		return OK;

	/* read existing pid file */
	if((fd=open(pid_file,O_RDONLY))>=0){

		result=read(fd,pbuf,(sizeof pbuf)-1);

		close(fd);

		if(result>0){

			pbuf[result]='\x0';
			pid=(pid_t)atoi(pbuf);

			/* if previous process is no longer running running, remove the old pid file */
			if(pid && (pid==getpid() || kill(pid,0)<0))
				unlink(pid_file);

			/* previous process is still running */
			else{
				syslog(LOG_ERR,"There's already an server running (PID %lu).  Bailing out...",(unsigned long)pid);
				return ERROR;
			}
		}
	} 

	/* write new pid file */
	if((fd=open(pid_file,O_WRONLY | O_CREAT,0644))>=0){
		sprintf(pbuf,"%d\n",(int)getpid());
		write(fd,pbuf,strlen(pbuf));
		fchown(fd,usr,grp);
		close(fd);
		wrote_pid_file=TRUE;
	}
	else{
		syslog(LOG_ERR,"Cannot write to pidfile '%s' - check your privileges.",pid_file);
	}

	return OK;
}



/* remove pid file */
static int remove_pid_file(void){

	/* no pid file was specified */
	if(pid_file==NULL)
		return OK;

	/* pid file was not written */
	if(wrote_pid_file==FALSE)
		return OK;

	/* remove existing pid file */
	if(unlink(pid_file)==-1){
		syslog(LOG_ERR,"Cannot remove pidfile '%s' - check your privileges.",pid_file);
		return ERROR;
	}

	return OK;
}



/* get user information */
static int get_user_info(const char *user, uid_t *uid){
	const struct passwd *pw=NULL;

	if(user!=NULL){
		/* see if this is a user name */
		if(strspn(user,"0123456789")<strlen(user)){
			pw=(struct passwd *)getpwnam(user);
			if(pw!=NULL)
				*uid=(uid_t)(pw->pw_uid);
			else
				syslog(LOG_ERR,"Warning: Could not get passwd entry for '%s'",user);
			endpwent();
		}

		/* else we were passed the UID */
		else
			*uid=(uid_t)atoi(user);

	} 
	else
		*uid=geteuid();

	return OK;
}



/* get group information */
static int get_group_info(const char *group, gid_t *gid){
	const struct group *grp=NULL;

	/* get group ID */
	if(group!=NULL){
		/* see if this is a group name */
		if(strspn(group,"0123456789")<strlen(group)){
			grp=(struct group *)getgrnam(group);
			if(grp!=NULL)
				*gid=(gid_t)(grp->gr_gid);
			else
				syslog(LOG_ERR,"Warning: Could not get group entry for '%s'",group);
			endgrent();
		}

		/* else we were passed the GID */
		else
			*gid=(gid_t)atoi(group);
	} 
	else
		*gid=getegid();

	return OK;
}



/* drops privileges */
static int drop_privileges(const char *user, uid_t uid, gid_t gid){
	struct group *grp;
	struct passwd *pw;

	/* only drop privileges if we're running as root, so we don't interfere with being debugged while running as some random user */
	if(getuid()!=0)
		return OK;

	/* set effective group ID if other than current EGID */
	if(gid!=getegid()){
		if(setgid(gid)==-1){
			syslog(LOG_ERR,"Warning: Could not set effective GID=%d",(int)gid);
			return ERROR;
		}
	}

#ifdef HAVE_INITGROUPS
	if(uid!=geteuid()){
		/* initialize supplementary groups */
		if(initgroups(user,gid)==-1){
			if(errno==EPERM)
				syslog(LOG_ERR,"Warning: Unable to change supplementary groups using initgroups()");
			else{
				syslog(LOG_ERR,"Warning: Possibly root user failed dropping privileges with initgroups()");
				return ERROR;
			}
		}
	}
#endif

	if(setuid(uid)==-1){
		syslog(LOG_ERR,"Warning: Could not set effective UID=%d",(int)uid);
		return ERROR;
	}

	return OK;
}



/* perform the chroot() operation if configured to do so */
void do_chroot(void){
	int retval=0;
	const char *err=NULL;

	if(tsar_chroot!=NULL){
		retval=chdir(tsar_chroot);
		if(retval!=0){
			err=strerror(errno);
			syslog(LOG_ERR, "can not chdir into chroot directory: %s", err);
			do_exit(STATE_UNKNOWN);
		}
		retval=chroot(".");
		if(retval!=0){
			err=strerror(errno);
			syslog(LOG_ERR, "can not chroot: %s", err);
			do_exit(STATE_UNKNOWN);
		}
	}
}



/* handle signals */
void sighandler(int sig){
	static char *sigs[]={"EXIT","HUP","INT","QUIT","ILL","TRAP","ABRT","BUS","FPE","KILL","USR1","SEGV","USR2","PIPE","ALRM","TERM","STKFLT","CHLD","CONT","STOP","TSTP","TTIN","TTOU","URG","XCPU","XFSZ","VTALRM","PROF","WINCH","IO","PWR","UNUSED","ZERR","DEBUG",(char *)NULL};
	int i;
	char temp_buffer[MAX_INPUT_BUFFER];

	if(sig<0)
		sig=-sig;

	for(i=0;sigs[i]!=(char *)NULL;i++);

	sig%=i;

	/* we received a SIGHUP, so restart... */
	if(sig==SIGHUP){
		sigrestart=TRUE;
		syslog(LOG_ERR,"Caught SIGHUP - restarting...\n");
	}

	/* else begin shutting down... */
	if(sig==SIGTERM){
		/* if shutdown is already true, we're in a signal trap loop! */
		if(sigshutdown==TRUE)
			exit(STATE_CRITICAL);

		sigshutdown=TRUE;

		syslog(LOG_ERR,"Caught SIG%s - shutting down...\n",sigs[sig]);
	}

	return;
}
/* read in the configuration file */
static int read_config_file(char *filename){
        FILE *fp; 
        char input_buffer[MAX_INPUT_BUFFER];
        char *varname;
        char *varvalue;
        int line;

        /* open the config file for reading */
        fp=fopen(filename,"r");

        /* exit if we couldn't open the config file */
        if(fp==NULL){
                syslog(LOG_ERR,"Could not open config file '%s' for reading\n",filename);
                return ERROR;
                }    

        line=0;
        while(fgets(input_buffer,MAX_INPUT_BUFFER-1,fp)){

                line++;

                /* skip comments and blank lines */
                if(input_buffer[0]=='#')
                        continue;
                if(input_buffer[0]=='\0')
                        continue;
                if(input_buffer[0]=='\n')
                        continue;

                /* get the variable name */
                varname=strtok(input_buffer,"=");
                if(varname==NULL){
                        syslog(LOG_ERR,"No variable name specified in config file '%s' - Line %d\n",filename,line);
                        return ERROR;
                        }    

                /* get the variable value */
                varvalue=strtok(NULL,"\n");
		if(varvalue==NULL){
			syslog(LOG_ERR,"No variable value specified in config file '%s' - Line %d\n",filename,line);
			return ERROR;
		}    
		if(!strcmp(varname,"db_address")){
			if(strlen(varvalue)>sizeof(db_address)-1){
				syslog(LOG_ERR,"db_address is too long in config file '%s' - Line %d\n",filename,line);
				return ERROR;
			}
			strncpy(db_address,varvalue,sizeof(db_address)-1);
			db_address[sizeof(db_address)-1]='\0';
		}
		else if(!strcmp(varname,"db_port")){
			db_port=atoi(varvalue);
		}
		else if(!strcmp(varname,"db_name")){
			dbname=strdup(varvalue);
		}
		else if(!strcmp(varname,"db_user")){
			dbuser=strdup(varvalue);
		}
		else if(!strcmp(varname,"db_pw")){
			dbpw=strdup(varvalue);
		}
		else if(!strcmp(varname,"server_port")){
			server_port=atoi(varvalue);
		}
		else if(!strcmp(varname,"debug")){
			if(atoi(varvalue)>0)
				debug=TRUE;
			else
				debug=FALSE;
		}
		else if(strstr(input_buffer,"append2file")){
			if(atoi(varvalue)>0)
				append2file=TRUE;
			else
				append2file=FALSE;
		}
		else if(strstr(input_buffer,"append2db")){
			if(atoi(varvalue)>0)
				append2db=TRUE;
			else
				append2db=FALSE;
		}
		else if(!strcmp(varname,"chroot"))
			tsar_chroot=strdup(varvalue);

		else if(!strcmp(varname,"pid_file"))
			pid_file=strdup(varvalue);
		else if(!strcmp(varname,"maxtime"))
			;
		else{
			syslog(LOG_ERR,"Unknown option specified in config file '%s' - Line %d\n",filename,line);

			return ERROR;
		}
	}
	/* close the config file */
	fclose(fp);

	return OK;
}
