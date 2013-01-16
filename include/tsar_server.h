/************************************************************************
 *
 * tsar_server.h - tsar_server.c Include File
 *
 ************************************************************************/

struct handler_entry{
	void (*handler)(int, void *);
	void *data;
	int fd;
        };


static void handle_events(void);
static void wait_for_connections(void);
static void handle_connection(int,void *);
static void accept_connection(int,void *);
static void handle_connection_read(int,void *);
static void install_child_handler(void);

static int process_arguments(int,char **);
static int read_config_file(char *);

static int open_command_file(void);
static void close_command_file(void);
static int write_check_result(char *,time_t);
static int write_to_db(char *);

static int get_user_info(const char *,uid_t *);
static int get_group_info(const char *,gid_t *);
static int drop_privileges(const char *,uid_t,gid_t);
static void do_chroot(void);
static void do_exit(int);

static int write_pid_file(uid_t,gid_t);
static int remove_pid_file(void);

void sighandler(int);
static int read_config_file(char *);
