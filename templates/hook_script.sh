#!/bin/bash 

set -e

revision_to_checkout=''
while read old new ref ; do
  if [[ $ref =~ .*/{{ deployment_git_branch }}$ ]]; then
    revision_to_checkout=$new
  fi
done


if [ ! -z "$revision_to_checkout" ]; then
  echo "Checking out revision $revision_to_checkout into {{ deployment_worktree }}"
  git --git-dir "{{ deployment_gitstore }}" --work-tree "{{ deployment_worktree }}" checkout -f $revision_to_checkout ;
fi

echo "Running sudo {{ deployment_script }}"
exec sudo "{{ deployment_script }}"
