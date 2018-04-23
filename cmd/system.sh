#!/bin/bash
set -e;

function system_check(){ env_check; }
register 'system' 'check' 'ensure the system is correctly configured' system_check
