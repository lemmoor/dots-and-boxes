# Dots and Boxes
A game made in react with socket.io for multiplayer functionality and node.js for backend.  
**Links**:
* [**Dots and Boxes**](https://dots-and-boxes-production.up.railway.app/)
* [**You can view this README in a form of website.**](https://dots-info.cimlah.art)
* [**GitHub**](https://github.com/lemmoor/dots-game)
* [**DockerHub**](https://hub.docker.com/r/cimlah/dots-game)


## Build
Before building the project, in the `web/src/components/Multiplayer.js` file, change this line of code: ``const s = io(`http://${window.location.hostname}:5000`)`` to `const s = io()`  
Also, in the `server/index.js` add this code:
```js
const path = require('path');
const io = require('socket.io')(server);

app.use(express.static(path.join(__dirname, 'build')));

app.get('/*', function (req, res) {
    res.sendFile(path.join(__dirname, 'build', 'index.html'));
});
```

To build a production version of the project run `npm run build` inside the web directory.

## Docker
In this project, Docker is used to easily set up hosting `Dots and Boxes` app.

### TLDR
Probably some of you may want to quickly set everything up, in this case, here is a short guide.  
Clone repository or create file named `docker-compose.yml` containing this:
``` yml
version: '3.3'

services:
  dots-game:
    image: cimlah/dots-game:latest
    restart: unless-stopped
    hostname: dots-game1
    container_name: dots-game1
    command: bash -c 'web/Docker/app-start.sh'
    volumes:
      - ../../.:/usr/src/app
    
    ports:
      - "5001:5001"
    tty: true
    networks:
      dots-game_network:
        ipv4_address: 172.21.1.2


networks:
  dots-game_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: "172.21.1.0/24"
```

and execute command: `docker-compose up -d`.


### Dockerfile
This Docker image is based on [Node version 16](https://hub.docker.com/_/node). It contains of instructions to copy all of project's files into the work directory (except those excluded in `.dockerignore`). At the end, all dependencies are installed using `npm install`.


### docker-compose.yml
*Version 3.3* is used for the compose file. Most of the container's behaviour is set in `docker-compose.yml` intead of `Dockerfile` in favour of customasibility, although there are some things worth keeping in mind:
* Only host port, not container port should be changed. It could be for example: `"4200:5001"` or `"2137:5001"`, but not `"5001:5004"`, because server in *NodeJS* runs on port `5001`. **But it can be changed too, if you know how to.**
* If virtual network (or an IP address assigned to container) created by `docker-compose.yml` is already present on your computer, then you can adjust subnet, for example istead of `subnet: "172.21.1.0/24"` it could be `subnet: "172.21.3.0/24"`.  
You can also make this container use a *dynamic IP address*, just delete these lines:
``` yml
networks:
      dots-game_network:
        ipv4_address: 172.21.1.2
```

and

``` yml
networks:
  dots-game_network:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: "172.21.1.0/24"
```

* You can adjust commands, which are executed on container start in `app-start.sh` file or by completely changing `command: ` line.


### app-start.sh
This is a bash script, which is used for executing commands on container start.


### docker-build.sh
This is a bash script, which is used to build a Docker image. Also, there is a symlink located in the root directory of the repository. An intended action to build an image is to execute mentioned symlink.


## HAProxy - load balancing
In the root directory of the repository is a directory named `HAProxy`, which contains an example `haproxy.cfg`.  
If you wish to asign a domain name or a subdomain to server hosted by You, this file and generally speaking load balancing comes in handy.  
Setting a static IP address for Docker container running this app is the main reason for simple setup of HAProxy and assigning a subdomain.
