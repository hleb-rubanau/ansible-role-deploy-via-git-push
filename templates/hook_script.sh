#!/bin/bash 

set -e

revision_to_checkout=''
while read old new ref ; do
  if [[ $ref =~ .*/{{ deployment_git_branch }}$ ]]; then
    revision_to_checkout=$new
  fi
done


if [ ! -z "$revision_to_checkout" ]; then
  DEPLOYMENT_TAG="deployment_$( date +%F_%H%M%S )"
  echo "Marking $revision_to_checkout as $DEPLOYMENT_TAG"
  git --git-dir "{{ deployment_gitstore }}" tag "$DEPLOYMENT_TAG" $revision_to_checkout ;
  echo "Checking out revision $revision_to_checkout into {{ deployment_worktree }}"
  git --git-dir "{{ deployment_gitstore }}" --work-tree "{{ deployment_worktree }}" checkout -f "$DEPLOYMENT_TAG" ;
fi

echo "Running sudo {{ deployment_script }}"
exec sudo "{{ deployment_script }}"
