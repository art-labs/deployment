# The pause function is from https://stackoverflow.com/questions/20886243/press-any-key-to-continue
Function pause ($message) {
    # Check if running Powershell ISE
    if ($psISE) {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
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

    $count = 0
    foreach ($ip in $ips.IpAddress) {
        Write-Host -ForegroundColor Magenta $ip
        Connect-RDP -ComputerName  $ip -Credential $cred
        if (($count % 5 -eq 0) -and ($count -ne 0)) {
            pause "press any key to continue"
        }

        $count = $count + 1

    }

    Write-Host -ForegroundColor Green "Destroy this resource group with the following command:"
    Write-Host -ForegroundColor Cyan "Remove-AzResourceGroup -ResourceGroupName $resourceGroupName"
}