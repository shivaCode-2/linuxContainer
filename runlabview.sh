#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Verify that the configuration file exists.
CONFIG_FILE='/workspace/Test VIs/VIAnalyzerCfgFile.viancfg'
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

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "LabVIEWCLI completed successfully."
else
  echo "LabVIEWCLI failed with exit code $RESULT"
fi

exit $RESULT
