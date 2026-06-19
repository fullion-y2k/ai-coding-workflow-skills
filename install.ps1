param(
  [switch]$DryRun,
  [switch]$WithWorkerCodex
)

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SkillsSrc = Join-Path $RepoDir "skills"
$AgentsSrc = Join-Path $RepoDir "agents\openai-codex"
$SkillsDest = Join-Path $HOME ".agents\skills"
$AgentsDest = Join-Path $HOME ".codex\agents"
$Stamp = Get-Date -Format "yyyyMMddHHmmss"

function Invoke-Step {
  param([scriptblock]$Action, [string]$Message)
  if ($DryRun) {
    Write-Host "[dry-run] $Message"
  } else {
    & $Action
  }
}

function Backup-IfExists {
  param([string]$Path)
  if (Test-Path -LiteralPath $Path) {
    $Backup = "$Path.backup-$Stamp"
    Write-Host "Backing up $Path -> $Backup"
    Invoke-Step { Move-Item -LiteralPath $Path -Destination $Backup } "Move-Item $Path $Backup"
  }
}

function Copy-Directory {
  param([string]$Source, [string]$Destination)
  Backup-IfExists $Destination
  Write-Host "Installing $Destination"
  $Parent = Split-Path -Parent $Destination
  Invoke-Step { New-Item -ItemType Directory -Force -Path $Parent | Out-Null } "New-Item $Parent"
  Invoke-Step { Copy-Item -Recurse -LiteralPath $Source -Destination $Destination } "Copy-Item $Source $Destination"
}

function Copy-FileSafe {
  param([string]$Source, [string]$Destination)
  Backup-IfExists $Destination
  Write-Host "Installing $Destination"
  $Parent = Split-Path -Parent $Destination
  Invoke-Step { New-Item -ItemType Directory -Force -Path $Parent | Out-Null } "New-Item $Parent"
  Invoke-Step { Copy-Item -LiteralPath $Source -Destination $Destination } "Copy-Item $Source $Destination"
}

Write-Host "Installing Skills to $SkillsDest"
Invoke-Step { New-Item -ItemType Directory -Force -Path $SkillsDest | Out-Null } "New-Item $SkillsDest"
Copy-Directory (Join-Path $SkillsSrc "ai-new-project-delivery") (Join-Path $SkillsDest "ai-new-project-delivery")
Copy-Directory (Join-Path $SkillsSrc "ai-existing-project-change") (Join-Path $SkillsDest "ai-existing-project-change")

Write-Host "Installing Custom Agents to $AgentsDest"
Invoke-Step { New-Item -ItemType Directory -Force -Path $AgentsDest | Out-Null } "New-Item $AgentsDest"
foreach ($Agent in @("explorer-mini.toml", "worker-mini.toml", "reviewer.toml", "critical-reviewer.toml")) {
  Copy-FileSafe (Join-Path $AgentsSrc $Agent) (Join-Path $AgentsDest $Agent)
}

if ($WithWorkerCodex) {
  Copy-FileSafe (Join-Path $AgentsSrc "worker-codex.toml.example") (Join-Path $AgentsDest "worker-codex.toml")
} else {
  Write-Host "Skipping optional worker-codex.toml. Use -WithWorkerCodex to install it."
}

Write-Host "Done. No secrets, tokens, or config.toml changes were made."
