Connect-AzAccount

$AzureRegion = 'WestUS'
$ResGroupName = 'FuncMagicJlRd-wus-rg'
$StorAcctName = 'safuncmagicjlrd'
$StorSku = 'Standard_LRS'
$FuncName = 'FuncMagicJlRd-fnapp'
$FuncVersion = '4'
$FuncOSType = 'Windows'
$FuncRuntime = 'PowerShell'
$FuncRuntimeVer = '7.2'

## Obnoxious code to combat squigglies
$IgnoreMe = ($AzureRegion, $ResGroupName, $StorAcctName, $StorSku, $FuncVersion, $FuncOSType, $FuncRuntime, $FuncRuntimeVer)
$IgnoreMe | Out-Null

## Initial Deploy for Azure resources (onetime), uncomment to use/reuse/modify as necessary.
<#
New-AzResourceGroup -Name $ResGroupName -Location $AzureRegion

$StorParams = @{
    ResourceGroupName = $ResGroupName
    Name              = $StorAcctName
    SkuName           = $StorSku
    Location          = $AzureRegion
}
New-AzStorageAccount @StorParams

$FuncParams = @{
    ResourceGroupName = $ResGroupName
    Name              = $FuncName
    FunctionsVersion  = $FuncVersion
    StorageAccount    = $StorAcctName
    Location          = $AzureRegion
    Runtime           = $FuncRuntime
    RuntimeVersion    = $FuncRuntimeVer
    OSType            = $FuncOSType
}

New-AzFunctionApp @FuncParams
#>

## Deploy/Redeploy commands 

func azure functionapp publish $FuncName --powershell

## Recreate the local.settings.json file. Useful to execute/debug/test the Azure function locally.
##    The local.settings.json can contain secrets so is excluded from source control via .gitignore.
##    The file is uncessary within Azure as those settings are contained within the Function App Application Settings.

func azure functionapp fetch-app-settings $FuncName