#! /bin/bash

### this is a helper script, which can be used independently from corresponding ansible setup
### shortcut: 
# export DEPLOYMENT_GIT_UPSTREAM=<yoururl> DEPLOYMENT_GIT_COMMAND="./deploy.sh" 
# curl -s https://raw.githubusercontent.com/hleb-rubanau/ansible-role-self-configurable-deployment/master/deploy_from_git.sh | /bin/bash
### extra parameters:
###     DEPLOYMENT_GIT_KEY  -- file with SSH identity key
###     DEPLOYMENT_GIT_WORKDIR -- alternative checkout location (default: /usr/local/etc/recipes/bootstrap )
###     DEPLOYMENT_GIT_BRANCH -- git branch to use if not master
###     DEPLOYMENT_GIT_SUBDIR -- subdirectory under working tree to cd into before executing DEPLOYMENT_GIT_COMMAND
set -e

function say() { echo "$*" >&2 ; }
function die() { say "ERROR: $*" ; exit 1; }

if [ -z "$DEPLOYMENT_GIT_UPSTREAM" ]; then die "DEPLOYMENT_GIT_UPSTREAM must be configured" ; fi
if [ -z "$DEPLOYMENT_GIT_COMMAND" ]; then die "DEPLOYMENT_GIT_COMMAND must be configured" ; fi
if [ -z "$DEPLOYMENT_GIT_KEY" ]; then
    say "WARNING: no DEPLOYMENT_GIT_KEY specified, assuming ssh identity is already in place";
else
    export GIT_SSH="ssh -i $DEPLOYMENT_GIT_KEY"
    chmod -v 0600 $DEPLOYMENT_GIT_KEY    
fi 

DEPLOYMENT_GIT_BRANCH=${DEPLOYMENT_GIT_BRANCH:-master}
DEPLOYMENT_GIT_WORKDIR=${DEPLOYMENT_GIT_WORKDIR:-/usr/local/etc/recipes/bootstrap}
DEPLOYMENT_GIT_WORKDIR_PARENT=$( dirname "$DEPLOYMENT_GIT_WORKDIR" )

mkdir -pv "$DEPLOYMENT_GIT_WORKDIR_PARENT"

if [ ! -e "$DEPLOYMENT_GIT_WORKDIR" ]; then
    say "Cloning $DEPLOYMENT_GIT_UPSTREAM to $DEPLOYMENT_GIT_WORKDIR"
    cd "$DEPLOYMENT_GIT_WORKDIR_PARENT" ;
    BASE_GIT_DIR=$( basename "$DEPLOYMENT_GIT_WORKDIR" )

    git clone "$DEPLOYMENT_GIT_UPSTREAM" "$BASE_GIT_DIR"
    cd "$BASE_GIT_DIR"

    if [ "$DEPLOYMENT_GIT_BRANCH" != "master" ]; then
        git checkout -t "origin/$DEPLOYMENT_GIT_BRANCH"
    fi
else
    cd "$DEPLOYMENT_GIT_WORKDIR"
    git checkout $DEPLOYMENT_GIT_BRANCH
fi

say "On branch $DEPLOYMENT_GIT_BRANCH, pulling"
git pull

if [ ! -z "$DEPLOYMENT_GIT_SUBDIR" ]; then
    say "cd $DEPLOYMENT_GIT_SUBDIR"
    cd "$DEPLOYMENT_GIT_SUBDIR"
fi

say "Running deployment command: $DEPLOYMENT_GIT_COMMAND"
exec $DEPLOYMENT_GIT_COMMAND
