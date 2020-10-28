 param (
     [Parameter(Mandatory=$true)]$dName, [Parameter(Mandatory=$true)]$smaPass
     )

# Set Winrm trust for remote powershell 
Set-Item wsman:\localhost\client\trustedhosts * -Force 

# Turn Off Windows Firewall 
netsh advfirewall set allprofiles state off 

$Secure2 = ConvertTo-SecureString $smaPass -AsPlainText -Force


try
{
	#Installing ADDS Features
	Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools

	Import-Module ADDSDeployment

	#Promite this PC to Domain Controller
	Install-ADDSForest `
	-DomainName $dName `
	-SafeModeAdministratorPassword $Secure2 `
	-NoRebootOnCompletion `
	-LogPath "C:\Logs.txt" -Force
	
}
catch
{ 
	Write-Host $_.Exception.Message
}

# Turn On Windows Firewall 
netsh advfirewall set allprofiles state On

#Restart the computer to complete the process
Restart-computer



