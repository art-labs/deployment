# deployment
Code for deploying lab vm's in Azure cloud

## Initial Setup

Install the Azure PowerShell Module.

```powershell
Install-Module -Name Az -AllowClobber
```

Clone the repository

```
git clone https://github.com/art-labs/deployment.git
```

Create a credential file called pcs.txt in the cloned directory, containing the password for the "art" user

```powershell
cd deployment
notepad pcs.txt
```

During deployment, an RDP connecion will be initiated to each VM so that the slow first login can occur. You can override the certificate check for ALL RDP connections using the following command. (not a great security practice btw but helpful for deployment)

```
reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client" /v "AuthenticationLevelOverride" /t "REG_DWORD" /d 0 /f
```

## Deploying the lab

Start Powershell and connect to your Azure Account

```powershell
Connect-AzAccount
```

Import the module (your path to the module may vary)

```powershell
Import-Module .\Deploy-Lab.ps1
```

Deploy the lab using the defaults (ResourceGroup=art-lab, NumVMs=1)

```powershell
Deploy-Lab
```

Deploy the lab, specifying your own resource group name (bsides-lab) and number of vm's (40)

```powershell
Deploy-Lab -resourceGroupName bsides-lab -numVMs 40
```

If you would like to just RDP to the existing VM's in a resource group without deploying any resources, you can use the `-noDeploy` option

```powershell
Deploy-Lab -noDeploy
```

Destroy the Resource Group and all of it's resources. This example destroys the default resource group (art-lab)

```powershell
Remove-AzResourceGroup art-lab
```

Verify resources are removed by logging into [https://portal.azure.com](https://portal.azure.com) and clicking `Resource Groups`. The only resource groups you should see there are "key-vault" and "NetworkWatcherRG"

## Miscellaneous

List Azure VM Usage

```powershell
Get-AzVMUsage
```

List Azure Network Usage (pay special attention to Standard Sku Public IP Addresses)

```powershell
Get-AzNetworkUsage
```

## Azure Account Setup

When you first create your Azure Subscription you will only be able to deploy 5 VMs max. To increase the limits, go to "Help & Support" and submit a quota increase request as follows.

```
Increase 'Total Regional vCPUs' limit -
1) Deployment Model: Resource Manager
2) Region: East US
3) New Limit: 200

Increase 'Standard BS Family vCPUs' limit -
1) Deployment Model: Resource Manager
2) Region: East US
3) New Limit: 200

Increase 'Public IP Addresses' to 100
1) Deployment Model: Resource Manager
2) Region: East US
3) New Limit: 100
```
