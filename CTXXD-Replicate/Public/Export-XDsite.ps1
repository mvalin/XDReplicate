function Export-XDsite
{
<#
.SYNOPSIS
    Exports XD site information to variable
.DESCRIPTION
    Exports XD site information to variable
.PARAMETER XDHOST
   XenDesktop DDC hostname to connect to
.PARAMETER DGTAG
   Only export delivery groups with specified tag
.PARAMETER IGNOREDGTAG
   Skips export of delivery groups with specified tag
.PARAMETER APPTAG
   Export delivery group applications with specific tag
.PARAMETER IGNOREAPPTAG
   Exports all delivery group applications except ones with specific tag
#>
[CmdletBinding()]
Param (
[Parameter(Mandatory=$true)][string]$xdhost,
[Parameter(Mandatory=$false)][string]$dgtag,
[Parameter(Mandatory=$false)][string]$ignoredgtag,
[Parameter(Mandatory=$false)][string]$apptag,
[Parameter(Mandatory=$false)][string]$ignoreapptag
)

begin{
    #Checks for Snappins
    Test-XDmodule
}

process {
        #Need path for XML while in EXPORT
        $ddcver = (Get-BrokerController -AdminAddress $xdhost).ControllerVersion | Select-Object -first 1

        if(-not ([string]::IsNullOrWhiteSpace($dgtag)))
        {
        $DesktopGroups = Get-BrokerDesktopGroup -AdminAddress $xdhost -Tag $dgtag -MaxRecordCount 2000|Where-Object{$_.Tags -notcontains $ignoredgtag}
        }
        else
        {
        $DesktopGroups = Get-BrokerDesktopGroup -AdminAddress $xdhost -MaxRecordCount 2000|Where-Object{$_.Tags -notcontains $ignoredgtag}
        }

        if(!($DesktopGroups -is [object]))
        {
        throw "NO DELIVERY GROUPS FOUND"
        }

        #Create Empty arrays
        $appobject = @()
        $desktopobject = @()

        #Each delivery group
        foreach ($DG in $DesktopGroups)
        {
            Write-Verbose $DG.Name
            $dg|add-member -NotePropertyName 'AccessPolicyRule' -NotePropertyValue (Get-BrokerAccessPolicyRule -AdminAddress $xdhost -DesktopGroupUid $dg.Uid -MaxRecordCount 2000)
            $dg|add-member -NotePropertyName 'PreLaunch' -NotePropertyValue (Get-BrokerSessionPreLaunch -AdminAddress $xdhost -Desktopgroupuid $dg.Uid -ErrorAction SilentlyContinue)
            $dg|add-member -NotePropertyName 'PowerTime' -NotePropertyValue (Get-BrokerPowerTimeScheme -AdminAddress $xdhost -Desktopgroupuid $dg.Uid -ErrorAction SilentlyContinue)
            
            #Grabs APP inf
            if(-not ([string]::IsNullOrWhiteSpace($apptag)))
            {
                #App argument doesn't exist for LTSR.  Guessing 7.11 is the first to support
                if ([version]$ddcver -lt "7.11")
                {
                    write-warning "Ignoring APP TAG ARGUMENTS."
                    $apps = Get-BrokerApplication -AdminAddress $xdhost -AssociatedDesktopGroupUUID $dg.UUID -MaxRecordCount 2000
                }
                else {
                    $apps = Get-BrokerApplication -AdminAddress $xdhost -AssociatedDesktopGroupUUID $dg.UUID -Tag $apptag -MaxRecordCount 2000|Where-Object{$_.Tags -notcontains $ignoreapptag}
                }
            
            }
            else
            {
                if ([version]$ddcver -lt "7.11")
                {
                $apps = Get-BrokerApplication -AdminAddress $xdhost -AssociatedDesktopGroupUUID $dg.UUID -MaxRecordCount 2000  
                
                }
                else {
                $apps = Get-BrokerApplication -AdminAddress $xdhost -AssociatedDesktopGroupUUID $dg.UUID -MaxRecordCount 2000|Where-Object{$_.Tags -notcontains $ignoreapptag}
                }
            }

            
            if($apps -is [object])
            {   
                foreach ($app in $apps)
                {
                    Write-Verbose "Processing $($app.ApplicationName)"

                    #Icon data
                    $BrokerEnCodedIconData = (Get-BrokerIcon -AdminAddress $xdhost -Uid ($app.IconUid)).EncodedIconData
                    $app|add-member -NotePropertyName 'EncodedIconData' -NotePropertyValue $BrokerEnCodedIconData
                    #Adds delivery group name to object
                    $app|add-member -NotePropertyName 'DGNAME' -NotePropertyValue $dg.Name
        
                    #File type associations
                    $ftatemp = @()
                    Get-BrokerConfiguredFTA -AdminAddress $xdhost -ApplicationUid $app.Uid | ForEach-Object -Process {
                    $ftatemp += $_
                    }
                
                    if($ftatemp.count -gt 0)
                    {
                    $app|add-member -NotePropertyName "FTA" -NotePropertyValue $ftatemp
                    }
            
                $appobject += $app
                }    
            }
        

        #Grabs Desktop info
        $desktops = Get-BrokerEntitlementPolicyRule -AdminAddress $xdhost -DesktopGroupUid $dg.Uid -MaxRecordCount 2000
            if($desktops -is [object])
            {
        
                foreach ($desktop in $desktops)
                {
                Write-Verbose "Processing $($desktop.Name)"
                #Adds delivery group name to object
                $desktop|add-member -NotePropertyName 'DGNAME' -NotePropertyValue $dg.Name
                $desktopobject += $desktop
                }
        
            }
        #}


    }

        #buid output object
        $xdout = New-Object PSCustomObject
        Write-Verbose "Processing Administrators"
        $xdout|Add-Member -NotePropertyName "admins" -NotePropertyValue (Get-AdminAdministrator -AdminAddress $xdhost)
        Write-Verbose "Processing Scopes"
        $xdout|Add-Member -NotePropertyName "adminscopes" -NotePropertyValue (Get-AdminScope -AdminAddress $xdhost|where-object{$_.BuiltIn -eq $false})
        Write-Verbose "Processing Roles"
        $xdout|Add-Member -NotePropertyName "adminroles" -NotePropertyValue (Get-AdminRole -AdminAddress $xdhost|where-object{$_.BuiltIn -eq $false})
        $xdout|Add-Member -NotePropertyName "dgs" -NotePropertyValue $DesktopGroups
        $xdout|Add-Member -NotePropertyName "apps" -NotePropertyValue $appobject
        $xdout|Add-Member -NotePropertyName "desktops" -NotePropertyValue $desktopobject
        Write-Verbose "Processing Tags"
        $xdout|Add-Member -NotePropertyName "tags" -NotePropertyValue (Get-BrokerTag -AdminAddress $xdhost -MaxRecordCount 2000)

        #Export to either variable or XML
        if($xmlpath)
        {
        Write-Verbose "Writing to $($XMLPath)" -ForegroundColor Green
        $xdout|Export-Clixml -Path ($XMLPath)
        }
        else
        {
        return $xdout
        }

    }
}
