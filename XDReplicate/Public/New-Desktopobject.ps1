function New-Desktopobject 
{
<#
.SYNOPSIS
    Creates new Desktop entitlement policy Object script block
.DESCRIPTION
    Creates new Desktop entitlement policy object script block and returns to be used by invoke-expression
.PARAMETER Desktop
    New desktop object
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
.PARAMETER DGUID
    Delivery group UID to create desktop
#>
Param(
[Parameter(Mandatory=$true)]$desktop, 
[Parameter(Mandatory=$true)][string]$xdhost, 
[Parameter(Mandatory=$true)][string]$dguid)

$tempvardesktop = "New-BrokerEntitlementPolicyRule -adminaddress $($xdhost) -DesktopGroupUid $($dguid)"
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
                "IncludedUserFilterEnabled" {$tempstring = " -IncludedUserFilterEnabled `$$($t.value)"}
                "LeasingBehavior" {$tempstring = " -LeasingBehavior `"$($t.value)`""}
                "PublishedName" {$tempstring = " -PublishedName `"$($t.value)`""}
                "RestrictToTag" {$tempstring = " -RestrictToTag `"$($t.value)`""}
                "SecureIcaRequired" {$tempstring = " -SecureIcaRequired `"$($t.value)`""}

                #"SessionReconnection" {$tempstring = " -SessionReconnection `"$($t.value)`""} Fails for LTSR
               
            }
         $tempvardesktop = $tempvardesktop +  $tempstring
         }
    }
return $tempvardesktop
}
