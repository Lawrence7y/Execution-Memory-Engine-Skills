param(
  [ValidateSet("global", "project")]
  [string]$Scope = "project",

  [string]$ProjectPath = (Get-Location).Path,

  [string]$SkillName = "execution-memory-engine-mvp"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$source = Join-Path $repoRoot "skills\$SkillName"

if (-not (Test-Path -LiteralPath (Join-Path $source "SKILL.md"))) {
  throw "Skill source not found: $source"
}

if ($Scope -eq "global") {
  $targetRoot = Join-Path $env:USERPROFILE ".config\opencode\skills"
} else {
  $targetRoot = Join-Path $ProjectPath ".opencode\skills"
}

$target = Join-Path $targetRoot $SkillName
New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null

if (Test-Path -LiteralPath $target) {
  Remove-Item -LiteralPath $target -Recurse -Force
}

Copy-Item -LiteralPath $source -Destination $target -Recurse

Write-Host "Installed $SkillName to $target"
Write-Host "Verify with: opencode debug skill | Select-String '$SkillName'"
