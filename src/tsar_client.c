/**********************************************************************************
 *
 * SEND_TSAR.C - Tsar Client
 *
 * Description:
 *
 *
 *********************************************************************************/

#include "../include/config.h"
#include "../include/netutils.h"

char server_name[MAX_IP_ADDRESS_LENGTH]=DEFAULT_SERVER_HOST;
int server_port=DEFAULT_SERVER_PORT;
//static char config_file[MAX_INPUT_BUFFER]="/etc/tsar2db/tsar2db.cfg";

int main(int argc, char **argv){
	int sd;
	int result;
	int bytes_to_send;
        char buffer[MAX_INPUT_BUFFER];
	char input_buffer[MAX_INPUT_BUFFER];
	char data_to_send[MAX_OUTPUT_LENGTH];
	int total_packets=0;
	/*process command line*/
	if(argc < 3){ 
		printf ("Usage:\ntsar_clinet <address> <switch port>\n");
		printf ("Such as:./tsar_client localhost 56677\n");
		return 0;
	}else{
		strcpy(server_name,argv[1]);
		server_port=atoi(argv[2]);
	}
	   
	/* try to connect to the host at the given port number */
	result=my_tcp_connect(server_name,server_port,&sd);
	/* we couldn't connect */
	if(result!=STATE_OK){
		printf("Error: Could not connect to host %s on port %d\n",server_name,server_port);
		exit(STATE_CRITICAL);
	}
	/**** WE'RE CONNECTED AND READY TO SEND ****/
	/* read all data from STDIN until there isn't anymore */
	while(fgets(input_buffer,sizeof(input_buffer)-1,stdin)){

		if(feof(stdin))
			break;
		/* strips trailing newlines, carriage returns, spaces, and tabs from a string */
		strip(input_buffer);
		
		if(!strcmp(input_buffer,""))
			continue;

		/*init the data to be sent*/
		strncpy(data_to_send,input_buffer,sizeof(data_to_send)-1);
		data_to_send[sizeof(data_to_send)-1]='\x0';
		/* increment count of packets we're sending */
		total_packets++;

		/* send the packet */
		bytes_to_send=sizeof(data_to_send);
		result=sendall(sd,data_to_send,&bytes_to_send);

		/* there was an error sending the packet */
		if(result==-1){
			printf("Error: Could not send data to host\n");
			close(sd);
			exit(STATE_UNKNOWN);
		}

		/* for some reason we didn't send all the bytes we were supposed to */
		else if(bytes_to_send < sizeof(data_to_send)){
			printf("Warning: Sent only %d of %d bytes to host\n",result,bytes_to_send);
			close(sd);
			return STATE_UNKNOWN;
		}
		/*the data send information*/
		printf("Notice: Sent to host:%s\n", data_to_send);
	}

	/* close the connection */
	close(sd);

	printf("%d data packet(s) sent to host successfully.\n",total_packets);

	/* exit cleanly */
	exit(STATE_OK);

	/* no compiler complaints here... */
	return STATE_OK;
}
