#!/bin/bash
set -e;

function compose_exec(){ docker-compose $@; }
register 'compose' 'exec' 'run an arbitrary docker-compose command' compose_exec

function docker_pull(){ docker-compose pull; }
register 'docker' 'pull' 'update all docker images' docker_pull
