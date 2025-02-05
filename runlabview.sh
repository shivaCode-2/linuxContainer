#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Verify that the configuration file exists.
CONFIG_FILE="/workspace/Test VIs/VIAnalyzerCfgFile.viancfg"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

echo "Running LabVIEWCLI with the following parameters:"
echo "  ConfigPath: $CONFIG_FILE"
echo "  ReportPath: /usr/local/natinst/ContainerExamples/Results.txt"
echo "  LabVIEWPath: /usr/local/natinst/LabVIEW-2025-64/labviewprofull"

# Run the LabVIEWCLI command.
xvfb-run -a -s "-screen 0 1024x768x24" bash -c "LabVIEWCLI -LogToConsole true \
           -OperationName RunVIAnalyzer \
           -ConfigPath "$CONFIG_FILE" \
           -ReportPath '/usr/local/natinst/ContainerExamples/Results.txt' \
           -LabVIEWPath '/usr/local/natinst/LabVIEW-2025-64/labviewprofull' "

echo "Done running of VI Analyzer Tests"

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "LabVIEWCLI completed successfully."
else
  echo "LabVIEWCLI failed with exit code $RESULT"
fi

exit $RESULT
