#! /usr/bin/pwsh
. $PSScriptRoot\version.ps1

if ($IsLinux) {
	if(!(test-path $env:HOME/.local/share/powershell/Modules/proxmox-rest-module/$moduleVersionTarget)) {New-Item -ItemType Directory -Path ~/.local/share/powershell/Modules/proxmox-rest-module/$moduleVersionTarget}
	Copy-Item $PSScriptRoot\Build\proxmox-rest-module\$moduleVersionTarget\* ~/.local/share/powershell/Modules/proxmox-rest-module/$moduleVersionTarget/
	Import-Module proxmox-rest-module -Force
}
if ($IsWindows){
	$UserModulePath=$env:PSModulePath.Split(';')[0]
	if(!(Test-Path $UserModulePath\proxmox-rest-module\$moduleVersionTarget)) {New-Item -ItemType Directory -Path $UserModulePath/proxmox-rest-module/$moduleVersionTarget -Force}
	Copy-Item $PSScriptRoot\Build\proxmox-rest-module\$moduleVersionTarget\* $UserModulePath/proxmox-rest-module/$moduleVersionTarget
	Import-Module proxmox-rest-module -Force
}
remove-module proxmox-rest-module
import-module proxmox-rest-module -force
Get-Module proxmox-rest-module
