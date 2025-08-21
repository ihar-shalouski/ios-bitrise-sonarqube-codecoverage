
#!/bin/sh
set -e
set -o pipefail

CC_CONVERT_SCRIPT="$BITRISE_SOURCE_DIR/xccov-to-sonarqube-generic.sh"
OUTPUT_FILE="$BITRISE_SOURCE_DIR/sonarqube-coverage-swift.xml"
XCRESULT="$BITRISE_XCRESULT_PATH"   # provided by Xcode Test step when coverage is enabled

echo "📊 Checking if coverage data is extractable from $XCRESULT"
if [ ! -d "$XCRESULT" ]; then
  echo "⚠️ No .xcresult directory found at $XCRESULT"
  echo '<coverage version="1"/>' > "$OUTPUT_FILE"
else
  if xcrun xccov view --report "$XCRESULT" >/dev/null 2>&1; then
    echo "✅ Coverage found. Generating SonarQube report..."
    chmod +x "$CC_CONVERT_SCRIPT"
    "$CC_CONVERT_SCRIPT" "$XCRESULT" > "$OUTPUT_FILE"
  else
    echo "⚠️ No coverage report found inside xcresult. Creating empty XML."
    echo '<coverage version="1"/>' > "$OUTPUT_FILE"
  fi
fi

REPORT_PATH="$(realpath "$OUTPUT_FILE")"
REPO_PATH="$BITRISE_SOURCE_DIR"
sed -i '' "s|$REPO_PATH/||g" "$REPORT_PATH"
NEW_SONAR_PARAMS="${SONAR_PARAMS}"$'\n'"sonar.coverageReportPaths=sonarqube-coverage-swift.xml"
envman add --key SONAR_PARAMS --value "$NEW_SONAR_PARAMS"

