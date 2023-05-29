using module BitsTransfer

$script:ModuleRoot = $PSScriptRoot
$script:ModuleInfo = Import-PowerShellDataFile -Path "$($script:ModuleRoot)\VencordModule.psd1"


. "$PSScriptRoot\functions\utils.ps1"

function Update-Vencord {
    [CmdletBinding()]
    # optional param 
    param (

    )
  
    $lastPatchVersion = Get-VencordPatchedVersion
    $discordInstalls = Get-DiscordInstalls

    Write-Host $discordInstalls

    if ($discordInstalls.Count -eq 0) {
        Write-Warning "Could not find any Discord"
        return
    }

    # test if mutiple versions are installed
    if ($discordInstalls.Count -gt 1) {
        Write-Warning "Multiple Discord versions are installed."
        # test if one versions has the name 'Discord'
        if (($discordInstalls | Where-Object { $_.Name -eq "Discord" })) {
            Write-Warning "Found Discord Stable - Selecting it"
            $discordInstalls = $discordInstalls | Where-Object { $_.Name -eq "Discord" }
        }
        else {
            Write-Warning "Could not find Discord Stable"
        }
    }

    

    $discordInstall = $discordInstalls[0]
    $discordInstallPath = $discordInstall.InstallLocation
    $discordVersion = $discordInstall.Version

    if ($discordVersion -eq $lastPatchVersion) {
        Write-Host "Vencord is already up to date ($discordVersion) (Last patched version: $lastPatchVersion)"
        return
    }
    else {
        $vencordCli = Get-VencordCli
        & $vencordCli -install -location $discordInstallPath
        & $vencordCli -install-openasar -location $discordInstallPath
        Write-VencordPatchedVersion -Version $discordVersion

        Write-Host "Vencord has been updated to $discordVersion"
    }
}


