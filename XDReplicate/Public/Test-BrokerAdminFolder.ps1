function Test-BrokerAdminFolder 
{
<#
.SYNOPSIS
    Tests if administrative folder exists
.DESCRIPTION
    Checks for administrative folder and returns bool
.PARAMETER FOLDER
    Folder to validate
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
#>

Param(
[Parameter(Mandatory=$true)][string]$folder,
[Parameter(Mandatory=$true)][string]$xdhost)
    
    write-host "Processing Folder $folder" -ForegroundColor Magenta
    #Doesn't follow normal error handling so can't use try\catch
    Get-BrokerAdminFolder -AdminAddress $xdhost -name $folder -ErrorVariable myerror -ErrorAction SilentlyContinue
    if ($myerror -like "Object does not exist")
    {
    write-host "FOLDER NOT FOUND" -ForegroundColor YELLOW
    $found = $false
    }
    else
    {
    write-host "FOLDER FOUND" -ForegroundColor GREEN
    $found = $true
    }
return $found
}
