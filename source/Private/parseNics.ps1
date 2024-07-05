function parseNICConfigLXC ($Definition) {
	$NameHunt=$Definition | Select-String -Pattern 'name=([\w\d]+),'
	$MACHunt=$Definition | Select-String -Pattern 'hwaddr=([0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2}:[0-9,A-F]{2})'
	$IPv4Hunt=$Definition | Select-String -Pattern 'ip=((?:[0-9]{1,3}\.){3}[0-9]{1,3})'
	$IPv6Hunt= $Definition | Select-String -Pattern 'ip6=((?:[A-F0-9]{1,4}:){7}[A-F0-9]{1,4})'
	$Name= $NameHunt.Matches.Groups[1].Value
	$MAC = $MACHunt.Matches.Groups[1].Value
	if ($null -ne $IPv4Hunt) {$IPv4 = $IPv4Hunt.Matches.Groups[1].Value}
	else {$IPv4 = 'dhcp'}
	$IPv6= $IPv6Hunt.Matches.Groups[1].Value
	$Results=[PSCustomObject]@{
		Name = $Name
		MAC  = $MAC
		IPv4 = $IPv4
		IPv6 = $IPv6
	}
	$Results
	#>
}

function parseQEMUNetworkConfig ($NetInfo) {
	[System.Collections.ArrayList]$Results=@()
	foreach ($Item in $NetInfo) {
		$tempItem=[PSCustomObject]@{
			Name = $Item.Name
			MAC  = $Item.Definition.Split('=')[2].Split(',')[0]
		}
		$Results.Add($tempItem)|Out-Null
	}
	$Results
}
