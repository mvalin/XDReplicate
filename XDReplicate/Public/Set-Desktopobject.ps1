function Set-Desktopobject 
{
<#
.SYNOPSIS
    Sets existing desktop entitlement settings
.DESCRIPTION
    Script block to set desktop entitlement is returned to be piped to invoke-expression
.PARAMETER Desktop
    Exported Desktop
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
#>
Param (
[Parameter(Mandatory=$true)]$desktop, 
[Parameter(Mandatory=$true)][string]$xdhost)

$tempvardesktop = "Set-BrokerEntitlementPolicyRule -adminaddress $($xdhost)"
foreach($t in $desktop.PSObject.Properties)
    {
           
        if(-not ([string]::IsNullOrWhiteSpace($t.Value)))
        {
        $tempstring = ""
            switch ($t.name)
            {
                "Name" {$tempstring = " -name `"$($t.value)`""}
                "ColorDepth" {$tempstring = " -ColorDepth `"$($t.value)`""}
                "Description" {$tempstring = " -Description `"$($t.value)`""}
                "Enabled" {$tempstring = " -Enabled `$$($t.value)"}
                "LeasingBehavior" {$tempstring = " -LeasingBehavior `"$($t.value)`""}
                "PublishedName" {$tempstring = " -PublishedName `"$($t.value)`""}
                "RestrictToTag" {$tempstring = " -RestrictToTag `"$($t.value)`""}
                "SecureIcaRequired" {$tempstring = " -SecureIcaRequired `"$($t.value)`""}
                "SessionReconnection" {$tempstring = " -SessionReconnection `"$($t.value)`""}
               
            }
         $tempvardesktop = $tempvardesktop +  $tempstring
         }
    }
return $tempvardesktop
}
