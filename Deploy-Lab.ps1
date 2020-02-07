function Deploy-Lab {

    Param(

        [Parameter(Mandatory = $false)]
        [string]
        $resourceGroupName = "art-lab",
        
        [Parameter(Mandatory = $false)]
        [string]
        $templateFile = "template.json",

        [Parameter(Mandatory = $true)]
        [Int]
        $numVms,

        [Parameter(Mandatory = $false)]
        [string]
        $adminPassword = ""

    )

    if ($null -eq (get-azresourcegroup | Where-Object -Property "ResourceGroupName" -eq $resourceGroupName)) {
        New-AzResourceGroup -Name  $resourceGroupName -Location "East US"
    }

    $startTime = Get-Date; Write-Host -ForegroundColor yellow "Start Time: $startTime"
    New-AzResourceGroupDeployment -Name "initialDeploy" -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -Count $numVms -admin_Password $adminPassword
    $endTime = Get-Date; Write-Host -ForegroundColor green "End Time: $endTime"
    $elapsed = ($endTime - $startTime).TotalMinutes
    Write-Host -ForegroundColor Cyan "Elapsed: $elapsed minutes"

    Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object -Property "IpAddress"

    Write-Host -ForegroundColor Green "Destroy this resource group with the following command:"
    Write-Host -ForegroundColor Cyan "Remove-AzResourceGroup -ResourceGroupName $resourceGroupName"
}