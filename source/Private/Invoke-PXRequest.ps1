function Invoke-PXRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $True, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		Authorization = "PVEAPIToken $($Connection.User)!$($Connection.TokenID)=$($Connection.ApiKey)"
		"Content-Type"    = 'application/json'
	}
	Write-Verbose ("[$($MyInvocation.MyCommand.Name)] REST params:`n" + ($restParams|Out-String))
	Write-Verbose ("[$($MyInvocation.MyCommand.Name)] Headers:`n" + ($Headers|Out-String))
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers -SkipCertificateCheck:$Connection.SkipCertificateCheck -ResponseHeadersVariable $ResponseHeaders -StatusCodeVariable $StatusCode
		Write-Verbose ("[$($MyInvocation.MyCommand.Name)] ResponseHeaders:`n" + ($ResponseHeaders|Out-String))
		Write-Verbose ("[$($MyInvocation.MyCommand.Name)] StatusCode:`n" + ($StatusCode|Out-String))
	}
	catch {
		Write-Error ("[$($MyInvocation.MyCommand.Name)] Exception:`n" + ($_.Exception.Message|Out-String))
	}
	$result.data
}
 