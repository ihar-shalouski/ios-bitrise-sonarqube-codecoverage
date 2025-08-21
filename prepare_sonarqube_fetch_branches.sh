#!/bin/bash
set -e
set -o pipefail

if [ -n "$BITRISE_PULL_REQUEST" ]; then
  echo "ℹ️ Fetching branch: $BITRISEIO_GIT_BRANCH_DEST"
  git fetch origin $BITRISEIO_GIT_BRANCH_DEST:$BITRISEIO_GIT_BRANCH_DEST
else
  if [ "$BITRISE_GIT_BRANCH" = "develop" ]; then
    git fetch origin main:main
    echo "ℹ️ Fetching branch: main"
  elif [ "$BITRISE_GIT_BRANCH" != "main" ]; then
    git fetch origin develop:develop
    echo "ℹ️ Fetching branch: develop"
  fi
fi
