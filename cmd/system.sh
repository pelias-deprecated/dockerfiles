#!/bin/bash
set -e;

function system_check(){ env_check; }
register 'system' 'check' 'ensure the system is correctly configured' system_check

function system_env(){ printf 'DATA_DIR=%s\n' ${DATA_DIR}; }
register 'system' 'env' 'display environment variables' system_env
