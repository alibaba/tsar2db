-- cpu_1 info
CREATE TABLE IF NOT EXISTS `cpu_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`user`	decimal(8,2),
		`sys`	decimal(8,2),
		`wait`	decimal(8,2),
		`hirq`	decimal(8,2),
		`sirq`	decimal(8,2),
		`util`	decimal(8,2),
		`nice`	decimal(8,2),
		`steal`	decimal(8,2),
		`guest`	decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='cpu mod info';

-- cpu_2 info
CREATE TABLE IF NOT EXISTS `cpu_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`user`	decimal(8,2),
		`sys`	decimal(8,2),
		`wait`	decimal(8,2),
		`hirq`	decimal(8,2),
		`sirq`	decimal(8,2),
		`util`	decimal(8,2),
		`nice`	decimal(8,2),
		`steal`	decimal(8,2),
		`guest`	decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='cpu mod info';

CREATE TABLE IF NOT EXISTS `cpu` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`user`  decimal(8,2),
		`sys`   decimal(8,2),
		`wait`  decimal(8,2),
		`hirq`  decimal(8,2),
		`sirq`  decimal(8,2),
		`util`  decimal(8,2),
		`nice`  decimal(8,2),
		`steal` decimal(8,2),
		`guest` decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(cpu_1,cpu_2) INSERT_METHOD=LAST;

-- tcpx_1 info
CREATE TABLE IF NOT EXISTS `tcpx_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`recvq`	decimal(15,2),
		`sendq`	decimal(15,2),
		`est`	decimal(15,2),
		`twait`	decimal(15,2),
		`fwait1`	decimal(15,2),
		`fwait2`	decimal(15,2),
		`lisq`	decimal(15,2),
		`lising`	decimal(15,2),
		`lisove`	decimal(15,2),
		`cnest`	decimal(15,2),
		`ndrop`	decimal(15,2),
		`edrop`	decimal(15,2),
		`rdrop`	decimal(15,2),
		`pdrop`	decimal(15,2),
		`kdrop`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='tcpx mod info';

-- tcpx_2 info
CREATE TABLE IF NOT EXISTS `tcpx_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`recvq` decimal(15,2),
		`sendq` decimal(15,2),
		`est`   decimal(15,2),
		`twait` decimal(15,2),
		`fwait1`        decimal(15,2),
		`fwait2`        decimal(15,2),
		`lisq`  decimal(15,2),
		`lising`        decimal(15,2),
		`lisove`        decimal(15,2),
		`cnest` decimal(15,2),
		`ndrop` decimal(15,2),
		`edrop` decimal(15,2),
		`rdrop` decimal(15,2),
		`pdrop` decimal(15,2),
		`kdrop` decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='tcpx mod info';

CREATE TABLE IF NOT EXISTS `tcpx` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`recvq` decimal(15,2),
		`sendq` decimal(15,2),
		`est`   decimal(15,2),
		`twait` decimal(15,2),
		`fwait1`        decimal(15,2),
		`fwait2`        decimal(15,2),
		`lisq`  decimal(15,2),
		`lising`        decimal(15,2),
		`lisove`        decimal(15,2),
		`cnest` decimal(15,2),
		`ndrop` decimal(15,2),
		`edrop` decimal(15,2),
		`rdrop` decimal(15,2),
		`pdrop` decimal(15,2),
		`kdrop` decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(tcpx_1,tcpx_2) INSERT_METHOD=LAST;

-- apache_1 info
CREATE TABLE IF NOT EXISTS `apache_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`	decimal(15,2),
		`rt`	decimal(15,2),
		`sent`	decimal(15,2),
		`busy`	decimal(15,2),
		`idle`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='apache mod info';

-- apache_2 info
CREATE TABLE IF NOT EXISTS `apache_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`   decimal(15,2),
		`rt`    decimal(15,2),
		`sent`  decimal(15,2),
		`busy`  decimal(15,2),
		`idle`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='apache mod info';

CREATE TABLE IF NOT EXISTS `apache` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`   decimal(15,2),
		`rt`    decimal(15,2),
		`sent`  decimal(15,2),
		`busy`  decimal(15,2),
		`idle`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(apache_1,apache_2) INSERT_METHOD=LAST;

-- udp_1 info
CREATE TABLE IF NOT EXISTS `udp_1` (
		`host_name`	varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`idgm`	decimal(15,2),
		`odgm`	decimal(15,2),
		`noport`	decimal(15,2),
		`idmerr`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='udp mod info';

-- udp_2 info
CREATE TABLE IF NOT EXISTS `udp_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`idgm`  decimal(15,2),
		`odgm`  decimal(15,2),
		`noport`        decimal(15,2),
		`idmerr`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='udp mod info';

CREATE TABLE IF NOT EXISTS `udp` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`idgm`  decimal(15,2),
		`odgm`  decimal(15,2),
		`noport`        decimal(15,2),
		`idmerr`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(udp_1,udp_2) INSERT_METHOD=LAST;

-- tcp_1 info
CREATE TABLE IF NOT EXISTS `tcp_1` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`active`	decimal(15,2),
		`pasive`	decimal(15,2),
		`iseg`	decimal(15,2),
		`outseg`	decimal(15,2),
		`retran`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='tcp mod info';

-- tcp_2 info
CREATE TABLE IF NOT EXISTS `tcp_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`active`        decimal(15,2),
		`pasive`        decimal(15,2),
		`iseg`  decimal(15,2),
		`outseg`        decimal(15,2),
		`retran`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='tcp mod info';

CREATE TABLE IF NOT EXISTS `tcp` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`active`        decimal(15,2),
		`pasive`        decimal(15,2),
		`iseg`  decimal(15,2),
		`outseg`        decimal(15,2),
		`retran`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(tcp_1,tcp_2) INSERT_METHOD=LAST;

-- mem_1 info
CREATE TABLE IF NOT EXISTS `mem_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`free`	decimal(15,2),
		`used`	decimal(15,2),
		`buff`	decimal(15,2),
		`cach`	decimal(15,2),
		`total`	decimal(15,2),
		`util`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='mem mod info';

-- mem_2 info
CREATE TABLE IF NOT EXISTS `mem_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`free`  decimal(15,2),
		`used`  decimal(15,2),
		`buff`  decimal(15,2),
		`cach`  decimal(15,2),
		`total` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='mem mod info';

CREATE TABLE IF NOT EXISTS `mem` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`free`  decimal(15,2),
		`used`  decimal(15,2),
		`buff`  decimal(15,2),
		`cach`  decimal(15,2),
		`total` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(mem_1,mem_2) INSERT_METHOD=LAST;

-- load_1 info
CREATE TABLE IF NOT EXISTS `load_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`load1`	decimal(8,2),
		`load5`	decimal(8,2),
		`load15`	decimal(8,2),
		`runq`	decimal(8,2),
		`plit`	decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='load mod info';

-- load_2 info
CREATE TABLE IF NOT EXISTS `load_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`load1` decimal(8,2),
		`load5` decimal(8,2),
		`load15`        decimal(8,2),
		`runq`  decimal(8,2),
		`plit`  decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='load mod info';

CREATE TABLE IF NOT EXISTS `load` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`load1` decimal(8,2),
		`load5` decimal(8,2),
		`load15`        decimal(8,2),
		`runq`  decimal(8,2),
		`plit`  decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(load_1,load_2) INSERT_METHOD=LAST;

-- partition_1 info
CREATE TABLE IF NOT EXISTS `partition_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`bfree`	decimal(15,2),
		`bused`	decimal(15,2),
		`btotl`	decimal(15,2),
		`util`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='partition mod info';

-- partition_2 info
CREATE TABLE IF NOT EXISTS `partition_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`bfree` decimal(15,2),
		`bused` decimal(15,2),
		`btotl` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='partition mod info';

CREATE TABLE IF NOT EXISTS `partition` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`bfree` decimal(15,2),
		`bused` decimal(15,2),
		`btotl` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(partition_1,partition_2) INSERT_METHOD=LAST;

-- swap_1 info
CREATE TABLE IF NOT EXISTS `swap_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`swpin`	decimal(15,2),
		`swpout`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='swap mod info';

-- swap_2 info
CREATE TABLE IF NOT EXISTS `swap_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`swpin` decimal(15,2),
		`swpout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='swap mod info';

CREATE TABLE IF NOT EXISTS `swap` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`swpin` decimal(15,2),
		`swpout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(swap_1,swap_2) INSERT_METHOD=LAST;

-- pcsw_1 info
CREATE TABLE IF NOT EXISTS `pcsw_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`cswch`	decimal(8,2),
		`proc`	decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='pcsw mod info';

-- pcsw_2 info
CREATE TABLE IF NOT EXISTS `pcsw_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`cswch` decimal(8,2),
		`proc`  decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='pcsw mod info';

CREATE TABLE IF NOT EXISTS `pcsw` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`cswch` decimal(8,2),
		`proc`  decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(pcsw_1,pcsw_2) INSERT_METHOD=LAST;

-- switch_1 info
CREATE TABLE IF NOT EXISTS `switch_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytein`	decimal(15,2),
		`byteout`	decimal(15,2),
		`pktin`		decimal(15,2),
		`pktout`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`,`port`)
		) ENGINE=MyISAM COMMENT='switch info';

-- switch_2 info
CREATE TABLE IF NOT EXISTS `switch_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytein`        decimal(15,2),
		`byteout`       decimal(15,2),
		`pktin`         decimal(15,2),
		`pktout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`,`port`)
		) ENGINE=MyISAM COMMENT='switch info';

CREATE TABLE IF NOT EXISTS `switch` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytein`        decimal(15,2),
		`byteout`       decimal(15,2),
		`pktin`         decimal(15,2),
		`pktout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`,`port`)
		) ENGINE=MERGE UNION=(switch_1,switch_2) INSERT_METHOD=LAST;

-- traffic_1 info
CREATE TABLE IF NOT EXISTS `traffic_1` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytin`        decimal(15,2),
		`bytout`       decimal(15,2),
		`pktin`         decimal(15,2),
		`pktout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='traffic info';

-- traffic_2 info
CREATE TABLE IF NOT EXISTS `traffic_2` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytin`        decimal(15,2),
		`bytout`       decimal(15,2),
		`pktin`         decimal(15,2),
		`pktout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='traffic info';

CREATE TABLE IF NOT EXISTS `traffic` (
		`host_name` varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`port`  varchar(64) NOT NULL default '',
		`bytin`        decimal(15,2),
		`bytout`       decimal(15,2),
		`pktin`         decimal(15,2),
		`pktout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(traffic_1,traffic_2) INSERT_METHOD=LAST;

-- squid_1 info
CREATE TABLE IF NOT EXISTS `squid_1` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`   decimal(15,2),
		`rt`    decimal(15,2),
		`r_hit` decimal(15,2),
		`b_hit`	decimal(15,2),
		`d_hit` decimal(15,2),
		`m_hit`	decimal(15,2),
		`fdused`	decimal(15,2),
		`fdque`	decimal(15,2),
		`objs`	decimal(15,2),
		`inmem`	decimal(15,2),
		`hot`	decimal(15,2),
		`size`	decimal(15,2),
		`totalp`	decimal(15,2),
		`livep`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='squid info';

-- squid_2 info
CREATE TABLE IF NOT EXISTS `squid_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`   decimal(15,2),
		`rt`    decimal(15,2),
		`r_hit` decimal(15,2),
		`b_hit` decimal(15,2),
		`d_hit` decimal(15,2),
		`m_hit` decimal(15,2),
		`fdused`        decimal(15,2),
		`fdque` decimal(15,2),
		`objs`  decimal(15,2),
		`inmem` decimal(15,2),
		`hot`   decimal(15,2),
		`size`  decimal(15,2),
		`totalp`        decimal(15,2),
		`livep` decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='squid info';

CREATE TABLE IF NOT EXISTS `squid` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`qps`   decimal(15,2),
		`rt`    decimal(15,2),
		`r_hit` decimal(15,2),
		`b_hit` decimal(15,2),
		`d_hit` decimal(15,2),
		`m_hit` decimal(15,2),
		`fdused`        decimal(15,2),
		`fdque` decimal(15,2),
		`objs`  decimal(15,2),
		`inmem` decimal(15,2),
		`hot`   decimal(15,2),
		`size`  decimal(15,2),
		`totalp`        decimal(15,2),
		`livep` decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(squid_1,squid_2) INSERT_METHOD=LAST;

-- io_1 info
CREATE TABLE IF NOT EXISTS `io_1` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`rrqms`	decimal(15,2),
		`wrqms`	decimal(15,2),
		`rs`	decimal(15,2),
		`ws`	decimal(15,2),
		`rsecs` decimal(15,2),
		`wsecs` decimal(15,2),
		`rqsize`        decimal(15,2),
		`qusize`	decimal(15,2),
		`await` decimal(15,2),
		`svctm`	decimal(15,2),
		`util`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='iostat info';

-- io_2 info
CREATE TABLE IF NOT EXISTS `io_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`rrqms` decimal(15,2),
		`wrqms` decimal(15,2),
		`rs`    decimal(15,2),
		`ws`    decimal(15,2),
		`rsecs` decimal(15,2),
		`wsecs` decimal(15,2),
		`rqsize`        decimal(15,2),
		`qusize`        decimal(15,2),
		`await` decimal(15,2),
		`svctm` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='iostat info';

CREATE TABLE IF NOT EXISTS `io` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`rrqms` decimal(15,2),
		`wrqms` decimal(15,2),
		`rs`    decimal(15,2),
		`ws`    decimal(15,2),
		`rsecs` decimal(15,2),
		`wsecs` decimal(15,2),
		`rqsize`        decimal(15,2),
		`qusize`        decimal(15,2),
		`await` decimal(15,2),
		`svctm` decimal(15,2),
		`util`  decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(io_1,io_2) INSERT_METHOD=LAST;

-- haproxy_1 info
CREATE TABLE IF NOT EXISTS `haproxy_1` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`stat`	int(11),
		`uptime`	decimal(15,2),
		`conns`	decimal(15,2),
		`qps`	decimal(15,2),
		`hit`	decimal(15,2),
		`rt`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='haproxy info';

-- haproxy_2 info
CREATE TABLE IF NOT EXISTS `haproxy_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`stat`  int(11),
		`uptime`        decimal(15,2),
		`conns`	decimal(15,2),
		`qps`	decimal(15,2),
		`hit`	decimal(15,2),
		`rt`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='haproxy info';

CREATE TABLE IF NOT EXISTS `haproxy` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`stat`  int(11),
		`uptime`        decimal(15,2),
		`conns`	decimal(15,2),
		`qps`	decimal(15,2),
		`hit`	decimal(15,2),
		`rt`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(haproxy_1,haproxy_2) INSERT_METHOD=LAST;

-- lvs_1 info
CREATE TABLE IF NOT EXISTS `lvs_1` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`	int(11) NOT NULL default '0',
		`stat`	int(11) default '-1',
		`conns`	decimal(15,2),
		`pktin`	decimal(15,2),
		`pktout`	decimal(15,2),
		`bytin`	decimal(15,2),
		`bytout`	decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='lvs info';

-- lvs_2 info
CREATE TABLE IF NOT EXISTS `lvs_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`stat`  int(11) default '-1',
		`conns` decimal(15,2),
		`pktin` decimal(15,2),
		`pktout`        decimal(15,2),
		`bytin` decimal(15,2),
		`bytout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='lvs info';

CREATE TABLE IF NOT EXISTS `lvs` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`stat`  int(11) default '-1',
		`conns` decimal(15,2),
		`pktin` decimal(15,2),
		`pktout`        decimal(15,2),
		`bytin` decimal(15,2),
		`bytout`        decimal(15,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(lvs_1,lvs_2) INSERT_METHOD=LAST;

-- extend_1 table
CREATE TABLE IF NOT EXISTS `extend_1` (
		`host_name`	varchar(64) NOT NULL default '',
		`time`	int(11)	NOT NULL default '0',
		`value`	varchar(1024),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='extern table for more interface';

-- extend_2 table
CREATE TABLE IF NOT EXISTS `extend_2` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`value` varchar(1024),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MyISAM COMMENT='extern table for more interface';

CREATE TABLE IF NOT EXISTS `extend` (
		`host_name`     varchar(64) NOT NULL default '',
		`time`  int(11) NOT NULL default '0',
		`value` varchar(1024),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(extend_1,extend_2) INSERT_METHOD=LAST;

-- add ts table
CREATE TABLE IF NOT EXISTS `ts_cache_1` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `hit`  decimal(18,2),
                `ramhit`  decimal(18,2),
                `band`  decimal(18,2),
                `n_hit`  decimal(18,2),
                `n_ram`  decimal(18,2),
                `n_ssd`  decimal(18,2),
                `ssdhit` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

-- ts_cache_2 info
CREATE TABLE IF NOT EXISTS `ts_cache_2` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `hit`  decimal(18,2),
                `ramhit`  decimal(18,2),
                `band`  decimal(18,2),
                `n_hit`  decimal(18,2),
                `n_ram`  decimal(18,2),
                `n_ssd`  decimal(18,2),
                `ssdhit` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_cache` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `hit`  decimal(18,2),
                `ramhit`  decimal(18,2),
                `band`  decimal(18,2),
                `n_hit`  decimal(18,2),
                `n_ram`  decimal(18,2),
                `n_ssd`  decimal(18,2),
                `ssdhit` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MERGE UNION=(ts_cache_1,ts_cache_2) INSERT_METHOD=LAST;



-- add ts table
CREATE TABLE IF NOT EXISTS `ts_client_1` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `MBps`  decimal(18,2),
                `uattc`  decimal(18,2),
                `uattt`  decimal(18,2),
                `rt`  decimal(18,2),
                `rpc` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_client_2` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `MBps`  decimal(18,2),
                `uattc`  decimal(18,2),
                `uattt`  decimal(18,2),
                `rt`  decimal(18,2),
                `rpc` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_client` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `MBps`  decimal(18,2),
                `uattc`  decimal(18,2),
                `uattt`  decimal(18,2),
                `rt`  decimal(18,2),
                `rpc` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MERGE UNION=(ts_client_1,ts_client_2) INSERT_METHOD=LAST;
-- add ts table
CREATE TABLE IF NOT EXISTS `ts_err_1` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `host`  decimal(18,2),
                `abort`  decimal(18,2),
                `p_h`  decimal(18,2),
                `emp_h`  decimal(18,2),
                `ear_h`  decimal(18,2),
                `conn`  decimal(18,2),
                `other` decimal(18,2),
                `hangup` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_err_2` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `host`  decimal(18,2),
                `abort`  decimal(18,2),
                `p_h`  decimal(18,2),
                `emp_h`  decimal(18,2),
                `ear_h`  decimal(18,2),
                `conn`  decimal(18,2),
                `other` decimal(18,2),
                `hangup` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_err` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `host`  decimal(18,2),
                `abort`  decimal(18,2),
                `p_h`  decimal(18,2),
                `emp_h`  decimal(18,2),
                `ear_h`  decimal(18,2),
                `conn`  decimal(18,2),
                `other` decimal(18,2),
                `hangup` decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MERGE UNION=(ts_err_1,ts_err_2) INSERT_METHOD=LAST;
-- add ts table
CREATE TABLE IF NOT EXISTS `ts_os_1` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `mbps`  decimal(18,2),
                `rpc`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_os_2` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `mbps`  decimal(18,2),
                `rpc`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_os` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `qps`  decimal(18,2),
                `cons`  decimal(18,2),
                `mbps`  decimal(18,2),
                `rpc`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MERGE UNION=(ts_os_1,ts_os_2) INSERT_METHOD=LAST;

-- add ts table
CREATE TABLE IF NOT EXISTS `ts_storage_1` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `ram`  decimal(18,2),
                `disk`  decimal(18,2),
                `objs`  decimal(18,2),
                `size`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_storage_2` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `ram`  decimal(18,2),
                `disk`  decimal(18,2),
                `objs`  decimal(18,2),
                `size`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MyISAM COMMENT='ts_cache mod info';

CREATE TABLE IF NOT EXISTS `ts_storage` (
                `host_name` varchar(64) NOT NULL default '',
                `time`  int(11) NOT NULL default '0',
                `ram`  decimal(18,2),
                `disk`  decimal(18,2),
                `objs`  decimal(18,2),
                `size`  decimal(18,2),
                `view_time` timestamp default current_timestamp,
                PRIMARY KEY(`view_time`,`host_name`)
                ) ENGINE=MERGE UNION=(ts_storage_1,ts_storage_2) INSERT_METHOD=LAST;
