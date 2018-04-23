#!/bin/bash
set -e;

# ensure the user environment is correctly set up
function env_check(){
  if [ -z "${DATA_DIR}" ]; then
    echo "You must set the DATA_DIR env var to a valid directory on your local machine."
    exit 1
  elif [ ! -d "${DATA_DIR}" ]; then
    echo "The directory specified by DATA_DIR does not exist."
    exit 1
  fi
}

# loads environment vars from a stream (such as a file)
# example: env_load_stream < .env
function env_load_stream(){
  while IFS='=' read -r key value; do
    ([ -z $key ] || [ -z $value ]) && printf 'Invalid environment var "%s=%s"\n' $key $value && exit 1
    [ -z ${!key} ] || printf '[warn] skip setting environment var "%s=%s", already set "%s=%s"\n' $key $value $key ${!key}
    export "${key}=${value}"
  done
}
