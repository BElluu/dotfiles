param(
    [string]$RepoUrl = "https://github.com/BElluu/dotfiles.git",
    [string]$Branch = "main"
)

Write-Host "=== Devopsowy Machine Script ===" -ForegroundColor Green
Write-Host "Repository: $RepoUrl" -ForegroundColor Cyan
Write-Host ""

function Test-Command {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# -------------------------------
# Scoop Installation / Update
# -------------------------------

if (!(Test-Command scoop)) {
    Write-Host "Installing Scoop..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression

    # Refresh PATH
    $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                [Environment]::GetEnvironmentVariable("Path","User")
    Write-Host "✓ Scoop installed" -ForegroundColor Green
} else {
    Write-Host "✓ Scoop already installed" -ForegroundColor Green
}

Write-Host "Updating Scoop..." -ForegroundColor Yellow
scoop update *
Write-Host "✓ Scoop updated" -ForegroundColor Green

# Buckets
scoop bucket add extras 2>$null
scoop bucket add nerd-fonts 2>$null

# -------------------------------
# Core Tools
# -------------------------------
$packages = @(
    "git",
    "neovim",
    "JetBrainsMono-NF",
    "mingw",
    "curl",
    "ripgrep",
    "fd",
    "fzf",
    "lazygit",
    "nodejs",
    "dotnet-sdk@8.0.416"
)

Write-Host "`nInstalling/Updating tools..." -ForegroundColor Cyan

foreach ($pkg in $packages) {
    scoop install $pkg 2>$null
    scoop update $pkg
    Write-Host "✓ $pkg ready" -ForegroundColor Green
}

if (Test-Command npm) {
    Write-Host "`nInstalling/Updating tree-sitter CLI..." -ForegroundColor Yellow
    npm install -g tree-sitter-cli
    Write-Host "✓ tree-sitter CLI ready" -ForegroundColor Green
}

# -------------------------------
# Neovim Config Backup & Clone
# -------------------------------
Write-Host "`n--- Updating LazyVim Configuration ---" -ForegroundColor Cyan

$nvimConfig = "$env:LOCALAPPDATA\nvim"
$nvimData = "$env:LOCALAPPDATA\nvim-data"

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

if (Test-Path $nvimConfig) {
    Move-Item $nvimConfig "$nvimConfig.backup.$timestamp" -Force
    Write-Host "✓ Previous config backed up" -ForegroundColor Green
}

if (Test-Path $nvimData) {
    Move-Item $nvimData "$nvimData.backup.$timestamp" -Force
    Write-Host "✓ Previous data backed up" -ForegroundColor Green
}

Write-Host "Cloning LazyVim configuration..." -ForegroundColor Yellow
git clone --branch $Branch $RepoUrl $nvimConfig
Remove-Item "$nvimConfig\.git" -Recurse -Force

Write-Host "✓ Configuration updated" -ForegroundColor Green

Write-Host "`n╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║               LazyVim Installation / Update Complete! 🎉        ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host "`nRun nvim to start LazyVim."