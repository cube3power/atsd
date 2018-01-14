# scollector Startup

## Linux

### Script Installation

```bash
mkdir scollector
cd scollector
wget https://github.com/bosun-monitor/bosun/releases/download/0.6.0-beta1/scollector-linux-amd64
# replace usr and pwd with actual credentials for a collector account
echo 'Host = "http://username:password@10.102.0.6:8088/"' > scollector.toml
chmod 700 scollector-linux-amd64
nohup ./scollector-linux-amd64 &
```

### Manual Installation

Download the binary file from: [http://bosun.org/scollector/](http://bosun.org/scollector/).

You can find the official configuration guides here: [http://godoc.org/bosun.org/cmd/scollector](http://godoc.org/bosun.org/cmd/scollector).

Alternatively, you can use the "scollector Cookbook" to install scollector on your machines: [https://supermarket.chef.io/cookbooks/scollector](https://supermarket.chef.io/cookbooks/scollector).

Create the `scollector.toml` Configuration File:

Navigate to the directory with binary files and create the `scollector.toml` file.

> Make sure the name of the file is `scollector.toml`.

Add `Host` setting to `scollector.toml`:

```toml
Host = "http://atsd_username:atsd_password@atsd_server:8088/"
```

> If you installed a CA-signed SSL certificate into ATSD, you can change the above url to the secure https endpoint.

> At this time scollector does not support communication with ATSD if it’s SSL certificate is self-signed.

### Auto-start scollector under sudo user

Create an init script called `scollector` in the `/etc/init.d/` directory with the following contents:

```
#chkconfig: 2345 90 10
#description: scollector is a framework to collect data points and store them in a TSDB.
### BEGIN INIT INFO
# Provides: scollector
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start scollector
# Description:
### END INIT INFO
 
SCOLLECTOR_BIN=/home/axibase/scollector-linux-amd64
SCOLLECTOR_CONF=/home/axibase/scollector.toml
 
"$SCOLLECTOR_BIN" -conf="$SCOLLECTOR_CONF"
```

Be sure to change `SCOLLECTOR_BIN` and `SCOLLECTOR_CONF` to the actual scollector directory path.

Set execute flag:

```
chmod a+x /etc/init.d/scollector
```

Add scollector to startup:

On Ubuntu/Debian:

```
sudo update-rc.d scollector defaults 90 10
```

On RHEL/SUSE/SLES:

```
sudo chkconfig --add scollector
sudo touch /var/lock/subsys/scollector
```

###### Auto-start scollector as a non-sudo user

Modify the `/etc/init.d/tcollector` content:

```
#chkconfig: 2345 90 10
#description: scollector is a framework to collect data points and store them in a TSDB.
### BEGIN INIT INFO
# Provides: scollector
# Required-Start:
# Required-Stop:
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: start scollector
# Description:
### END INIT INFO
 
SCOLLECTOR_BIN=/home/axibase/scollector-linux-amd64
SCOLLECTOR_CONF=/home/axibase/scollector.toml
SCOLLECTOR_USER=axibase
 
if [ `whoami` != "$SCOLLECTOR_USER" ]; then
su - "$SCOLLECTOR_USER" -c "$SCOLLECTOR_BIN" -conf="$SCOLLECTOR_CONF"
else
"$SCOLLECTOR_BIN" -conf="$SCOLLECTOR_CONF"
fi
```

Be sure to change `SCOLLECTOR_BIN` and `SCOLLECTOR_CONF` to the actual scollector directory path.

Set `SCOLLECTOR_USER` to the user that will run scollector.


## Windows

1. Download scollector Windows executable from [http://bosun.org/scollector/](http://bosun.org/scollector/).

2. Navigate to the directory with the `exe` file and create a `scollector.toml` file in notepad.

  **NOTE**: Make sure the name of the file is `scollector.toml` and not `scollector.toml.txt`

3. Add the Host setting to `scollector.toml`:

  `Host = "http://atsd_username:atsd_password@atsd_server:8088/"`

  **NOTE**: If you installed a root-signed SSL certificate into ATSD, you can change the above url to the secure https endpoint.

  > At this time scollector does not support communication with ATSD if its SSL certificate is self-signed.

4. Open the prompt as Administrator and create a scollector service with automated startup by executing the following command:

`scollector-windows-amd64.exe -winsvc=install`

5. Start scollector service by executing the following command:

`scollector-windows-amd64.exe -winsvc=start`

> NOTE: If the service exits a few seconds after startup, it either cannot locate the `scollector.toml` file, this file is not valid/empty, or the Host parameter is specified without double quotes.
Open Windows event log and review service startup error.

> If the service is running but there are no scollector metrics in ATSD, verify the protocol, url, and user credentials specified in the `scollector.toml` file.


## MacOS

Download the binary file from: [http://bosun.org/scollector/](http://bosun.org/scollector/).

You can find the official configuration guides here: [http://godoc.org/bosun.org/cmd/scollector](http://godoc.org/bosun.org/cmd/scollector).

### Create `scollector.toml` configuration file:

Navigate to the directory with the binary files and create the `scollector.toml` file.

**NOTE**: Make sure the name of the file is `scollector.toml`

Add Host setting to `scollector.toml`:

`Host = "http://atsd_username:atsd_password@atsd_server:8088/"`

**NOTE**: If you installed a root-signed SSL certificate into ATSD, you can change the above url to the secure https endpoint.

> At this time scollector does not support communication with ATSD if its SSL certificate is self-signed.

### Add scollector to Startup

To start scollector on a system boot, add the `com.axibase.scollector.plist xml` file to the `/Library/LaunchDaemons` folder and replace the `$SCOLLECTOR_BIN` and `$SCOLLECTOR_CONF` placeholders with the correct directories.

`$SCOLLECTOR_BIN` – path to the scollector binary file
`$SCOLLECTOR_CONF` – path to the `scollector.toml` configuration file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
      <string>scollector</string>
    <key>ProgramArguments</key>
      <array>
        <string>$SCOLLECTOR_BIN</string>
        <string>-conf=$SCOLLECTOR_CONF</string>
      </array>
    <key>OnDemand</key>
      <false/>
  </dict>
</plist>
view raw
```
### Controlling scollector

`sudo launchctl load -w /Library/LaunchDaemons/com.axibase.scollector.plist` – load scollector launch configuration file
`sudo launchctl unload -w /Library/LaunchDaemons/com.axibase.scollector.plist` – unload scollector launch configuration file

`sudo launchctl stop scollector` – stop scollector daemon
