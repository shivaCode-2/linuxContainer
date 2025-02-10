#!/bin/bash

# Verify that the configuration file exists.
CONFIG_FILE='/workspace/Test-VIs/viaPassCase.viancfg'
LABVIEW_PATH='/usr/local/natinst/LabVIEW-2025-64/labviewprofull'
REPORT_PATH='/usr/local/natinst/ContainerExamples/Results.txt'
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found at $CONFIG_FILE, exiting...!"
  exit 1
fi

echo "(Debug)  Running LabVIEWCLI with the following parameters:"
echo "(Debug)  ConfigPath: $CONFIG_FILE"
echo "(Debug)  ReportPath: $REPORT_PATH"
echo "(Debug)  LabVIEWPath: $LABVIEW_PATH"

# Run the LabVIEWCLI command.
OUTPUT=$(xvfb-run -a -s "-screen 0 1024x768x24" bash -c "\
LabVIEWCLI -LogToConsole true \
-OperationName RunVIAnalyzer \
-ConfigPath $CONFIG_FILE \
-ReportPath $REPORT_PATH \
-LabVIEWPath $LABVIEW_PATH")

echo "Done running of VI Analyzer Tests"
echo "LabVIEWCLI Output:"
echo "$OUTPUT"
FAILED_COUNT=$(echo "$OUTPUT" | grep -i "tests failed" | grep -Eo '[0-9]+' | head -n 1)

echo "Number of failed tests: $FAILED_COUNT"
echo "Print Report..."
cat $REPORT_PATH

# Exit with success (0) if no tests failed, else exit with error (1).
if [ "$FAILED_COUNT" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "Some tests failed. Exiting with error."
  exit 1
fi
