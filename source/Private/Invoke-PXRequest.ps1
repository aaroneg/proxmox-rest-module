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
	$callstack=Get-PSCallStack
	Write-Debug ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] REST params:`n" + ($restParams|Out-String))
	Write-Debug ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Headers:`n" + ($Headers|Out-String))
	Write-Verbose "[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Making API $($restParams.Method) call to $($restParams.Uri)"
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers -SkipCertificateCheck:$Connection.SkipCertificateCheck -ResponseHeadersVariable $ResponseHeaders -StatusCodeVariable $StatusCode
	}
	catch {
		Write-Error ("[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Exception:`n" + ($_.Exception.Message|Out-String))
	}
	$result.data
	Write-Debug "[$($Callstack[1].command) ⇒ $($MyInvocation.MyCommand.Name)] Exiting function"
}
 