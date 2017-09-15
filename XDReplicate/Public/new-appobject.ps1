function new-appobject 
{
<#
.SYNOPSIS
    Creates broker application script block
.DESCRIPTION
    Script block to create application is returned to be piped to invoke-command
.PARAMETER APP
    Broker Application to create
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
.PARAMETER DGMATCH
    Delivery group to create application

#>
Param(
[Parameter(Mandatory=$true)]$app,
[Parameter(Mandatory=$true)][string]$xdhost, 
[Parameter(Mandatory=$true)][string]$dgmatch
)

$tempvarapp = "New-BrokerApplication -adminaddress $($xdhost) -DesktopGroup `"$($dgmatch)`""
foreach($t in $app.PSObject.Properties)
    {       
        if(-not ([string]::IsNullOrWhiteSpace($t.Value)))
        {
         $tempstring = "" 
            switch ($t.name)
            {
                "AdminFolderName" {$tempstring = " -AdminFolder `"$($t.value)`""}
                "ApplicationGroup" {$tempstring = " -ApplicationGroup `"$($t.value)`""}
                "ApplicationType" {$tempstring = " -ApplicationType `"$($t.value)`""}
                "BrowserName" {$tempstring = " -BrowserName `"$($t.value)`""}
                "ClientFolder" {$tempstring = " -ClientFolder `"$($t.value)`""}
                "CommandLineArguments" {$tempstring = " -CommandLineArguments '{0}'" -f $t.value }
                #"CommandLineArguments" {$tempstring = " -CommandLineArguments `"$($t.value)`"" }
                "CommandLineExecutable" {$tempstring = " -CommandLineExecutable `"$($t.value)`""}
                "CpuPriorityLevel" {$tempstring = " -CpuPriorityLevel `"$($t.value)`""}
                "DesktopGroup" {$tempstring = " -DesktopGroup `"$($t.value)`""}
                "Description" {$tempstring = " -Description `"$($t.value)`""}
                "Enabled" {$tempstring = " -Enabled `$$($t.value)"}
                "MaxPerUserInstances" {$tempstring = " -MaxPerUserInstances `"$($t.value)`""}
                "MaxTotalInstances" {$tempstring = " -MaxTotalInstances `"$($t.value)`""}
                "Name" {$tempstring = " -name `"$($app.applicationname)`""}
                "Priority" {$tempstring = " -Priority `"$($t.value)`""}
                "PublishedName" {$tempstring = " -PublishedName `"$($t.value)`""}
                "SecureCmdLineArgumentsEnabled" {$tempstring = " -SecureCmdLineArgumentsEnabled `$$($t.value)"}
                "ShortcutAddedToDesktop" {$tempstring = " -ShortcutAddedToDesktop `$$($t.value)"}
                "ShortcutAddedToStartMenu" {$tempstring = " -ShortcutAddedToStartMenu `$$($t.value)"}
                "StartMenuFolder" {$tempstring = " -StartMenuFolder `"$($t.value)`""}
                "UserFilterEnabled" {$tempstring = " -UserFilterEnabled `$$($t.value)"}
                "Visible" {$tempstring = " -Visible `$$($t.value)"}
                "WaitForPrinterCreation" {$tempstring = " -WaitForPrinterCreation `$$($t.value)"}
                "WorkingDirectory" {$tempstring = " -WorkingDirectory `"$($t.value)`""}
            
            }
         $tempvarapp = $tempvarapp +  $tempstring
         }
    }

return $tempvarapp
}
