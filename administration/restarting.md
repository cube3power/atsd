# Restarting

ATSD provides scripts to control the database and its components.

Use these scripts to stop, start, and update ATSD.

## Permissions

If logged in as root or another user, change user to 'axibase' to ensure that no files are locked.

```sh
su axibase
```

## Script Directory

The scripts are located in the `/opt/atsd/bin` directory.

| **Name** | **Description** | **Arguments** | **Example** |
|---|:---|---|---|
| `/opt/atsd/bin/atsd-all.sh` | Start, stop, and get status of all services. | start, stop, status  |
| `/opt/atsd/bin/atsd-tsd.sh` | Start, stop, and get status of ATSD. | start, stop, status |
| `/opt/atsd/bin/atsd-hbase.sh` | Start, stop, and get status of HBase. | start, stop, status  |
| `/opt/atsd/bin/atsd-dfs.sh` | Start, stop, and get status of HDFS. | start, stop, status  |
| `/opt/atsd/bin/update.sh` | [Update ATSD](update.md) in interactive mode.<br>`-t` - Upgrade and restart ATSD.<br>`-a` - Upgrade and restart ATSD, HBase, and HDFS.| -a, -t  |

Examples

```sh
/opt/atsd/bin/atsd-tsd.sh status
```

```sh
/opt/atsd/bin/update.sh
```

## Processes

Switch to the `axibase` user. 

Run the `jps` utility to display Java processes running under the current user.

```java
27392 Jps
22110 Server
18494 HMaster
18387 HQuorumPeer
18673 HRegionServer
25587 NameNode
25961 SecondaryNameNode
25790 DataNode
```

## Process Types

| **Type** | **Process Name** |
|---|---|
| HDFS | DataNode |
| HDFS | SecondaryNameNode |
| HDFS | NameNode |
| HBase | HRegionServer |
| HBase | HQuorumPeer |
| HBase | HMaster |
| ATSD | Server |

> HBase installed in the ATSD Docker container is configured to run in non-distributed mode without `HRegionServer` and `HQuorumPeer` processes.

## Restarting All Services

The script will stop ATSD, HBase, and HDFS.

```
/opt/atsd/bin/atsd-all.sh stop
```

The script will start HDFS, HBase, and ATSD.

```
/opt/atsd/bin/atsd-all.sh start
```


### Docker Container

To restart and update an ATSD instance running in a Docker container, open a `bash` session.

```sh
docker exec -it atsd bash
```

Execute scripts as usual.

```sh
/opt/atsd/bin/update.sh
```

## Stopping Services

### Stop ATSD

Stop ATSD.

```
/opt/atsd/bin/atsd-tsd.sh stop
```

Verify that the `Server` process is **not** present in `jps` output.

```sh
jps
```

If the `Server` process is still running, kill it forcefully with `kill -9 {Server-pid}`.

### Stop HBase

Stop HBase.

```sh
/opt/atsd/bin/atsd-hbase.sh stop
```

Verify that the `HMaster`, `HRegionServer`, `HQuorumPeer` processes are **not** present in the `jps` output:

```sh
jps
```

The `jps` output should display only HDFS processes at this time.

```
27392 Jps
25961 SecondaryNameNode
25790 DataNode
25587 NameNode
```

If any HBase processes are still running, execute the following commands.

```sh
/opt/atsd/hbase/bin/hbase-daemon.sh stop regionserver
/opt/atsd/hbase/bin/hbase-daemon.sh stop master
/opt/atsd/hbase/bin/hbase-daemon.sh stop zookeeper
```

If HBase processes are still running, kill HBase processes by PID (no flags).

> Make sure you kill only HBase processes `HMaster`, `HRegionServer`, `HQuorumPeer` in this step.

```sh
kill 18494
```

### Stop HDFS

```sh
/opt/atsd/bin/atsd-dfs.sh stop
```

## Starting Services

Run `jps` to check which processes are running.

### Start HDFS

```sh
/opt/atsd/bin/atsd-dfs.sh start
```

### Start HBase

```sh
/opt/atsd/bin/atsd-hbase.sh start
```

### Start ATSD

```sh
/opt/atsd/bin/atsd-tsd.sh start
```

## Troubleshooting

### Invalid Zookeeper Cache

If ATSD fails to start, check if the `/opt/atsd/atsd/logs/atsd.log` file contains the `TableExistsException` error for any table, clean the Zookeeper cache.

```sh
cat /opt/atsd/atsd/logs/atsd.log | grep -C 5 "TableExistsException"
```

```ls
Caused by:
  org.apache.hadoop.ipc.RemoteException:
  org.apache.hadoop.hbase.TableExistsException: atsd_message
```

Execute the command to remove the ephemeral `/hbase` directory from Zookeeper cache.

```sh
echo "rmr /hbase" | /opt/atsd/hbase/bin/hbase zkcli
```

### Zookeeper Inconsistency

If HBase fails to start, check if the HBase master log contains the __Master not active__ error:

```sh
cat /opt/atsd/hbase/logs/hbase-*-master-*.log | grep -C 5 "Master not active"
```

```ls
2017-09-15 05:24:43,982 ERROR master.HMasterCommandLine - Master exiting
java.lang.RuntimeException: Master not active after 30 seconds
	at org.apache.hadoop.hbase.util.JVMClusterUtil.startup(JVMClusterUtil.java:194)
	at org.apache.hadoop.hbase.LocalHBaseCluster.startup(LocalHBaseCluster.java:449)
```

Verify that no HBase processes are running with `jps`. 

Remove the Zookeper data directory.

```
rm -rf /opt/atsd/hbase/zookeeper
```

Start HBase.

### File Permissions

#### JPS

The `/opt/atsd/bin/atsd-all.sh` script relies on the **[jps](http://docs.oracle.com/javase/7/docs/technotes/tools/share/jps.html)** utility to determine that Java processes are started in the correct order.

The `jps` utility requires write permissions to the `/tmp/hsperfdata_axibase` directory in order to store temporary files. If permissions to this directory are missing when it is owned by root, `jps` returns an incomplete process list, even if processes are running and can be listed with `ps aux | grep java`.

If `jps` output is incomplete, the `atsd-all.sh` script aborts the startup procedure with the following message:

```
nurswgvml007 atsdService: * [ATSD] DataNode is not running.
```

* Solution: Stop all ATSD services. Remove the `/tmp/hsperfdata_axibase` directory.

#### Temporary Files

ATSD uses `/tmp/atsd` directory to store temporary files. If this directory is owned by root, ATSD cannot function properly.

* Solution: Stop all ATSD services. Grant ownership to `/tmp/atsd` directory to the 'axibase' user.

```sh
chown -R axibase:axibase /tmp/atsd
```

#### `/opt/atsd` directory

ATSD uses the `/opt/atsd` directory to store log files, backup files, and other files. If this directory is owned by root, ATSD cannot function properly.

* Solution: Stop all ATSD services. Grant ownership to `/opt/atsd` directory to the 'axibase' user.

```sh
chown -R axibase:axibase /opt/atsd
```
