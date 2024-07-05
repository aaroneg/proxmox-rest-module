function Get-PXLXCVMConfigInfo {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][String]$NodeName,
		[Parameter(Mandatory=$true,Position=1)][int]$ID,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['nodes'])/$NodeName/lxc/$ID/config"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	(Invoke-PXRequest -restParams $restParams -Connection $Connection)
}
