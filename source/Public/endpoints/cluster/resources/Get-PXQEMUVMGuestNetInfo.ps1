function Get-PXQEMUVMGuestNetInfo {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][String]$NodeName,
		[Parameter(Mandatory=$true,Position=1)][int]$ID,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['nodes'])/$NodeName/qemu/$ID/agent/network-get-interfaces"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	(Invoke-PXRequest -restParams $restParams -Connection $Connection).result|Where {$_.Name -notlike "Loopback*"}

}
