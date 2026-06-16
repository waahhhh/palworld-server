# palworld-server

## App ID

| ID      | Name                      |
|---------|---------------------------|
| 2394010 | Palworld Dedicated Server |

## References

- Docker Image: https://hub.docker.com/r/steamcmd/steamcmd
- SteamCMD: https://developer.valvesoftware.com/wiki/SteamCMD
- SteamCMD CLI: https://developer.valvesoftware.com/wiki/Command_Line_Options
- Dedicated Server: https://steamdb.info/app/2394010/
- Dedicated Server Documentation: https://docs.palworldgame.com/
- Game: https://store.steampowered.com/app/1623730/Palworld/

## System Requirements

### Software

* Docker
* Docker Compose
* Git
* Git LFS

### Memory

Idle: ~ 1 GB
Active: up to 32 GB at least 16 GB

### Storage

Native: ~ 4 GB

### CPU

4 Cores

### Ports

| Protocol | Port  | Description         |
|----------|-------|---------------------|
| UDP      | 8211  | Default Server Port |
| TCP      | 25575 | RCON                |

## Configuration

Make changes to `/docker/config/values.ini`!  

The `PalWorldSettings.ini` file expects a format with poor usability.  
Override the values of `docker/config/PalWorldSettings.ini` or from the [official documentation](https://docs.palworldgame.com/settings-and-operation/configuration).  

To roll out the configuration use [Override Server Configuration](#override-server-configuration).  

## Setup

### Prepare the Dedicated Server

This script is used to set up the dedicated server once including the docker container.  

```shell
./setup.sh
```

### Run Server

This script is used to start the server.  
On production the server will restart automatically.  

```shell
./startDocker.sh
```

## Manage

### Stop Server

This script is used to stop the server.  
On production the server won't start automatically anymore.

```shell
./stopDocker.sh
```

### Restart Server

This scripts stops the server (`stopDocker.sh`) and starts the server (`startDocker.sh`).  

```shell
./restartDocker.sh
```

### Update Server

This script is used to update the dedicated server files.  

```shell
./update.sh
```

### Override Server Configuration

This script is used to override the dedicated server configuration.  
It provides the following features:  

- Manage configuration in a user-friendly way
- Use environment variables from the `.env` file

the content of `/docker/config/values.ini` is used to write the formatted `PalWorldSettings.ini`.  
The content of `docker/config/additional.ini` is appended to the configuration without formatting.  

```shell
./updateConfig.sh
```

### Backup Server

This script copies the complete game directory of the server into the directory `backup/snapshot`.  
Existing backups will be removed first.

```shell
./backup.sh
```

