#!/bin/bash 

set -e

DEPLOYMENT_WORKDIR="{{ deployment_workdir }}"
DEPLOYMENT_COMMAND="{{ deployment_command }}"

cd $DEPLOYMENT_WORKDIR
exec $DEPLOYMENT_COMMAND 
