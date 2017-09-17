function New-XDadminfolder 
{
<#
.SYNOPSIS
    Creates new administrative folder
.DESCRIPTION
    Checks for and creates administrative folder if not found
.PARAMETER FOLDER
    Folder to validate
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
Param(
[Parameter(Mandatory=$true,ValueFromPipeline=$true)][string]$folder,
[Parameter(Mandatory=$true)][string]$xdhost
)
    
    process{
        if ($PSCmdlet.ShouldProcess("Creating Folder")) {  
        $paths = @($folder -split "\\"|where-object{$_ -ne ""})

                    $lastfolder = $null
                    for($d=0; $d -le ($paths.Count -1); $d++)
                    {          
                    if($d -eq 0)
                        {                  
                            if((Test-XDBrokerAdminFolder -folder ($paths[$d] + "\") -xdhost $xdhost) -eq $false)
                            {
                            Write-Verbose "Creating folder $paths[$d]"
                            New-BrokerAdminFolder -AdminAddress $xdhost -FolderName $paths[$d]|Out-Null
                            }
                        $lastfolder = $paths[$d]
                        }
                        else
                        {                    
                            if((Test-XDBrokerAdminFolder -folder ($lastfolder + "\" + $paths[$d] + "\") -xdhost $xdhost) -eq $false)
                            {
                            Write-Verbose "Creating folder $paths[$d]"
                            New-BrokerAdminFolder -AdminAddress $xdhost -FolderName $paths[$d] -ParentFolder $lastfolder|Out-Null
                            }
                        $lastfolder = $lastfolder + "\" + $paths[$d]
                        }            
                    }
        }
    }
}
