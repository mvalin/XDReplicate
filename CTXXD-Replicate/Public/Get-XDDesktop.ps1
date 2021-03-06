function get-xddesktop {
<#
.SYNOPSIS
   Gets Desktop machine of user given Machine catalog
.DESCRIPTION
   Gets Desktop machine of user given Machine catalog
.PARAMETER dgroup
   Delivery group to query from
.PARAMETER user
   What user 
.EXAMPLE
   get-xddesktop -dggroup "Windows 10 Desktop" -user "lab\jsmith
#>
[cmdletbinding()]
param(
    $dgroup,
    $user,
    [Parameter(Mandatory=$false)][string]$xdhost="localhost")

$desktop = Get-BrokerMachine -DesktopGroupName $dgroup -AssociatedUserName $user -adminaddress $xdhost
    
    if($desktop.count -gt 1)
    {
        throw "Multiple desktops found."
    }
    elseif (-not ($desktop -is [object]))
    {
        return $false
    }
    else
    {
        return $desktop
    }

}
