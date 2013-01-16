/* client.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define MAXLINE 4096
#define SERV_PORT 56677

int main(int argc, char *argv[])
{
	struct sockaddr_in servaddr;
	char buf[MAXLINE];
	int sockfd, n;
	char *str="insert into `squid` (host_name, time) VALUES ('mmdev2.corp.alimama.com', '1273740861');insert into `squid` (host_name, time, qps, rt, r_hit, b_hit, d_hit,m_hit,fdused, fdque, objs, inmem, hot, size) VALUES ('mmdev3.corp.alimama.com', '1273740861', '1000.38', '7.00', '99.00', '90.00', '45','51','32.00', '0.00', '1060.00', '1060.00', '1054.00', '12.02');";
    
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	bzero(&servaddr, sizeof(servaddr));
	servaddr.sin_family = AF_INET;
	inet_pton(AF_INET, "0.0.0.0", &servaddr.sin_addr);
	servaddr.sin_port = htons(SERV_PORT);
    
	connect(sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr));
	
	write(sockfd, str, strlen(str));
	
	printf("send %s length:%d:\n",str,strlen(str));

	close(sockfd);

	return 0;
}

