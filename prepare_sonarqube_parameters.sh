#!/bin/bash
set -e
set -o pipefail

SONAR_PROPS=()
SONAR_PROPS+=("sonar.scm.revision=$GIT_CLONE_COMMIT_HASH")

if [ -n "$BITRISE_PULL_REQUEST" ]; then
  SONAR_PROPS+=("sonar.newCode.referenceBranch=$BITRISEIO_GIT_BRANCH_DEST")
  SONAR_PROPS+=("sonar.pullrequest.key=$BITRISE_PULL_REQUEST")
  SONAR_PROPS+=("sonar.pullrequest.branch=$BITRISE_GIT_BRANCH")
  SONAR_PROPS+=("sonar.pullrequest.base=$BITRISEIO_GIT_BRANCH_DEST")
else
  SONAR_PROPS+=("sonar.branch.name=$BITRISE_GIT_BRANCH")
  if [ "$BITRISE_GIT_BRANCH" = "develop" ]; then
    SONAR_PROPS+=("sonar.newCode.referenceBranch=master")
  elif [ "$BITRISE_GIT_BRANCH" != "master" ]; then
    SONAR_PROPS+=("sonar.newCode.referenceBranch=develop")
  fi
fi
SONAR_PARAMS=$(printf "%s\n" "${SONAR_PROPS[@]}")
envman add --key SONAR_PARAMS --value "$SONAR_PARAMS"
