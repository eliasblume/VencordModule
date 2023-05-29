<h1 align="center">
    PS> VencordModule
</h1>

<div align="center"> 
    <img src="doc\logo.png" height=312/>
</div>

<p align="center"> 
   Powershell module to automatically patch Discord with Vencord if required
</p>

## Installation
Download from [PowerShell Gallery](https://www.powershellgallery.com/packages/VencordModule) or install via PowerShellGet:

```powershell
Install-Module -Name VencordModule
```

## Usage 

it is recommended to include this into your profile to make it available in every powershell session. Edit `HOMEDIR:\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` and add the following lines:
```powershell
Import-Module VencordModule
```
or just run it in your current session:


To execute the patching process, run the following command:
```powershell
 Update-Vencord
```


## Automation/Topgrade
This is meant to be used together with [Topgrade](https://topgrade-rs.github.io) to automate the process of updating your system.
Simply edit your profile like shown in *Usage*.
Then edit your topgrade config with `topgrade --edit-config` and add this into the commands section:
```toml
# the `commands` key should already exist
[commands]
"Update Vencord" = "Update-Vencord"
```


    


