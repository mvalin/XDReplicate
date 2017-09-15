function New-DeliveryGroupObject 
{
<#
.SYNOPSIS
    Creates new Desktop Delivery Group Object script block
.DESCRIPTION
    Creates new Desktop Delivery Group Object script block and returns to be used by invoke-command
.PARAMETER DG
    New Delivery group object
.PARAMETER XDHOST
    XenDesktop DDC hostname to connect to
#>
Param(
[Parameter(Mandatory=$true)]$dg, 
[Parameter(Mandatory=$true)][string]$xdhost
)
$tempvardg = "New-BrokerDesktopGroup -adminaddress $($xdhost)"
foreach($t in $dg.PSObject.Properties)
    {       
        if(-not ([string]::IsNullOrWhiteSpace($t.Value)))
        {
        $tempstring = ""
            switch ($t.name)
            {
            "Name" {$tempstring = " -Name `"$($t.value)`""}
            "DesktopKind" {$tempstring = " -DesktopKind `"$($t.value)`""}
            "AutomaticPowerOnForAssigned" {$tempstring = " -AutomaticPowerOnForAssigned `$$($t.value)"}
            "AutomaticPowerOnForAssignedDuringPeak" {$tempstring = " -AutomaticPowerOnForAssignedDuringPeak `$$($t.value)"}
            "ColorDepth" {$tempstring = " -ColorDepth `"$($t.value)`""}
            "DeliveryType" {$tempstring = " -DeliveryType `"$($t.value)`""}
            "Description" {$tempstring = " -Description `"$($t.value)`""}
            "Enabled" {$tempstring = " -Enabled `$$($t.value)"}
            "InMaintenanceMode" {$tempstring = " -InMaintenanceMode `$$($t.value)"}
            "IsRemotePC" {$tempstring = " -IsRemotePC `$$($t.value)"}
            "MinimumFunctionalLevel" {$tempstring = " -MinimumFunctionalLevel `"$($t.value)`""}
            "OffPeakBufferSizePercent" {$tempstring = " -OffPeakBufferSizePercent `"$($t.value)`""}
            "OffPeakDisconnectAction" {$tempstring = " -OffPeakDisconnectAction `"$($t.value)`""}
            "OffPeakDisconnectTimeout" {$tempstring = " -OffPeakDisconnectTimeout `"$($t.value)`""}
            "OffPeakExtendedDisconnectAction" {$tempstring = " -OffPeakExtendedDisconnectAction `"$($t.value)`""}
            "OffPeakExtendedDisconnectTimeout" {$tempstring = " -OffPeakExtendedDisconnectTimeout `"$($t.value)`""}
            "OffPeakLogOffAction" {$tempstring = " -OffPeakLogOffAction `"$($t.value)`""}
            "OffPeakLogOffTimeout" {$tempstring = " -OffPeakLogOffTimeout `"$($t.value)`""}
            "PeakBufferSizePercent" {$tempstring = " -PeakBufferSizePercent `"$($t.value)`""}
            "PeakDisconnectAction" {$tempstring = " -PeakDisconnectAction `"$($t.value)`""}
            "PeakDisconnectTimeout" {$tempstring = " -PeakDisconnectTimeout `"$($t.value)`""}
            "PeakExtendedDisconnectAction" {$tempstring = " -PeakExtendedDisconnectAction `"$($t.value)`""}
            "PeakExtendedDisconnectTimeout" {$tempstring = " -PeakExtendedDisconnectTimeout `"$($t.value)`""}
            "PeakLogOffAction" {$tempstring = " -PeakLogOffAction `"$($t.value)`""}
            "PeakLogOffTimeout" {$tempstring = " -PeakLogOffTimeout `"$($t.value)`""}
            "ProtocolPriority" {$tempstring = " -ProtocolPriority `"$($t.value)`""}
            "PublishedName" {$tempstring = " -PublishedName `"$($t.value)`""}
            "SecureIcaRequired" {$tempstring = " -SecureIcaRequired `$$($t.value)"}
            "SessionSupport" {$tempstring = " -SessionSupport `"$($t.value)`""}
            "ShutdownDesktopsAfterUse" {$tempstring = " -ShutdownDesktopsAfterUse `$$($t.value)"}
            "SettlementPeriodBeforeAutoShutdown" {$tempstring = " -SettlementPeriodBeforeAutoShutdown `"$($t.value)`""}
            "TimeZone" {$tempstring = " -TimeZone `"$($t.value)`""}
            "TurnOnAddedMachine" {$tempstring = " -TurnOnAddedMachine `$$($t.value)"}
            }
            $tempvardg = $tempvardg +  $tempstring
             
         }
    }
 return $tempvardg
}
