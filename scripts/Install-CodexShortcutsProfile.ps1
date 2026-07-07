$profilePath = $PROFILE
$profileDir = Split-Path -Parent $profilePath
$enableScript = Join-Path $PSScriptRoot "Enable-CodexShortcuts.ps1"
$marker = ". `"$enableScript`""

if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}

if (Test-Path $profilePath) {
    $currentContent = Get-Content -LiteralPath $profilePath -Raw
} else {
    $currentContent = ""
}

if ($currentContent -notmatch [regex]::Escape($enableScript)) {
    if ($currentContent -and -not $currentContent.EndsWith([Environment]::NewLine)) {
        Add-Content -LiteralPath $profilePath -Value ""
    }

    Add-Content -LiteralPath $profilePath -Value $marker
    Write-Host "Added Codex shortcuts to $profilePath"
} else {
    Write-Host "Codex shortcuts are already present in $profilePath"
}

Write-Host "Open a new PowerShell window, then use codex1, codex2, codex3, or codex4."
