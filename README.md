# oragono-docker

A much smaller image for oragono, based on alpine linux

## running

Expects you to have a `config` folder with ircd.yaml setup

    docker run \
      --name oragono \
      -p 6667:6667/tcp \
      -p 6697:6697/tcp \
      -v ./config:/config \
      --restart-on failure \
      jedahan/oragono:latest

## building

If you want to build from scratch, or need a fresh config:

build the builder

    docker build --target builder --tag jedahan/oragono:latest .

copy and edit the config files to a new directory

    mkdir config
    docker run --rm jedahan/oragono:version tar -c -C /config . | tar -x -C config
    edit config/*

run the container

    docker run \
      --name oragono \
      -p 6667:6667/tcp \
      -p 6697:6697/tcp \
      -v ./config:/config \
      --restart-on failure \
      jedahan/oragono:latest
