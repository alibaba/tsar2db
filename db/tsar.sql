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
		`ncpu`	decimal(8,2),
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
		`ncpu`	decimal(8,2),
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
		`ncpu`	decimal(8,2),
		`view_time` timestamp default current_timestamp,
		PRIMARY KEY(`view_time`,`host_name`)
		) ENGINE=MERGE UNION=(cpu_1,cpu_2) INSERT_METHOD=LAST;

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
