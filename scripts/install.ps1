$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

$Targets = @(
  "$env:USERPROFILE\.gemini\config\skills",
  "$env:USERPROFILE\.config\opencode\skills",
  "$env:USERPROFILE\.agents\skills",
  "$env:USERPROFILE\.claude\skills"
)

foreach ($Target in $Targets) {
  if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Force -Path $Target | Out-Null
  }
  Copy-Item -Recurse -Force "$RepoRoot\skills\clasp-netlify-sheets" "$Target\clasp-netlify-sheets"
  Copy-Item -Recurse -Force "$RepoRoot\skills\clasp-netlify-sheets-en" "$Target\clasp-netlify-sheets-en"
  Write-Host "✅ Installed skills to: $Target" -ForegroundColor Green
}

Write-Host "`n🎉 Installation complete! Restart AntiGravity or open a new chat to use /clasp-netlify-sheets or /clasp-netlify-sheets-en." -ForegroundColor Cyan
