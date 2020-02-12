function Deploy-Lab {

    Param(

        [Parameter(Mandatory = $false)]
        [string]
        $resourceGroupName = "art-lab",
        
        [Parameter(Mandatory = $true)]
        [Int]
        $numVms
    )

    if ($null -eq (get-azresourcegroup | Where-Object -Property "ResourceGroupName" -eq $resourceGroupName)) {
        New-AzResourceGroup -Name  $resourceGroupName -Location "East US"
    }

    $templateFile = "template.json"
    $parameterFile = "parameters.json"
    $startTime = Get-Date; Write-Host -ForegroundColor yellow "Start Time: $startTime"
    New-AzResourceGroupDeployment -Name "initialDeploy" -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -Count $numVms -templateParameterFile $parameterFile
    $endTime = Get-Date; Write-Host -ForegroundColor green "End Time: $endTime"
    $elapsed = ($endTime - $startTime).TotalMinutes
    Write-Host -ForegroundColor Cyan "Elapsed: $elapsed minutes"

    $ips = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object -Property "IpAddress"

    $batchSize = 5
    $delayBetweenBatches = 10
    $count = 1
    $cred = Get-Content "pcs.txt"
    foreach ($ip in $ips.IpAddress) {
        Write-Host -ForegroundColor Magenta $ip
        start-process -FilePath "powershell.exe" -ArgumentList "-exec bypass & {
            `$User = \`"art\`"
            `$Password = \`"$Cred\`"
            cmdkey.exe /generic:$ip /user:`$User /pass:`$Password
            mstsc.exe /v $ip /f
        }" -NoNewWindow
        if ($count % $batchSize -eq 0) {
            Start-Sleep -Seconds $delayBetweenBatches
            Stop-Process -Name "mstsc"
        }
        $count = $count + 1
    }

    Write-Host -ForegroundColor Green "Destroy this resource group with the following command:"
    Write-Host -ForegroundColor Cyan "Remove-AzResourceGroup -ResourceGroupName $resourceGroupName"
}