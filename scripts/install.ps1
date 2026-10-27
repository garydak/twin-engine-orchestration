<#
.SYNOPSIS
    Twin-Engine Orchestration 一键部署脚本 (Windows PowerShell)
.DESCRIPTION
    支持将双星协同 2.0 规则安装到全局 (~/.gemini/rules) 或当前指定项目目录中。
.PARAMETER Mode
    可选 "global" (全局安装) 或 "project" (安装到当前工程目录)。默认 "global"。
#>

param (
    [ValidateSet("global", "project")]
    [string]$Mode = "global"
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$SourceRule = Join-Path $ProjectRoot "rules\twin-engine.md"

if (-not (Test-Path $SourceRule)) {
    Write-Error "❌ 未找到源规则文件: $SourceRule"
}

if ($Mode -eq "global") {
    $TargetDir = Join-Path $HOME ".gemini\rules"
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    }
    $TargetFile = Join-Path $TargetDir "twin-engine.md"
    Copy-Item -Path $SourceRule -Destination $TargetFile -Force
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "🎉 成功部署到【全局环境】！" -ForegroundColor Green
    Write-Host "目标路径: $TargetFile" -ForegroundColor Cyan
    Write-Host "所有新建或打开的项目均已自动生效双星协同 2.0 规则！" -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Green
} else {
    $CurrentDir = Get-Location
    $TargetDir = Join-Path $CurrentDir ".gemini\rules"
    if (-not (Test-Path $TargetDir)) {
        New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    }
    $TargetFile = Join-Path $TargetDir "twin-engine.md"
    Copy-Item -Path $SourceRule -Destination $TargetFile -Force
    Write-Host ""
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host "🎉 成功部署到【当前项目】！" -ForegroundColor Green
    Write-Host "目标路径: $TargetFile" -ForegroundColor Cyan
    Write-Host "当前工程已注入专属双星协同规则，可直接进行版本提交！" -ForegroundColor White
    Write-Host "==========================================================" -ForegroundColor Green
}
