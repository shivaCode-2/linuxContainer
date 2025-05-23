#!/bin/bash

# Verify that the configuration file exists.
CONFIG_FILE='/workspace/Test-VIs/viaPassCase.viancfg'
LABVIEW_PATH='/usr/local/natinst/LabVIEW-2025-64/labviewprofull'
REPORT_PATH='/usr/local/natinst/ContainerExamples/Results.txt'
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found at $CONFIG_FILE, exiting...!"
  exit 1
fi

echo "(Debug) Running LabVIEWCLI with the following parameters:"
echo "(Debug) ConfigPath: $CONFIG_FILE"
echo "(Debug) ReportPath: $REPORT_PATH"
echo "(Debug) LabVIEWPath: $LABVIEW_PATH"

# Run the LabVIEWCLI command.
OUTPUT=$(LabVIEWCLI -LogToConsole true \
-OperationName RunVIAnalyzer \
-ConfigPath $CONFIG_FILE \
-ReportPath $REPORT_PATH \
-LabVIEWPath $LABVIEW_PATH)

echo "Done running of VI Analyzer Tests"
echo "Print Report..."
echo "────────────────────────────────────────────────────────────"
cat "$REPORT_PATH"
echo "────────────────────────────────────────────────────────────"

# 1) Extract the number from the report file, anchor to “Failed Tests”
FAILED_COUNT=$(
  sed -n 's/^Failed Tests[[:space:]]*\([0-9]\+\)$/\1/p' "$REPORT_PATH"
)

# 2) Default to zero if it didn’t match
: "${FAILED_COUNT:=0}"

# 3) Sanity-check numeric
if ! [[ "$FAILED_COUNT" =~ ^[0-9]+$ ]]; then
  echo "Warning: parsed FAILED_COUNT ('$FAILED_COUNT') is not numeric, defaulting to 0" >&2
  FAILED_COUNT=0
fi

echo "Number of failed tests: $FAILED_COUNT"

# 4) Exit based on count
if (( FAILED_COUNT > 0 )); then
  echo "✖ Some tests failed. Exiting with error."
  exit 1
else
  echo "✔ All tests passed."
  exit 0
fi
