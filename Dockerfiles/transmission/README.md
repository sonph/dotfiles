# transmission.Dockerfile

A simple Docker container for transmission (a torrent client with a web interface).

## Build
```
./make.sh build <password>
```

`password` is the password you use to login to the web interface (to manage downloads) later. This
is set at build time so you can later inspect the image for the set password:

```
docker inspect sonph/transmission_img | grep "web_interface_password"
```

Image tag is automatically set at the date of the build, e.g. `20170428`.

Downloads folder is a volume `$PWD/downloads:/downloads`.

### Rebuild/update
```
./make.sh remove && ./make.sh build <new-password>
```

## Run
```
./make.sh start
```

Then browse to [localhost:9091](http://localhost:9091) or `$(docker-machine ip):9091` (if you use
`docker-machine` on a Mac).

## Stop
```
./make.sh stop
```

## Misc
```
./make.sh exec_bash
```
To run bash interactively in the running container (for debugging purposes).


