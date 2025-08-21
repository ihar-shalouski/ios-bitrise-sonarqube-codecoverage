#!/bin/bash
set -e
set -o pipefail

echo "🔍 Preparing SonarQube analysis parameters..."

SONAR_PROPS=()

# Always tie analysis to a specific commit SHA
SONAR_PROPS+=("sonar.scm.revision=$GIT_CLONE_COMMIT_HASH")

if [ -n "$BITRISE_PULL_REQUEST" ]; then
  # --- Pull Request analysis ---
  echo "📦 Pull Request Analysis #$BITRISE_PULL_REQUEST $BITRISE_GIT_BRANCH -> $BITRISEIO_GIT_BRANCH_DEST"

  # Link PR metadata (source branch, target branch, PR id)
  SONAR_PROPS+=("sonar.newCode.referenceBranch=$BITRISEIO_GIT_BRANCH_DEST")
  SONAR_PROPS+=("sonar.pullrequest.key=$BITRISE_PULL_REQUEST")
  SONAR_PROPS+=("sonar.pullrequest.branch=$BITRISE_GIT_BRANCH")
  SONAR_PROPS+=("sonar.pullrequest.base=$BITRISEIO_GIT_BRANCH_DEST")

  echo "ℹ️ Fetching branch: $BITRISEIO_GIT_BRANCH_DEST"
  git fetch origin $BITRISEIO_GIT_BRANCH_DEST:$BITRISEIO_GIT_BRANCH_DEST
else
  # --- Regular branch analysis ---
  echo "📦 Branch analysis: $BITRISE_GIT_BRANCH"

  # Current branch name
  SONAR_PROPS+=("sonar.branch.name=$BITRISE_GIT_BRANCH")

  # Define reference branch for "new code" depending on strategy
  # Make sure that this part matches your branching strategy
  if [ "$BITRISE_GIT_BRANCH" = "develop" ]; then
    SONAR_PROPS+=("sonar.newCode.referenceBranch=main")
    echo "ℹ️ Fetching branch: main"
    git fetch origin main:main
  elif [ "$BITRISE_GIT_BRANCH" != "main" ]; then
    SONAR_PROPS+=("sonar.newCode.referenceBranch=develop")
    echo "ℹ️ Fetching branch: develop"
    git fetch origin develop:develop
  fi
fi

# Join collected properties into a single block
# Future steps will also be appending new parameters
SONAR_PARAMS=$(printf "%s\n" "${SONAR_PROPS[@]}")

# Export to Bitrise env so next steps can use it
envman add --key SONAR_PARAMS --value "$SONAR_PARAMS"

# Detect latest sonar-scanner-version

SQ_LATEST_TAG=$(git ls-remote --tags --refs https://github.com/SonarSource/sonar-scanner-cli.git \
  | awk -F/ '{print $NF}' \
  | sort -V \
  | tail -n 1)

# Export to Bitrise env so next steps can use it
envman add --key SONAR_VERSION --value "$SQ_LATEST_TAG"
echo "✅ Determined latest Sonar Scanner version: $SQ_LATEST_TAG"
