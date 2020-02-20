#!/bin/bash 

set -e

DEPLOYMENT_WORKDIR="{{ deployment_workdir }}"
DEPLOYMENT_COMMAND="{{ deployment_command }}"

echo "$0: cd $DEPLOYMENT_WORKDIR" >&2
cd $DEPLOYMENT_WORKDIR

echo "$0: exec $DEPLOYMENT_COMMAND" >&2 
exec $DEPLOYMENT_COMMAND 
