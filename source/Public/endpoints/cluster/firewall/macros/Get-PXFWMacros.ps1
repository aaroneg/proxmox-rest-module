function Get-PXFWMacros {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['cl_fw_macros'])"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	Invoke-PXRequest -restParams $restParams -Connection $Connection
}
