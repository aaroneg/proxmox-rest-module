function parseNICConfigLXC ($Definition) {
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Begin"
	Write-Verbose ("[$($MyInvocation.MyCommand.Name)] " + ($Definition|Out-String))
	$NameHunt=$Definition | Select-String -Pattern 'name=([\w\d]+),'
	$MACHunt=$Definition | Select-String -Pattern 'hwaddr=([0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2})'
	$IPv4Hunt=$Definition | Select-String -Pattern 'ip=((?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[\d]{1,2})'
	$IPv6Hunt= $Definition | Select-String -Pattern 'ip6=((?:[A-F0-9]{1,4}:){7}[A-F0-9]{1,4}\/[\d]{1,3})'
	$Name= $NameHunt.Matches.Groups[1].Value
	$MAC = $MACHunt.Matches.Groups[1].Value
	if ($null -ne $IPv4Hunt) {$IPv4 = $IPv4Hunt.Matches.Groups[1].Value}
	else {$IPv4 = 'dhcp'}
	if ($null -ne $IPv6Hunt) {$IPv6 = $IPv6Hunt.Matches.Groups[1].Value}
	else {$IPv6 = 'auto'}
	$Results=[PSCustomObject]@{
		Name = $Name
		MAC  = $MAC
		IPv4 = $IPv4
		IPv6 = $IPv6
	}
	$Results
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] End"
	#>
}

function parseQEMUNetworkConfig ($NetInfo) {
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Begin"
	[System.Collections.ArrayList]$Results=@()
	foreach ($Item in $NetInfo) {
		$tempItem=[PSCustomObject]@{
			Name = $Item.Name
			MAC  = $Item.Definition.Split('=')[2].Split(',')[0]
		}
		$Results.Add($tempItem)|Out-Null
	}
	$Results
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] End"
}
