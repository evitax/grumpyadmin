#requires -version 2
<#
.SYNOPSIS
  Add/Update Hazzy's dynamic DNS IP into a Windows Firewall Rule for SMB Access
.DESCRIPTION
  This script resolves the IP of a DNS record for home.hazzy.co.uk and then uses that in the creation or updating if the rule already exists it updates the IP
.PARAMETER 
    
.INPUTS
  
.OUTPUTS
  
.NOTES
  Version:        1.0
  Author:         Grumpy Admin
  Creation Date:  08/12/2016
  Purpose/Change: Initial script development
  
.EXAMPLE
  add-hazzyipwf
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------



#----------------------------------------------------------[Declarations]----------------------------------------------------------



#-----------------------------------------------------------[Functions]------------------------------------------------------------

function resolve-hazzyip{
$ip= $(Resolve-DnsName -Name home.hazzy.co.uk).IP4Address
return $ip
}
function update-wf{
  Param(
  [parameter(Mandatory=$true)]
  [String] $ip
  )
  
  Begin{
   
  }
  
  Process{
     
         try {
                Get-NetFirewallRule -Name "Hazzy SMB Access inbound port 445" -ErrorAction stop | Set-NetFirewallRule -RemoteAddress $ip,"127.0.0.1"         
             }
         catch {         
                New-NetFirewallRule -Name "Hazzy SMB Access inbound port 445" -DisplayName "Hazzy SMB Access inbound port 445" -Action "Allow" -Profile "Domain,Public,Private" -Direction "InBound"  -RemoteAddress $ip -RemotePort "445" -LocalPort "445" -Protocol "TCP"
        }
  }
  
  End{  
  }
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

update-wf -ip $(resolve-hazzyip)

