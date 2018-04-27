# Relocating ATSD Directory

By default, ATSD is installed in the `/opt/atsd` directory.

Execute the following steps if you need to move ATSD to a different file system.

1. Stop ATSD services

```sh
  /opt/atsd/atsd/atsd-all.sh stop
```

2. Verify that no ATSD services are running

```sh
   jps
```

   The output should list only the `jps` process itself.

```txt
   12150 Jps
```

3. Move ATSD to another directory such as `/opt/data/`

```sh
  sudo mv /opt/atsd /opt/data/
```

4. Create a symbolic link to the new ATSD directory

```sh
  ln -s /opt/data/atsd /opt/atsd
```

5. Start ATSD services

```sh
  /opt/atsd/atsd/atsd-all.sh start
```
