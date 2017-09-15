function test-icon
{
<#
.SYNOPSIS
    Tests to see if Icon exists and matches new application
.DESCRIPTION
    Tests to see if Icon exists and matches new application
.PARAMETER APP
    Newly created application
.PARAMETER APPMATCH
    Existing application
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to

#>
Param (
    [Parameter(Mandatory=$true)]$app, 
    [Parameter(Mandatory=$true)]$appmatch, 
    [Parameter(Mandatory=$true)][string]$xdhost
    )

    $newicon = (Get-BrokerIcon -AdminAddress $xdhost -Uid ($appmatch.IconUid)).EncodedIconData
    if($newicon -like $app.EncodedIconData)
    {
    write-host Icons Match
    $match = $true
    }
    else
    {
    write-host Icons do not match -ForegroundColor Yellow
    $match = $false
    }
return $match
}
