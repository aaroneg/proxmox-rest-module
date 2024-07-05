#! /usr/bin/pwsh
if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)) {
    Install-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore -Force -Scope CurrentUser
    Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault -AllowClobber
}
#if(!(Get-Module proxmox-rest-module -ListAvailable)) {
#    Install-Module proxmox-rest-module, Microsoft.PowerShell.SecretStore -Force -Scope CurrentUser
#}
Import-Module Microsoft.PowerShell.SecretManagement, Microsoft.PowerShell.SecretStore
# Read or create a netbox config object
try {
    $config=Import-Clixml $PSScriptRoot\pxconfig.xml
}
catch {
    $config=@{
        serverAddress = Read-Host -Prompt "IP address or hostname of Proxmox server ONLY - no port"
		tokenID = Read-Host -Prompt "What is the ID (not the actual token) for the token you want to use?"
    }
    $config | Export-Clixml $PSScriptRoot\pxconfig.xml
}
Import-Module proxmox-rest-module

# Get or create the API credential
try {
    $Secret=Get-Secret -Name $Config.serverAddress -AsPlainText -ErrorAction Stop
}
catch {
    $Secret=Get-Credential -Message "Proxmox User@Realm & API KEY" -Title 'Proxmox Credentials'
    Set-Secret -Name $config.serverAddress -Secret $Secret
}

$Connection = New-PXConnection -DeviceAddress $config.serverAddress -User $Secret.UserName -ApiKey $Secret.GetNetworkCredential().Password -TokenID $config.tokenID -Passthru -SkipCertificateCheck -Verbose
Write-Output "Connection initiated:"
$Connection
