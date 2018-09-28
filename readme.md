# oragono-docker

A much smaller image for oragono, based on alpine linux

## running

Expects you to have a `config` folder with ircd.yaml setup

    docker create \
      --name oragono \
      --publish 6667:6667/tcp \
      --publish 6697:6697/tcp \
      --volume $PWD/config:/config \
      --restart on-failure \
      jedahan/oragono:latest

    docker start oragono

## building

If you want to build from scratch, or need a fresh config:

build the builder

    docker build --tag jedahan/oragono:latest .

copy and edit the config files to a new directory

    mkdir config
    docker run --rm jedahan/oragono:latest tar -c -C /config . | tar -x -C config
    edit config/*

run the container

    docker create \
      --name oragono \
      --publish 6667:6667/tcp \
      --publish 6697:6697/tcp \
      --volume $PWD/config:/config \
      --restart on-failure \
      jedahan/oragono:latest

    docker start oragono
