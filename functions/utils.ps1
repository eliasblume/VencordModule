function Get-DownloadFile {
    param(
        [string]$Url,
        [string]$OutputPath
    )

    # Create a temporary file path
    $tempFilePathLocation = Join-Path -Path $env:TEMP -ChildPath (New-Guid).ToString()
    $tempFilePath = "$tempFilePathLocation.exe"

    try {
        # Download the file using BITS transfer
        Start-BitsTransfer -Source $Url -Destination $tempFilePath -ErrorAction Stop

        # Move the downloaded file to the desired location
        Move-Item -Path $tempFilePath -Destination $OutputPath -Force
    }
    finally {
        # Clean up the temporary file
        if (Test-Path $tempFilePath) {
            Remove-Item -Path $tempFilePath -Force
        }
    }
}

function Get-DiscordInstalls {
    # find all discord versions (Disord, Discord PTB, Discord Canary)
    $discordVersions = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -like "Discord*" } |
    Select-Object -Property @{Name = "Name"; Expression = { $_.DisplayName } },
    @{Name = "Version"; Expression = { $_.DisplayVersion } },
    InstallLocation 


    return $discordVersions
}

function Get-VencordCli {
    param ()

    $installerUrl = "https://github.com/Vencord/Installer/releases/latest/download/VencordInstallerCli.exe"
    $installerPath = Join-Path -Path $env:TEMP -ChildPath "VencordInstallerCli.exe"

    Get-DownloadFile -Url $installerUrl -OutputPath $installerPath
    
    return $installerPath
}

function Write-VencordPatchedVersion {
    param (
        [string]$Version
    )
    $regPath = "HKCU:\Software\Vencord"

    if (!(Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }

    Set-ItemProperty -Path $regPath -Name "LastPatchedVersion" -Value $Version
}

function Get-VencordPatchedVersion {
    $regPath = "HKCU:\Software\Vencord"
    return (Get-ItemProperty -Path $regPath -Name "LastPatchedVersion" -ErrorAction Ignore).LastPatchedVersion
}

