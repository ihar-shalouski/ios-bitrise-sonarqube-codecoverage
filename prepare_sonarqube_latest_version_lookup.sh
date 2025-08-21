SQ_LATEST_TAG=$(git ls-remote --tags --refs https://github.com/SonarSource/sonar-scanner-cli.git \
  | awk -F/ '{print $NF}' \
  | sort -V \
  | tail -n 1)
envman add --key SONAR_VERSION --value "$SQ_LATEST_TAG"
echo "✅ Determined latest Sonar Scanner version: $SQ_LATEST_TAG"