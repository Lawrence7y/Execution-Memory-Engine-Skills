param(
  [ValidateSet("codex", "opencode", "claude", "project", "custom")]
  [string]$Target = "project",

  [string]$ProjectPath = (Get-Location).Path,

  [string]$CustomSkillsPath = "",

  [string]$SkillName = "execution-memory-engine-skills"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "skills\$SkillName"

if (-not (Test-Path -LiteralPath (Join-Path $source "SKILL.md"))) {
  throw "Skill source not found: $source"
}

switch ($Target) {
  "codex" {
    $targetRoot = Join-Path $env:USERPROFILE ".codex\skills"
  }
  "opencode" {
    $targetRoot = Join-Path $env:USERPROFILE ".config\opencode\skills"
  }
  "claude" {
    $targetRoot = Join-Path $env:USERPROFILE ".claude\skills"
  }
  "project" {
    $targetRoot = Join-Path $ProjectPath ".skills"
  }
  "custom" {
    if (-not $CustomSkillsPath) {
      throw "-CustomSkillsPath is required when -Target custom is used."
    }
    $targetRoot = $CustomSkillsPath
  }
}

$destination = Join-Path $targetRoot $SkillName
New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if (Test-Path -LiteralPath $destination) {
  Remove-Item -LiteralPath $destination -Recurse -Force
}

Copy-Item -LiteralPath $source -Destination $destination -Recurse

Write-Host "Installed $SkillName to $destination"
Write-Host "Use the installed SKILL.md with your LLM tool, or point the model at: $destination\SKILL.md"
