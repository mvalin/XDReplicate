function New-XDFTAobject
{
<#
.SYNOPSIS
    Creates FTA (File Type Association) object
.DESCRIPTION
    Creates FTA (File Type Association) object
.PARAMETER FTA
    Existing FTA object

#>
[cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
Param (
    [Parameter(Mandatory=$true)][string]$xdhost,
    [Parameter(Mandatory=$true)]$FTA,
    [Parameter(Mandatory=$true)]$newapp
    )

Write-Verbose "BEGIN: $($MyInvocation.MyCommand)"
$temp = @{}
foreach($t in $fta.PSObject.Properties)
    {       
        if(-not ([string]::IsNullOrWhiteSpace($t.Value)))
        {
            switch ($t.name)
            {
                "ExtensionName" {$temp.Add("ExtensionName",$t.value)}
                "ContentType" {$temp.Add("ContentType",$t.value)}
                "HandlerOpenArguments" {$temp.Add("HandlerOpenArguments",$t.value)}
                "HandlerDescription" {$temp.Add("HandlerDescription",$t.value)}
                "HandlerName" {$temp.Add("HandlerName",$t.value)}
            }
         }
    }

    if ($PSCmdlet.ShouldProcess("Creating FTA Object")) {    
        try {
        $tempvar = New-BrokerConfiguredFTA @temp -adminaddress $xdhost -ApplicationUid $newapp.uid -Verbose:$VerbosePreference
        }
        catch {
            throw $_
        }
    }
    return $tempvar
    Write-Verbose "END: $($MyInvocation.MyCommand)"
}
