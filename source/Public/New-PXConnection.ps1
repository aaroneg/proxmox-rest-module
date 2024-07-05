function New-PXConnection {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][string]$DeviceAddress,
		[Parameter(Mandatory=$true,Position=1)][string]$User,
		[Parameter(Mandatory=$true,Position=2)][string]$TokenID,
		[Parameter(Mandatory=$true,Position=3)][string]$ApiKey,
		[Parameter(Mandatory=$false)][int]$port=8006,
		[Parameter(Mandatory=$false)][switch]$SkipCertificateCheck,
		[Parameter(Mandatory=$false)][switch]$Passthru
	)
	$ConnectionProperties = @{
		Address = "$DeviceAddress"
		ApiKey = $ApiKey
		ApiBaseUrl = "https://$($DeviceAddress):$port/api2/json"
		User = $User
		TokenID = $TokenID
		SkipCertificateCheck = $SkipCertificateCheck
	}
	$PXConnection = New-Object psobject -Property $ConnectionProperties
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($PXConnection.Address)' is now the default connection."
	$Script:PXConnection = $PXConnection
	if ($Passthru) {
		$PXConnection
	}
} 