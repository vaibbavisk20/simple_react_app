Write-Host ""
Write-Host "Installing post-deployment dependencies..."
Write-Host ""
$pythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCmd) {
  # fallback to python3 if python not found
  $pythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}
Start-Process -FilePath ($pythonCmd).Source -ArgumentList "-m venv ./scripts/.venv" -Wait -NoNewWindow

$venvPythonPath = "./scripts/.venv/Scripts/python.exe"
if (Test-Path -Path "/usr") {
  # fallback to Linux venv path
  $venvPythonPath = "./scripts/.venv/bin/python"
}

$process = Start-Process -FilePath $venvPythonPath -ArgumentList "-m pip install -r requirements.txt" -Wait -NoNewWindow -PassThru

Write-Host ""
Write-Host 'Running "populate_sql.py"...'
Write-Host ""
$populatesqlArguments = "populate_sql.py",
  "--sqlconnectionstring", "`"Driver={ODBC Driver 17 for SQL Server};Server=tcp:sql-cydxse7pimuiu.database.windows.net,1433;Database=sqldb-cydxse7pimuiu;UiD=b4cd9374-b9fc-4635-9560-e56f565c4903;Encrypt=yes;Connection Timeout=30;Authentication=ActiveDirectoryIntegrated`"",
  "--subscriptionid", "443b0799-279f-401e-a220-aa1463a7710f",
  "--resourcegroup", "rg-vsk-test-530",
  "--servername", "sql-cydxse7pimuiu",
  "-v"

$process = Start-Process -FilePath $venvPythonPath -ArgumentList $populatesqlArguments -Wait -NoNewWindow -PassThru

if ($process.ExitCode -ne 0) {
  Write-Host ""
  Write-Warning "Prepopulation of necessary SQL tables failed with non-zero exit code $LastExitCode. This process must run successfully at least once for the sample to run properly."
  Write-Host ""
}
