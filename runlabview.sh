#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status.

# Start Xvfb manually
echo "Starting Xvfb on display :99..."
Xvfb :99 -screen 0 1024x768x24 &
export DISPLAY=:99

# Optional: Wait a few seconds for Xvfb to initialize properly.
sleep 2

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
LabVIEWCLI -LogToConsole true \
           -OperationName RunVIAnalyzer \
           -ConfigPath "$CONFIG_FILE" \
           -ReportPath "/usr/local/natinst/ContainerExamples/Results.txt" \
           -LabVIEWPath "/usr/local/natinst/LabVIEW-2025-64/labviewprofull"

RESULT=$?

if [ $RESULT -eq 0 ]; then
  echo "LabVIEWCLI completed successfully."
else
  echo "LabVIEWCLI failed with exit code $RESULT"
fi

exit $RESULT
