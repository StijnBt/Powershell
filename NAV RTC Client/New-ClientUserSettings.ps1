<# 
 .Version
  Nav version, supported 2013 - 2018
 .Server
  Name of the server where the application service resides 
 .ServerInstance
  NAV application server instance name
 .TenantId
  Tenant name/id
 .ClientPort
  NAV client port
 .ClientServicesCredentialType
  Authtication for the NAV application server: Windows, Username, NavUserPassword, and AccessControlService 
 .HelpServer
  Name of the server where the help server resides
 .HelpServerPort
  Help server port
 .ForceUpdate
  Wil create a new config file even if it already extists
 .Example
  $config = New-ClientUserSettings -Version 2017 -Server NSTSERVER -ServerInstance DynamicsNAV100 -ClientPort 7046 -ClientServicesCredentialType Windows -ForceUpdate true
  & 'C:\Program Files (x86)\Microsoft Dynamics NAV\100\RoleTailored Client\Microsoft.Dynamics.Nav.Client.exe' "-settings:`"$config`""
#>

function New-ClientUserSettings {
    param (
        [string]$Version,[string]$Server,[string]$ServerInstance,[string]$TenantId,[int]$ClientPort,[string]$ClientServicesCredentialType,[string]$HelpServer,[string]$HelpServerPort,[switch]$ForceUpdate
    )

    [xml]$Doc = New-Object System.Xml.XmlDocument

    switch ($Version) {
        "2013"   {$InternalVersion = 70}
        "2013R2" {$InternalVersion = 71}
        "2015"   {$InternalVersion = 80}
        "2016"   {$InternalVersion = 90}
        "2017"   {$InternalVersion = 100}
        "2018"   {$InternalVersion = 110}
        Default {
            Write-Host "Unknown Dynamics NAV Version" -ForegroundColor Red
            exit
        }
    }

    
    $Path =  $env:APPDATA + '\Microsoft\Microsoft Dynamics NAV\' + $InternalVersion + '\'
    
    if (([System.IO.File]::Exists($Path + $ServerInstance + ".config")) -and -not($ForceUpdate)) {
        Write-Host "File already exists, use ForceUpdate to update an existing file" -ForegroundColor Red
        exit  
    }
            

    $dec = $Doc.CreateXmlDeclaration("1.0","UTF-8",$null)
    $doc.AppendChild($dec)  | Out-Null 

    $root = $doc.CreateNode("element","configuration",$null)
    $appSet = $doc.CreateElement("appSettings")

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","Server")
    $add.SetAttribute("value",$Server)
    $appSet.AppendChild($add)  | Out-Null

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","ClientServicesPort")
    $add.SetAttribute("value",$ClientPort)
    $appSet.AppendChild($add)  | Out-Null

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","ServerInstance")
    $add.SetAttribute("value",$ServerInstance)
    $appSet.AppendChild($add)  | Out-Null

    if ($TenantId -eq $null)
    {
        $add = $doc.CreateElement("add")
        $add.SetAttribute("key","TenantId")
        $add.SetAttribute("value",$TenantId)
        $appSet.AppendChild($add)  | Out-Null
    }

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","ClientServicesCredentialType")
    $add.SetAttribute("value",$ClientServicesCredentialType)
    $appSet.AppendChild($add)  | Out-Null

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","HelpServer")
    $add.SetAttribute("value",$HelpServer)
    $appSet.AppendChild($add)  | Out-Null

    $add = $doc.CreateElement("add")
    $add.SetAttribute("key","HelpServerPort")
    $add.SetAttribute("value",$HelpServerPort)
    $appSet.AppendChild($add)  | Out-Null


    $root.AppendChild($appSet)  | Out-Null
    $doc.AppendChild($root)  | Out-Null

    #save file
    $FileName = $Path + $Server + "-" + $ServerInstance + ".config"
    $doc.save($FileName)   | Out-Null    
    Write-Host "Finished! File located at $FileName" -ForegroundColor Green

    return $FileName
}
