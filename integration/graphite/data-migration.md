# Data Migration from Graphite to ATSD

Use the `migrate.py` utility to migrate data from the Graphite server, specifically from its built-in Whisper database, to the Axibase Time Series Database.

The `migrate.py` utility extracts stored historical data from Whisper files and transfers it in Graphite format into ATSD.

[Download the migrate.py utility here.](https://github.com/axibase/atsd-graphite-finder/blob/master/bin/migrate.py)

Below are the available configurations and examples.

`migrate.py` supports only Whisper files (`.wsp`).

Data sent into ATSD by the `migrate.py` utility is parsed according to rules specified in the `graphite.conf` file.

Using `migrate.py`:

```sh
migrate.py [-h] [--whisper-base BASE] [-R] path atsd_hostname atsd_tcp_port
```

## migrate.py settings

| Setting | Required | Description |
| --- | --- | --- |
|  `-h` OR `--help`  |  no  |  Show help message and exit.  |
|  `path`  |  yes  |  Path to folder with `.wsp` files or `.wsp` file that will be exported to ATSD.<br>Path must be specified either:<br>– directly to the `.wsp` file (without `-R` setting)<br>OR<br>– to the folder containing `.wsp` files (with `-R` setting).<br>Note that the `~` symbol cannot be used when specifying path.  |
|  `-R`  |  no  |  Export recursively all files in the specified folder; searches are sub folders and directories for `.wsp` files.<br>If `-R` is not specified then you must specify the direct `path` to the `.wsp` file.  |
|  `--whisper-base BASE`  |  no  |  Base path to which all metric names will be resolved.<br>Recommended to set Whisper base directory.<br>Default value: `.` (current directory).  |
|  `atsd_hostname`  |  yes  |  ATSD hostname or IP.  |
|  `atsd_tcp_port`  |  yes  |  ATSD TCP listening port. Default ATSD TCP port is 8081.  |

## Examples

Base path to the Whisper database directory is set with `-R` to migrate all the data and metrics.

Command:

```sh
./migrate.py -R --whisper-root=/var/lib/graphite/whisper/ /var/lib/graphite/whisper/ atsd_hostname 8081
```

Messages sent to ATSD:

```sh
carbon.agents.NURSWGDKR002-a.avgUpdateTime 9.41753387451e-05 1436859240
carbon.agents.NURSWGDKR002-a.avgUpdateTime 9.3019925631e-05 1436859300
carbon.agents.NURSWGDKR002-a.avgUpdateTime 9.33683835543e-05 1436859360
...
collectd.NURSWGDKR002.users.users 4.0 1436878560
collectd.NURSWGDKR002.users.users 4.0 1436878620
collectd.NURSWGDKR002.users.users 4.0 1436878680
```

Direct path to a specific `.wsp` file is set without `-R` to migrate only the contained metric.

Command:

```sh
./migrate.py --whisper-root=/opt/graphite/whisper/ /opt/graphite/whisper/collectd/NURSWGDKR002/memory/memory-free.wsp atsd_hostname 8081
```

Messages sent to ATSD:

```sh
collectd.NURSWGDKR002.memory.memory-free 31467552768.0 1436867280
collectd.NURSWGDKR002.memory.memory-free 31480631296.0 1436867340
collectd.NURSWGDKR002.memory.memory-free 31409938432.0 1436867400
collectd.NURSWGDKR002.memory.memory-free 31384133632.0 1436867460
```

## Test Data Migration

Launch `nc` in server mode to record incoming commands to the `test.txt` file.

```sh
nc -lk 8081 > test.txt &
```

Substitute `--whisper-base`, the path, `atsd_hostname`, and `atsd_tcp_port` with actual parameters and launch the migration script.

```sh
date +%s && ./migrate.py -R --whisper-base=/var/lib/graphite/whisper/ /var/lib/graphite/whisper/ atsd_hostname atsd_tcp_port && date +%s
```

The resulting `test.txt` file will contain all metrics migrated by the `migrate.py` script.

```txt
9 seconds
730236 lines
49246203 bytes
```
