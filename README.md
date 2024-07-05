# proxmox-rest-module

## Installing

`install-module proxmox-rest-module`

## Scope

This module is currently limited to pulling just enough information out of proxmox to write information into Netbox.

## Development patterns

`/Private` - a few helper functions to cut down on code repetition

`/Public/endpoints/*/*.ps1` - functions specific to each division and endpoint

Most functions to directly manipulate an item in Proxmox will use the functions defined in /Private/api-items.ps1.

## Usage

> This module is only tested with PowerShell 7 but it'll probably work with Windows Powershell

You can get a full listing of currently supported commands using `get-command -module proxmox-rest-module`.

See [setup-test-environment.ps1](setup-test-environment.ps1) for how to use this module in your scripts the way I do.

If something isn't on the list that you need, and you're willing to put in the effort to make it work, I will happily accept PRs that match the existing style. Most of these .ps1 files are copy/pasteable with minor alterations for basic functionality - just find another endpoint that's similar and dive in.
