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