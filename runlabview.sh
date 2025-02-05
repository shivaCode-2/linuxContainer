#!/bin/bash

# Verify that the configuration file exists.
CONFIG_FILE='/workspace/Test-VIs/VIAnalyzerCfgFile.viancfg'
LABVIEW_PATH='/usr/local/natinst/LabVIEW-2025-64/labviewprofull'
REPORT_PATH='/usr/local/natinst/ContainerExamples/Results.txt'
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

echo "Running LabVIEWCLI with the following parameters:"
echo "  ConfigPath: $CONFIG_FILE"
echo "  ReportPath: $REPORT_PATH"
echo "  LabVIEWPath: $LABVIEW_PATH"

# Run the LabVIEWCLI command.
xvfb-run -a -s "-screen 0 1024x768x24" bash -c "\
LabVIEWCLI -LogToConsole true \
-OperationName RunVIAnalyzer \
-ConfigPath $CONFIG_FILE \
-ReportPath $REPORT_PATH \
-LabVIEWPath $LABVIEW_PATH"

echo "Done running of VI Analyzer Tests"

echo "Printing Report..."
cat $REPORT_PATH

FAILED_COUNT=$(awk '/Failed Tests/ {
  for(i=1;i<=NF;i++) {
    if ($i ~ /^[0-9]+$/) {
      print $i; exit
    }
  }
}' "$REPORT_FILE")
echo "Number of failed tests: $FAILED_COUNT"

# Check if the failed tests count is 0.
if [ "$FAILED_COUNT" -eq 0 ]; then
  echo "All tests passed."
  exit 0
else
  echo "Some tests failed. Exiting with error."
  exit 1
fi
