function Get-PXQEMUNodeInfo {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true,Position=0)][String]$NodeName,
		[Parameter(Mandatory=$false,Position=1)][int]$ID,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['nodes'])/$NodeName/qemu"
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Calling Invoke-PXRequest"
	if($ID){(Invoke-PXRequest -restParams $restParams -Connection $Connection)|Where-Object {$_.VMID -eq $ID}}
	else{(Invoke-PXRequest -restParams $restParams -Connection $Connection)}

}
