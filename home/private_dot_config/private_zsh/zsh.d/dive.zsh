#!/bin/zsh

# https://github.com/wagoodman/dive
dive()
{
    docker run --rm -it \
        -v /var/run/docker.sock:/var/run/docker.sock \
        wagoodman/dive:latest "$@"
}
