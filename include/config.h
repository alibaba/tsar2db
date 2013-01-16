#include <stdio.h>
#include <stdlib.h>

#define DEFAULT_SERVER_HOST "0.0.0.0"
#define DEFAULT_SERVER_PORT 56677
#define MAX_OUTPUT_LENGTH       4096 

#define OK              0
#define ERROR           -1
#define TRUE            1
#define FALSE           0
#define STATE_UNKNOWN   3       /* service state return codes */
#define STATE_CRITICAL  2
#define STATE_WARNING   1
#define STATE_OK        0

#define DEFAULT_SOCKET_TIMEOUT  10      /* timeout after 10 seconds */
#define MAX_INPUT_BUFFER        2048    /* max size of most buffers we use */
#define MAX_IP_ADDRESS_LENGTH  20    /* max size of a host address */
/* #undef socklen_t */

#define STDC_HEADERS 1
#define HAVE_SYSLOG_H 1
#define HAVE_STRDUP 1
#define HAVE_STRSTR 1
#define HAVE_STRTOUL 1

/* #undef HAVE_INITGROUPS */
/* #undef HAVE_LIMITS_H */
#define HAVE_SYS_RESOURCE_H 1

#define HAVE_LIBWRAP 1

#define SOCKET_SIZE_TYPE size_t
#define GETGROUPS_T gid_t
#define RETSIGTYPE void


#define SIZEOF_INT 4
#define SIZEOF_SHORT 2
#define SIZEOF_LONG 4

/* stupid stuff for u_int32_t */
/* #undef U_INT32_T_IS_USHORT */
/* #undef U_INT32_T_IS_UINT */
/* #undef U_INT32_T_IS_ULONG */
/* #undef U_INT32_T_IS_UINT32_T */

#ifdef U_INT32_T_IS_USHORT
typedef unsigned short u_int32_t;
#endif
#ifdef U_INT32_T_IS_ULONG
typedef unsigned long u_int32_t;
#endif
#ifdef U_INT32_T_IS_UINT
typedef unsigned int u_int32_t;
#endif
#ifdef U_INT32_T_IS_UINT32_t
typedef uint32_t u_int32_t;
#endif

/* stupid stuff for int32_t */
/* #undef INT32_T_IS_SHORT */
/* #undef INT32_T_IS_INT */
/* #undef INT32_T_IS_LONG */

#ifdef INT32_T_IS_USHORT
typedef short int32_t;
#endif
#ifdef INT32_T_IS_ULONG
typedef long int32_t;
#endif
#ifdef INT32_T_IS_UINT
typedef int int32_t;
#endif

#define HAVE_REGEX_H 1
#ifdef HAVE_REGEX_H
#include <regex.h>
#endif

#define HAVE_STRINGS_H 1
#define HAVE_STRING_H 1
#ifdef HAVE_STRINGS_H
#include <strings.h>
#endif
#ifdef HAVE_STRINGS_H
#include <string.h>
#endif

#define HAVE_UNISTD_H 1
#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif


#define HAVE_SIGNAL_H 1
#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#define HAVE_SYSLOG_H 1
#ifdef HAVE_SYSLOG_H
#include <syslog.h>
#endif

/* #undef HAVE_SYS_INT_TYPES_H */
#ifdef HAVE_SYS_INT_TYPES_H
#include <sys/int_types.h>
#endif

#define HAVE_SYS_STAT_H 1
#ifdef HAVE_SYS_STAT_H
#include <sys/stat.h>
#endif

#define HAVE_FCNTL_H 1
#ifdef HAVE_FCNTL_H
#include <fcntl.h>
#endif

#define HAVE_STDINT_H 1
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif

#define HAVE_SYS_POLL_H 1
#ifdef HAVE_SYS_POLL_H
#include <sys/poll.h>
#endif

#define HAVE_SYS_TYPES_H 1
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#define HAVE_SYS_WAIT_H 1
#ifdef HAVE_SYS_WAIT_H
#include <sys/wait.h>
#endif

#define HAVE_ERRNO_H 1
#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

/* needed for the time_t structures we use later... */
#define TIME_WITH_SYS_TIME 1
#define HAVE_SYS_TIME_H 1
#if TIME_WITH_SYS_TIME
# include <sys/time.h>
# include <time.h>
#else
# if HAVE_SYS_TIME_H
#  include <sys/time.h>
# else
#  include <time.h>
# endif
#endif


#define HAVE_SYS_SOCKET_H 1
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

/* #undef HAVE_SOCKET */
#ifdef HAVE_SOCKET_H
#include <socket.h>
#endif

#define HAVE_TCPD_H 1
#ifdef HAVE_TCPD_H
#include <tcpd.h>
#endif

#define HAVE_NETINET_IN_H 1
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#define HAVE_ARPA_INET_H 1
#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#define HAVE_NETDB_H 1
#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#define HAVE_CTYPE_H 1
#ifdef HAVE_CTYPE_H
#include <ctype.h>
#endif

#ifdef HAVE_DB_H
#include <db.h>
#endif

#define HAVE_PWD_H 1
#ifdef HAVE_PWD_H
#include <pwd.h>
#endif

#define HAVE_GRP_H 1
#ifdef HAVE_GRP_H
#include <grp.h>
#endif

#define HAVE_INTTYPES_H 1
#ifdef HAVE_INTTYPES_H
#include <inttypes.h>
#endif

/* #undef HAVE_SYS_CONFIG_H */
#ifdef HAVE_SYS_CONFIG_H
#include <sys/config.h>
#endif

#define HAVE_INTTYPES_H 1
#define HAVE_STDINT_H 1
#ifdef HAVE_INTTYPES_H
#include <inttypes.h>
#else
#ifdef HAVE_STDINT_H
#include <stdint.h>
#endif
#endif

