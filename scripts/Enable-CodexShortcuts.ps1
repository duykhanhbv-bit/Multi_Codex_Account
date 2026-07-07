$bundleRoot = Split-Path -Parent $PSScriptRoot

function global:codex1 {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    & (Join-Path $bundleRoot "codex1.cmd") @Args
}

function global:codex2 {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    & (Join-Path $bundleRoot "codex2.cmd") @Args
}

function global:codex3 {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    & (Join-Path $bundleRoot "codex3.cmd") @Args
}

function global:codex4 {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    & (Join-Path $bundleRoot "codex4.cmd") @Args
}

Write-Host "Loaded shortcuts: codex1, codex2, codex3, codex4"
Write-Host "Example: codex1 E:\Antigravity\GOLD"
