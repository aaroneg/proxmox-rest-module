function Get-PXClusterStatus {
	[CmdletBinding()]
	[Alias("Get-PXCluster")]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	Write-Debug "[$($MyInvocation.MyCommand.Name)] Begin function"
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['cl_status'])"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	(Invoke-PXRequest -restParams $restParams -Connection $Connection)
	Write-Debug "[$($MyInvocation.MyCommand.Name)] Exit function"
}