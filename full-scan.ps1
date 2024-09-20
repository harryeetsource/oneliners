# Path to your YARA executable and custom ruleset
$yaraPath = ".\yara64.exe"      # Path to your YARA executable
$rulesPath = ".\rules-final.yar"   # Path to your custom YARA ruleset
$logPath = ".\yara_log.txt"     # Path to your log file

# Clear the log file or create a new one
New-Item -Path $logPath -ItemType File -Force

# Get all running processes and scan each one by its ID
Get-Process | ForEach-Object {
    $processId = $_.Id
    $processName = $_.Name

    try {
        # Run YARA scan on the process in memory using the correct syntax (-C for scanning processes)
        $yaraResult = & $yaraPath -C $rulesPath $processId

        # If YARA returns results, log them
        if ($yaraResult) {
            $logEntry = "YARA detected a match in process ID $processId ($processName): `n$yaraResult`n"
            Add-Content -Path $logPath -Value $logEntry
            Write-Host $logEntry
        } else {
            Write-Host "No match found for process ID $processId ($processName)"
        }
    } catch {
        Write-Warning "Skipping process ID $processId ($processName) due to permission or access issues."
    }
}