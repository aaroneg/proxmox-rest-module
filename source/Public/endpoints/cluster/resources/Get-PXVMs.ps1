function Get-PXVMs {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$false)][switch]$IncludeAllIPs,
		[Parameter(Mandatory=$false)][object]$Connection=$Script:PXConnection
	)
	$restParams=@{
		Method = 'Get'
		Uri = "$($Connection.ApiBaseUrl)/$($apiPaths['cl_resources'])"
	}
	$QEMUS=Get-PXQEMUs
	$LXCS=Get-PXLXCs
	[System.Collections.ArrayList]$Results=@()
	foreach ($item in $QEMUS){
		$VMConfigInfo=Get-PXQEMUVMConfigInfo -NodeName $item.Node -ID $item.VMID
		$NetworkDevicesConfig= parseQEMUNetworkConfig ($VMConfigInfo|Get-Member|Where-Object {$_.Name -like 'net*'})
		[System.Collections.ArrayList]$NICInfo=@()
		try {
			$NetworkDevicesAgent= Get-PXQEMUVMGuestNetInfo -NodeName $item.Node -ID $item.VMID -erroraction stop
			Foreach($netDevice in $NetworkDevicesConfig) {
				$IPv4Entries=(($NetworkDevicesAgent | Where-Object {$_.'hardware-address' -eq $netDevice.MAC}).'ip-addresses'|Where-Object {$_.'ip-address-type' -eq 'ipv4'})
				$IPv4String=($IPv4Entries| % {"$($_.'ip-address')/$($_.prefix)"}) -join ','
				if ($IncludeAllIPs){$IPv6Entries=(($NetworkDevicesAgent | Where-Object {$_.'hardware-address' -eq $netDevice.MAC}).'ip-addresses'|Where-Object {$_.'ip-address-type' -eq 'ipv6'})}
				else{$IPv6Entries=(($NetworkDevicesAgent | Where-Object {$_.'hardware-address' -eq $netDevice.MAC}).'ip-addresses'|Where-Object {$_.'ip-address-type' -eq 'ipv6' -and $_.'ip-address' -notlike 'fe80*' -and $_.prefix -ne 128})}
				$IPv6String=($IPv6Entries| % {"$($_.'ip-address')/$($_.prefix)"}) -join ','
				$NicEntry=[PSCustomObject]@{
					Name = $netDevice.Name
					MAC  = $netDevice.MAC
					IPv4 = $IPv4String
					IPv6 = $IPv6String
				}
				$NICInfo.Add($NicEntry)|Out-Null
			}
		}
		catch{
			Foreach($netDevice in $NetworkDevicesConfig) {
				$NicEntry=[PSCustomObject]@{
					Name = $netDevice.Name
					MAC  = $netDevice.MAC
					IPv4 = ''
					IPv6 = ''
				}
				$NICInfo.Add($NicEntry)|Out-Null
			}
		}
		$ReportItem=[PSCustomObject]@{
			VMID = $item.vmid
			Name  = (Get-PXQEMUNodeInfo -NodeName $item.Node -ID $item.VMID).name
			Node = $item.Node
			CPUCount= $item.maxcpu
			MemGB = ($item.maxmem/1GB)
			DiskGB = ($item.maxdisk/1GB)
			Type = 'QEMU'
			Status = $item.status
		}
		$ReportItem | Add-Member -MemberType NoteProperty -Name NICs -Value $NICInfo
		$Results.Add($ReportItem)|Out-Null
	}
	foreach ($item in $LXCS){
		$NetworkDevicesConfig=((Get-PXLXCVMConfigInfo -NodeName $item.Node -ID $item.VMID)|Get-member |Where-Object {$_.Name -like 'net*'})
		[System.Collections.ArrayList]$NICInfo=@()
		foreach ($nicItem in $NetworkDevicesConfig){
			$Definition=parseNICConfigLXC($nicItem.Definition)
			$NicEntry=[PSCustomObject]@{
				Name = $nicItem.Name
				MAC  = $Definition.MAC
				IPv4 = $Definition.IPv4
				IPv6 = $Definition.IPv6
			}
			$NICInfo.Add($NicEntry)|Out-Null
		}

		$ReportItem=[PSCustomObject]@{
			VMID = $item.vmid
			Name  = $item.name
			Node = $item.Node
			CPUCount= $item.maxcpu
			MemGB = ($item.maxmem/1GB)
			DiskGB = ($item.maxdisk/1GB)
			Type = 'LXC'
			Status = $item.status
		}
		$ReportItem | Add-Member -MemberType NoteProperty -Name NICs -Value $NICInfo
		#[array]$ReportNICs=((Get-PXLXCVMConfigInfo -NodeName $item.Node -ID $item.VMID)|Get-member |Where-Object {$_.Name -like 'net*'})
		#$ReportItem | Add-Member -MemberType NoteProperty -Name NICs -Value $ReportNICs
		#$ReportItem | Add-Member -MemberType NoteProperty -Name NICs -Value $ParsedNICInfo
		$Results.Add($ReportItem)|Out-Null
	}
	$Results

}
