function Get-PXNodes {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['nodes'])"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	Invoke-PXRequest -restParams $restParams -Connection $Connection
}
