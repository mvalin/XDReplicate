function new-xddesktop
        {
        <#
        .SYNOPSIS
        Private function to create desktops
        .DESCRIPTION
        Private function to create desktops
        .PARAMETER howmany
        How many destkops to create
        .PARAMETER machinecat
        Machine catalog to create desktops
        .PARAMETER dgroup
        Delivery group to bind desktops to
        .PARAMETER user
        User to add to delivery group
        #>
        [cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact='Low')]
        param(
        [Parameter(Mandatory=$true)]$howmany,
        [Parameter(Mandatory=$true)]$machinecat,
        [Parameter(Mandatory=$true)]$dgroup,
        $user=$null,
        [Parameter(Mandatory=$false)][string]$xdhost="localhost"
        )
            if ($PSCmdlet.ShouldProcess("Deploying desktops")) {
                $accounts = Get-AcctADAccount -IdentityPoolName $machinecat -adminaddress $xdhost|Where-Object{$_.state -like "Available"}|Select-Object -first $howmany

                #Provision out the VMS
                if ($accounts.count -eq $howmany)
                {
				$tempreturn = @()
                    foreach ($newact in $accounts)
                    {
                        if($newact.state -like "Available")
                        {
                        Write-Verbose $newact.ADAccountName
                        #Provision VM
                        Write-Verbose "Provisioning VM"
                        $new = New-ProvVM -ADAccountName $newact.ADAccountName -ProvisioningSchemeName $machinecat -adminaddress $xdhost
                            if ($new.VirtualMachinesCreationFailedCount -eq 1)
                            {
                            throw $new.TaskStateInformation
                            }
                            else
                            {
                            #locking account
                            Lock-ProvVM -ProvisioningSchemeName $machinecat -Tag "Brokered" -VMID (get-provvm -VMname $new.CreatedVirtualMachines.vmname) -adminaddress $xdhost
                            #adding VM to the site
                            $brokeredmach = New-BrokerMachine -CatalogUid ((Get-BrokerCatalog $machinecat).Uid) -MachineName $newact.ADAccountSid -adminaddress $xdhost
                            Add-BrokerMachine -MachineName $brokeredmach.SID -DesktopGroup $dgroup -adminaddress $xdhost
                            #Starts the machine
                            Start-Sleep 5
                            New-BrokerHostingPowerAction -Action TurnOn -MachineName $brokeredmach.MachineName -ActualPriority 0 -adminaddress $xdhost|Out-Null
                                #adds user to provsioned desktop
                                if(-not ([string]::IsNullOrWhiteSpace($user)))
                                {
                                Add-BrokerUser $user -Machine $brokeredmach.MachineName -adminaddress $xdhost -erroraction continue
                                }
                            $tempreturn += $brokeredmach
                            }
                        }
                    }
					return $tempreturn
            
                }
                else
                {
                Write-Verbose "No AD accounts found... Check permissions"
                }
            }
}
