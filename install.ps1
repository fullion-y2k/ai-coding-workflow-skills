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
$SkillBackupRoot = Join-Path $HOME ".agents\skill-backups"
$AgentBackupRoot = Join-Path $HOME ".codex\agent-backups"
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
  param([string]$Path, [string]$BackupRoot)
  if (Test-Path -LiteralPath $Path) {
    $BackupDir = Join-Path $BackupRoot $Stamp
    $Backup = Join-Path $BackupDir (Split-Path -Leaf $Path)
    Write-Host "Backing up $Path -> $Backup"
    Invoke-Step { New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null } "New-Item $BackupDir"
    Invoke-Step { Move-Item -LiteralPath $Path -Destination $Backup } "Move-Item $Path $Backup"
  }
}

function Copy-Directory {
  param([string]$Source, [string]$Destination, [string]$BackupRoot)
  Backup-IfExists $Destination $BackupRoot
  Write-Host "Installing $Destination"
  $Parent = Split-Path -Parent $Destination
  Invoke-Step { New-Item -ItemType Directory -Force -Path $Parent | Out-Null } "New-Item $Parent"
  Invoke-Step { Copy-Item -Recurse -LiteralPath $Source -Destination $Destination } "Copy-Item $Source $Destination"
}

function Copy-FileSafe {
  param([string]$Source, [string]$Destination, [string]$BackupRoot)
  Backup-IfExists $Destination $BackupRoot
  Write-Host "Installing $Destination"
  $Parent = Split-Path -Parent $Destination
  Invoke-Step { New-Item -ItemType Directory -Force -Path $Parent | Out-Null } "New-Item $Parent"
  Invoke-Step { Copy-Item -LiteralPath $Source -Destination $Destination } "Copy-Item $Source $Destination"
}

function Move-LegacyBackups {
  param([string]$ActiveDir, [string]$BackupRoot)
  if (-not (Test-Path -LiteralPath $ActiveDir)) {
    return
  }
  $LegacyItems = Get-ChildItem -LiteralPath $ActiveDir -Force | Where-Object { $_.Name -like "*.backup-*" }
  foreach ($Item in $LegacyItems) {
    $BackupDir = Join-Path $BackupRoot "$Stamp-legacy"
    $Backup = Join-Path $BackupDir $Item.Name
    Write-Host "Moving legacy backup $($Item.FullName) -> $Backup"
    Invoke-Step { New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null } "New-Item $BackupDir"
    Invoke-Step { Move-Item -LiteralPath $Item.FullName -Destination $Backup } "Move-Item $($Item.FullName) $Backup"
  }
}

Write-Host "Installing Skills to $SkillsDest"
Invoke-Step { New-Item -ItemType Directory -Force -Path $SkillsDest | Out-Null } "New-Item $SkillsDest"
Move-LegacyBackups $SkillsDest $SkillBackupRoot
Copy-Directory (Join-Path $SkillsSrc "ai-new-project-delivery") (Join-Path $SkillsDest "ai-new-project-delivery") $SkillBackupRoot
Copy-Directory (Join-Path $SkillsSrc "ai-existing-project-change") (Join-Path $SkillsDest "ai-existing-project-change") $SkillBackupRoot

Write-Host "Installing Custom Agents to $AgentsDest"
Invoke-Step { New-Item -ItemType Directory -Force -Path $AgentsDest | Out-Null } "New-Item $AgentsDest"
Move-LegacyBackups $AgentsDest $AgentBackupRoot
foreach ($Agent in @("explorer-mini.toml", "worker-mini.toml", "reviewer.toml", "critical-reviewer.toml")) {
  Copy-FileSafe (Join-Path $AgentsSrc $Agent) (Join-Path $AgentsDest $Agent) $AgentBackupRoot
}

if ($WithWorkerCodex) {
  Copy-FileSafe (Join-Path $AgentsSrc "worker-codex.toml.example") (Join-Path $AgentsDest "worker-codex.toml") $AgentBackupRoot
} else {
  Write-Host "Skipping optional worker-codex.toml. Use -WithWorkerCodex to install it."
}

Write-Host "Done. Backups are stored outside active install directories. No secrets, tokens, or config.toml changes were made."
