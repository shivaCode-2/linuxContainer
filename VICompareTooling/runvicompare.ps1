# Reads a list of changed .vi files from changed-files.txt (written by the workflow).
# Each line is a tab-separated pair:  <STATUS>\t<path/to/file.vi>
# where STATUS is A (added), D (deleted), or M (modified).
#
# Modified VIs  -> CreateComparisonReport  (base vs head),  *-diff-report.html
# Added VIs     -> PrintToSingleFileHtml   (head version),  *-print-report.html
# Deleted VIs   -> PrintToSingleFileHtml   (base version),  *-print-report.html

$CHANGED_FILES_FILE  = "C:\workspace\changed-files.txt"
$REPORT_DIR          = "C:\workspace\vi-compare-reports"
$LabVIEWPath         = "C:\Program Files\National Instruments\LabVIEW 2026\LabVIEW.exe"
$AdditionalOpDir     = "C:\workspace\VICompareTooling"

New-Item -ItemType Directory -Force -Path $REPORT_DIR | Out-Null

if (-not (Test-Path $CHANGED_FILES_FILE)) {
    Write-Host "No changed-files.txt found. Exiting."
    exit 0
}

$lines = Get-Content $CHANGED_FILES_FILE |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -match '\t' -and $_ -match '\.vi$' }

if ($lines.Count -eq 0) {
    Write-Host "No changed .vi files to process. Exiting."
    exit 0
}

$FAILED = 0

foreach ($line in $lines) {
    $parts  = $line -split "`t", 2
    $status = $parts[0].Trim()
    $file   = $parts[1].Trim()

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file)

    if ($status -eq "M") {
        # ---------- Modified: compare base vs head ----------
        $VI_BASE    = Join-Path "C:\workspace\vi-base" $file
        $VI_HEAD    = Join-Path "C:\workspace" $file
        $REPORT_PATH = Join-Path $REPORT_DIR "$baseName-diff-report.html"

        if (-not (Test-Path $VI_HEAD)) {
            Write-Host "Warning: Head version not found: $VI_HEAD, skipping."
            continue
        }
        if (-not (Test-Path $VI_BASE)) {
            Write-Host "Warning: Base version not found: $VI_BASE, skipping."
            continue
        }

        Write-Host "Running LabVIEWCLI CreateComparisonReport for modified VI: $file"

        # -o overwrites an existing report; -c continues if LabVIEW is already open.
        & LabVIEWCLI `
            -OperationName CreateComparisonReport `
            -AdditionalOperationDirectory "$AdditionalOpDir" `
            -LabVIEWPath "$LabVIEWPath" `
            -LogToConsole TRUE `
            -vi1 "$VI_BASE" `
            -vi2 "$VI_HEAD" `
            -reportType "HTMLSingleFile" `
            -reportPath "$REPORT_PATH" `
            -o -c -nobdcosm `
            -Headless

    } elseif ($status -eq "A") {
        # ---------- Added: print the new VI ----------
        $VI_PATH     = Join-Path "C:\workspace" $file
        $REPORT_PATH = Join-Path $REPORT_DIR "$baseName-print-report.html"

        if (-not (Test-Path $VI_PATH)) {
            Write-Host "Warning: Added VI not found: $VI_PATH, skipping."
            continue
        }

        Write-Host "Running LabVIEWCLI PrintToSingleFileHtml for added VI: $file"

        & LabVIEWCLI `
            -OperationName PrintToSingleFileHtml `
            -AdditionalOperationDirectory "$AdditionalOpDir" `
            -LabVIEWPath "$LabVIEWPath" `
            -LogToConsole TRUE `
            -VI "$VI_PATH" `
            -OutputPath "$REPORT_PATH" `
            -o -c `
            -Headless

    } elseif ($status -eq "D") {
        # ---------- Deleted: print the old VI ----------
        $VI_PATH     = Join-Path "C:\workspace\vi-base" $file
        $REPORT_PATH = Join-Path $REPORT_DIR "$baseName-print-report.html"

        if (-not (Test-Path $VI_PATH)) {
            Write-Host "Warning: Deleted VI not found in base: $VI_PATH, skipping."
            continue
        }

        Write-Host "Running LabVIEWCLI PrintToSingleFileHtml for deleted VI: $file"

        & LabVIEWCLI `
            -OperationName PrintToSingleFileHtml `
            -AdditionalOperationDirectory "$AdditionalOpDir" `
            -LabVIEWPath "$LabVIEWPath" `
            -LogToConsole TRUE `
            -VI "$VI_PATH" `
            -OutputPath "$REPORT_PATH" `
            -o -c `
            -Headless

    } else {
        Write-Host "Skipping unrecognized status '$status' for: $file"
        continue
    }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "X LabVIEWCLI failed for $file (exit code $LASTEXITCODE)"
        $FAILED++
    } elseif (-not (Test-Path $REPORT_PATH)) {
        Write-Host "X LabVIEWCLI exited 0 but report was not created: $REPORT_PATH"
        $FAILED++
    } else {
        Write-Host "[OK] Report generated for $file"
    }
}

if ($FAILED -gt 0) {
    Write-Host "X $FAILED file(s) failed. Exiting with error."
    exit 1
} else {
    Write-Host "[OK] All reports generated successfully."
    exit 0
}
