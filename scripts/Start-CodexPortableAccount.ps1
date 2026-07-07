param(
    [Parameter(Mandatory = $true)]
    [ValidateRange(1, 4)]
    [int]$Account,

    [string]$Workspace,

    [switch]$Inner,

    [switch]$LoginOnly,

    [switch]$VerifyOnly
)

$ErrorActionPreference = "Stop"

function Get-BundleRoot {
    return Split-Path -Parent (Split-Path -Parent $PSCommandPath)
}

function Resolve-CodexExe {
    $candidates = @(
        "$env:LOCALAPPDATA\OpenAI\Codex\bin\codex.exe",
        "$env:USERPROFILE\AppData\Local\OpenAI\Codex\bin\codex.exe"
    )

    foreach ($candidate in $candidates) {
        if (Test-Path $candidate) {
            return $candidate
        }
    }

    $command = Get-Command codex -ErrorAction SilentlyContinue
    if ($command) {
        return $command.Source
    }

    throw "Could not find codex.exe. Install Codex on this machine first."
}

function Resolve-WorkspacePath {
    param(
        [string]$InputWorkspace,
        [string]$FallbackPath
    )

    if ([string]::IsNullOrWhiteSpace($InputWorkspace)) {
        return (Resolve-Path -LiteralPath $FallbackPath).Path
    }

    if (-not (Test-Path $InputWorkspace)) {
        throw "Workspace path does not exist: $InputWorkspace"
    }

    return (Resolve-Path -LiteralPath $InputWorkspace).Path
}

function Initialize-PortableHome {
    param(
        [Parameter(Mandatory = $true)]
        [string]$HomePath
    )

    $sqliteHome = Join-Path $HomePath "sqlite"
    $roamingRoot = Join-Path $HomePath "roaming"
    $tmpRoot = Join-Path $HomePath "tmp"
    $memoriesRoot = Join-Path $HomePath "memories"
    $threadsRoot = Join-Path $HomePath "threads"
    $secondaryConfig = Join-Path $HomePath "config.toml"

    foreach ($dir in @($HomePath, $sqliteHome, $roamingRoot, $tmpRoot, $memoriesRoot, $threadsRoot)) {
        New-Item -ItemType Directory -Force -Path $dir | Out-Null
    }

    if (-not (Test-Path $secondaryConfig)) {
        @'
model = "gpt-5.4"
model_provider = "openai"
approval_policy = "never"
sandbox_mode = "workspace-write"
web_search = "live"
cli_auth_credentials_store = "file"

[windows]
sandbox = "elevated"
'@ | Set-Content -LiteralPath $secondaryConfig
    }

    return [PSCustomObject]@{
        SqliteHome = $sqliteHome
        RoamingRoot = $roamingRoot
        TmpRoot = $tmpRoot
        SecondaryConfig = $secondaryConfig
        AuthPath = (Join-Path $HomePath "auth.json")
    }
}

function Get-LoginStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CodexExe
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $CodexExe
    $psi.Arguments = "login status"
    $psi.UseShellExecute = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $psi
    [void]$process.Start()

    $stdout = $process.StandardOutput.ReadToEnd().Trim()
    $stderr = $process.StandardError.ReadToEnd().Trim()
    $process.WaitForExit()

    $combinedParts = @($stdout, $stderr) | Where-Object { $_ }
    $combined = ($combinedParts -join [Environment]::NewLine).Trim()

    return [PSCustomObject]@{
        IsLoggedIn = ($process.ExitCode -eq 0)
        Output = $combined
    }
}

$bundleRoot = Get-BundleRoot
$accountName = "account-$Account"
$accountHome = Join-Path $bundleRoot "state\$accountName"

if (-not $Inner -and -not $VerifyOnly) {
    $launchWorkspace = Resolve-WorkspacePath -InputWorkspace $Workspace -FallbackPath (Get-Location).Path
    $arguments = @(
        "-NoExit",
        "-ExecutionPolicy", "Bypass",
        "-File", $PSCommandPath,
        "-Inner",
        "-Account", $Account,
        "-Workspace", $launchWorkspace
    )

    if ($LoginOnly) {
        $arguments += "-LoginOnly"
    }

    Start-Process -FilePath "powershell.exe" -ArgumentList $arguments -WorkingDirectory $launchWorkspace
    return
}

$workspacePath = Resolve-WorkspacePath -InputWorkspace $Workspace -FallbackPath (Get-Location).Path
$codexExe = Resolve-CodexExe
$paths = Initialize-PortableHome -HomePath $accountHome

$env:CODEX_HOME = $accountHome
$env:CODEX_SQLITE_HOME = $paths.SqliteHome
$env:APPDATA = $paths.RoamingRoot
$env:TEMP = $paths.TmpRoot
$env:TMP = $paths.TmpRoot

$status = Get-LoginStatus -CodexExe $codexExe

Write-Host ""
Write-Host "Portable Codex CLI profile"
Write-Host "  Account:        $accountName"
Write-Host "  Workspace:      $workspacePath"
Write-Host "  Codex exe:      $codexExe"
Write-Host "  CODEX_HOME:     $env:CODEX_HOME"
Write-Host "  SQLITE_HOME:    $env:CODEX_SQLITE_HOME"
Write-Host "  APPDATA:        $env:APPDATA"
Write-Host "  TMP:            $env:TMP"
Write-Host "  Config file:    $($paths.SecondaryConfig)"
Write-Host "  Auth file:      $($paths.AuthPath)"
Write-Host ""

if ($VerifyOnly) {
    Write-Host "Login status:"
    Write-Host "  $($status.Output)"
    return
}

if (-not $status.IsLoggedIn) {
    Write-Host "$accountName is not logged in yet. Starting the Codex login flow..."
    & $codexExe login

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Login did not complete. Run the launcher again after you finish signing in."
        return
    }
}

if ($LoginOnly) {
    Write-Host "Login flow finished for $accountName."
    return
}

Write-Host "Launching Codex CLI for $accountName..."
& $codexExe -C $workspacePath
