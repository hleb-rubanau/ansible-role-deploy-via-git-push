#!/bin/bash 

set -e

revision_to_checkout=''
while read old new ref ; do
  if [[ $ref =~ .*/{{ deployment_branch }}$ ]]; then
    revision_to_checkout=$new
  fi
done


if [ ! -z "$revision_to_checkout" ]; then
  echo "Checking out #revision_to_checkout into $deployment_worktree"
  git --git-dir "{{ deployment_gitstore }}" --worktree "{{ deployment_worktree }}" checkout -f $revision_to_checkout ;
fi

exec sudo "{{ deployment_script }}"
