<# 
 .Version
  Nav version, supported 2013 - 2018
 .Server
#>

function New-NavServerUsersFromADGroup {
    param (
        [string]$Version,[string]$ServerInstance,[string]$ADGroup
    )
    
    
    $key = 'HKLM:\SOFTWARE\Microsoft\Microsoft Dynamics NAV\100\Service\'
    $installpath = (Get-ItemProperty -Path $key -Name Path).Path
    
    #debug 
    Write-Host $installpath
}

New-NavServerUsersFromADGroup -Version 100 -ServerInstance EDMAC -ADGroup 'abecon_goep\abecon belgië'
