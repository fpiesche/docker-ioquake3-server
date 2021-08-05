# Dockerised ioquake3 server

![build](https://github.com/fpiesche/docker-ioquake3-server/actions/workflows/main.yml/badge.svg)

# Quick reference

- **Image Repositories**:
    - Docker Hub: [`florianpiesche/ioquake3-server`](https://hub.docker.com/r/florianpiesche/ioquake3-server)  
    - GitHub Packages: [`ghcr.io/fpiesche/ioquake3-server`](https://ghcr.io/fpiesche/ioquake3-server)  

- **Maintained by**:  
  	[Florian Piesche](https://github.com/fpiesche)

-	**Where to file issues**:  
    [https://github.com/fpiesche/ioquake3-server/issues](https://github.com/fpiesche/ioquake3-server/issues)

- **Dockerfile**:  
    [https://github.com/fpiesche/docker-ioquake3-server/blob/main/Dockerfile](https://github.com/fpiesche/docker-ioquake3-server/blob/main/Dockerfile)

-	**Supported architectures**:  
    Each image is a multi-arch manifest for the following architectures:  
    `amd64`, `arm64`, `armv7`, `armv6`

- **Source of this description**:  
    [Github README](https://github.com/fpiesche/docker-ioquake3-server/tree/main/README.md) ([history](https://github.com/fpiesche/docker-ioquake3-server/commits/main/README.md))

# Supported tags

`latest` is based on the most recent released Alpine base image and its respective system packages and built from the latest commit to [ioquake3's `main` branch](https://github.com/ioquake/ioq3/tree/main). 

Images are also tagged with the shorthand commit ID for the ioquake3 commit they are built from.

# How to use this image

You will need a copy of the Quake 3 Arena data files to mount into the container at `/usr/local/games/quake3/baseq3`. You can obtain these by copying the contents of the `baseq3` directory from an installed copy of Quake 3 Arena. The game is legally available for digital purchase from numerous sources; while the game engine and server are open source, the game data remains copyrighted and is not legally available for free.

To run the game in a basic deathmatch configuration:

```console
$ docker run -d \
  -p 27960:27960/udp \
  -v /home/myuser/baseq3:/usr/local/games/quake3/baseq3 \
  florianpiesche/ioquake3-server
```

Once startup completes, the Quake 3 server should be accessible using the IP address or hostname of your host computer.

## Advanced configuration

For detailed information on configuring an ioquake3 server, please refer to the [ioquake3 sysadmin guide](https://ioquake3.org/help/sys-admin-guide/)

### Admin console

In order to control the server after startup, your easiest option is to connect to the server using a Quake 3 game client and using the `rcon` (remote console) feature. You will want to set a custom administrator password for the server using the `ADMIN_PASSWORD` environment variable when running the container:

```console
$ docker run -d \
  -p 27960:27960/udp \
  -e ADMIN_PASSWORD=my_custom_admin_password \
  -v /home/myuser/baseq3:/usr/local/games/quake3/baseq3 \
  florianpiesche/ioquake3-server
```

Once connected, open the console using the ``` or `~` key (this will depend on your keyboard layout; usually it's the key to the left of the number row on the main keyboard).

Then, log in to the remote console by entering the `\rconpassword my_custom_admin_password` command. From this point on, while you remain connected to the server, you can run any standard Quake 3 console command using the command `\rcon [command]` in the in-game console, e.g. to change map issue the command `\rcon map q3dm17`.

For some information on commonly used Quake 3 console commands, please refer to the [ioquake3 sysadmin guide](https://ioquake3.org/help/sys-admin-guide/#useful). There are other, more exhaustive guides on the Quake 3 console's commands and variables available, e.g. [this one](http://sites.quake.cz/maxell/htm/console.htm).

### Custom greeting

To change the greeting players receive when connecting to your server, simply set the `SERVER_MOTD` environment variable when running the container:

```console
$ docker run -d \
  -p 27960:27960/udp \
  -e SERVER_MOTD="pew pew" \
  -v /home/myuser/baseq3:/usr/local/games/quake3/baseq3 \
  florianpiesche/ioquake3-server
```

### Server command-line parameters

In order to execute console commands on the Quake 3 server as it starts up, you can add them to the server's command line arguments using `+` as a prefix. The server's command line arguments for this container can be set via the `SERVER_ARGS` environment variable. For example, to make the server load the `q3dm17` map on start-up:

```console
$ docker run -d \
  -p 27960:27960/udp \
  -e SERVER_ARGS="+map q3dm17" \
  -v /home/myuser/baseq3:/usr/local/games/quake3/baseq3 \
  florianpiesche/ioquake3-server
```

### Custom server configuration files

If you want to make significant amounts of changes to the game's default configuration, for example to set up a custom map rotation, it is usually easier to create a custom configuration file than to pass all the necessary commands to the server as command-line arguments. Configuration files are plain text files that just contain a sequence of Quake 3 console commands, one per line. You can run these from the server console using the `exec` console command.

If you want to use a custom server configuration file with this container, you can mount your configuration files into the `/usr/local/games/quake3/configs/` directory and the container entrypoint will make them accessible to the server on startup. You can then run them on server startup by setting the `SERVER_ARGS` environment variable to include e.g. `+exec myconfig.cfg`:

```console
$ docker run -d \
  -p 27960:27960/udp \
  -v /home/myuser/baseq3:/usr/local/games/quake3/baseq3 \
  -v /home/myuser/myq3configs:/usr/local/games/quake3/configs \
  -e SERVER_ARGS="+exec myconfig.cfg" \
  florianpiesche/ioquake3-server
```

### Mods

Any mods you want to run can also be mounted into directories in the `ioquake3` directory, e.g. a copy of the Catch the Chicken mod can be mounted at `/usr/local/games/quake3/q3ctc` and thus accessed from the game. To run mods, add `+set fs_game mod_directory` to your `SERVER_ARGS`, or run the `set fs_game mod_directory` command from the server admin console.

```console
$ docker run -d \
  -p 27960:27960/udp \
  -v /home/myuser/quake3/data/baseq3:/usr/local/games/quake3/baseq3 \
  -v /home/myuser/quake3/mods/q3ctc:/usr/local/games/quake3/q3ctc \
  -e SERVER_ARGS="+set fs_game q3ctc" \
  florianpiesche/ioquake3-server
```

## Using docker-compose

The easiest way to get a reproducible setup you can start, stop and resume at will is using a `docker-compose` file. There are too many different possibilities to setup your system, so here are only some examples of what you have to look for.

To use a compose file, create a file called `docker-compose.yaml` in a new, empty directory on your host computer and paste in this data:

```yaml
version: '3.2'

volumes:
  baseq3:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/myuser/quake3/data/baseq3'
  q3ctc:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/myuser/quake3/mods/q3ctc'

services:
  cups:
    image: florianpiesche/ioquake3-server
    restart: always
    volumes:
      - baseq3:/usr/local/games/quake3/baseq3
      - q3ctc:/usr/local/games/quake3/q3ctc
    ports:
      - 27960:27960/udp
    env:
      SERVER_MOTD: "buhGAWK!"
      ADMIN_PASSWORD: "lookatmycluckers"
      SERVER_ARGS: "+game q3ctc +exec server_q3ctc.cfg"
```

Then run `docker-compose up -d` in the directory holding the compose file, and the Quake 3 server will start up. You can stop the server at any point using `docker-compose down`, and resume it again with your stored configuration by re-running `docker-compose up -d`.
