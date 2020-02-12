function Deploy-Lab {

    Param(

        [Parameter(Mandatory = $false)]
        [string]
        $resourceGroupName = "art-lab",
        
        [Parameter(Mandatory = $false)]
        [Int]
        $numVMs=1,

        [Parameter(Mandatory = $false)]
        [switch]$noDeploy = $false,

        [Parameter(Mandatory = $false)]
        [switch]$noRDP = $false

    )

    # This creates the resources group if needed and then deploys the template to it to create the number of VM's specified in the '-numVMs'
    if (-not $noDeploy) {
        if ($null -eq (get-azresourcegroup | Where-Object -Property "ResourceGroupName" -eq $resourceGroupName)) {
            New-AzResourceGroup -Name  $resourceGroupName -Location "East US"
        }
        $templateFile = "template.json"
        $parameterFile = "parameters.json"
        $startTime = Get-Date; Write-Host -ForegroundColor yellow "Start Time: $startTime"
        New-AzResourceGroupDeployment -Name "initialDeploy" -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -Count $numVMs -templateParameterFile $parameterFile
        $endTime = Get-Date; Write-Host -ForegroundColor green "End Time: $endTime"
        $elapsed = ($endTime - $startTime).TotalMinutes
        Write-Host -ForegroundColor Cyan "Elapsed: $elapsed minutes"
    }
    
    # just print out all the IP addresses for the VM's in this resource group
    $ips = Get-AzPublicIpAddress -ResourceGroupName $resourceGroupName | Select-Object -Property "IpAddress"
    $ips | ForEach-Object { Write-Host -ForegroundColor Magenta $_.IpAddress }

    # Start a brief RDP session to each VM so first connection by the student is faster
    if (-not $noRDP) {
        $batchSize = 5
        $delayBetweenBatches = 20
        $count = 1
        $cred = Get-Content "pcs.txt"
        foreach ($ip in $ips.IpAddress) {
            start-process -FilePath "powershell.exe" -ArgumentList "-exec bypass & {
            `$User = \`"art\`"
            `$Password = \`"$Cred\`"
            cmdkey.exe /generic:$ip /user:`$User /pass:`$Password | Out-Null
            mstsc.exe /v $ip /f
        }" -NoNewWindow
            if ($count % $batchSize -eq 0) {
                Start-Sleep -Seconds $delayBetweenBatches
                Stop-Process -Name "mstsc"
            }
            $count = $count + 1
        }
    }
    
    Write-Host -ForegroundColor Green "Destroy this resource group with the following command:"
    Write-Host -ForegroundColor Cyan "Remove-AzResourceGroup -ResourceGroupName $resourceGroupName"
}