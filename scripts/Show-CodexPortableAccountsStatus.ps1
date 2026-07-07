$ErrorActionPreference = "Stop"

$scriptPath = Join-Path $PSScriptRoot "Start-CodexPortableAccount.ps1"

foreach ($account in 1..4) {
    & $scriptPath -Account $account -VerifyOnly
    Write-Host ""
}
