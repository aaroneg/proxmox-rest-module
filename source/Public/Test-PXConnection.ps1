function Test-PXConnection {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)][object]$PXConnection=$Script:PXConnection
	)
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Trying to connect"
	try {
		Get-PXStatus -Connection $PXConnection
	}
	catch {
		write-error "failed"
		$NBConnection
	}
}