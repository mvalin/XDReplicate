function Set-AppEntitlement  {
<#
.SYNOPSIS
    Sets AppEntitlement if missing
.DESCRIPTION
    Sets AppEntitlement if missing
.PARAMETER DG
    Desktop Group where to create entitlement
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
#>
Param (
    [Parameter(Mandatory=$true)]$dg, 
    [Parameter(Mandatory=$true)][string]$xdhost)
    if (($dg.DeliveryType -like "AppsOnly" -or $dg.DeliveryType -like "DesktopsAndApps"))
    {
        if((Get-BrokerAppEntitlementPolicyRule -name $dg.Name -AdminAddress $xdhost -ErrorAction SilentlyContinue) -is [Object])
        {
        write-host "AppEntitlement already present"
        }
        ELSE
        {
        write-host "Creating AppEntitlement"
        New-BrokerAppEntitlementPolicyRule -Name $dg.Name -DesktopGroupUid $dg.uid -AdminAddress $xdhost -IncludedUserFilterEnabled $false|Out-Null
        }
    }
    else
    {
    write-host "No AppEntitlement needed"
    }

}
