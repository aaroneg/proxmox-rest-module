#! /usr/bin/pwsh
. $PSScriptRoot\version.ps1

$publishModuleSplat = @{
    Path = "$PSScriptRoot\Build\proxmox-rest-module\$moduleVersionTarget"
    Repository = 'PSGallery'

}
Publish-Module @publishModuleSplat -NuGetApiKey (Read-Host -Prompt 'API Key')
install-module proxmox-rest-module -Scope CurrentUser -Force
