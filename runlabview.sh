#!/bin/bash
set -euo pipefail

CONFIG_FILE='/workspace/Test-VIs/viaPassCase.viancfg'
LABVIEW_PATH='/usr/local/natinst/LabVIEW-2025-64/labviewprofull'
REPORT_PATH='/usr/local/natinst/ContainerExamples/Results.txt'

# 1) Verify the config exists
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Configuration file not found at $CONFIG_FILE" >&2
  exit 1
fi

echo "(Debug) Running LabVIEWCLI with:"
echo "  ConfigPath : $CONFIG_FILE"
echo "  ReportPath : $REPORT_PATH"
echo "  LabVIEWPath: $LABVIEW_PATH"

# 2) Run the CLI and capture both its stdout+stderr and its exit code
OUTPUT=$(  
  LabVIEWCLI \
    -LogToConsole true \
    -OperationName RunVIAnalyzer \
    -ConfigPath "$CONFIG_FILE" \
    -ReportPath "$REPORT_PATH" \
    -LabVIEWPath "$LABVIEW_PATH" \
  2>&1
)
CLI_EXIT=$?

if [[ $CLI_EXIT -ne 0 ]]; then
  echo "✖ LabVIEWCLI exited with code $CLI_EXIT" >&2
  echo "$OUTPUT" >&2
  exit $CLI_EXIT
fi

echo "✔ LabVIEWCLI finished."
echo
echo "—— LabVIEWCLI Output —————————"
echo "$OUTPUT"
echo "—————————————"

# 3) Parse the “Failed Tests” line (e.g. “Failed Tests    0”)
#    Fallback to 0 if we don’t find a number
FAILED_COUNT=$(echo "$OUTPUT" \
  | grep -i '^Failed Tests' \
  | awk '{print $NF}' \
  || echo 0
)

# Ensure it’s numeric
if ! [[ "$FAILED_COUNT" =~ ^[0-9]+$ ]]; then
  FAILED_COUNT=0
fi

echo "Number of failed tests: $FAILED_COUNT"
echo
echo "—— Test Report —————————"
cat "$REPORT_PATH"
echo "—————————————"

# 4) Exit zero if none failed, non-zero otherwise
if (( FAILED_COUNT > 0 )); then
  echo "✖ Some tests failed. Exiting with error."
  exit 1
else
  echo "✔ All tests passed."
  exit 0
fi
