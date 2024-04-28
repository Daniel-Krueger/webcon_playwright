using module  .\MergedClasses.psm1

$currentDirectory = Get-Item -Path .
if ($currentDirectory.Name -ne "PowerShell") {
    Set-Location .\PowerShell
}
Import-Module .\utilityFunctions.psm1 -force  -ErrorAction Stop

$dbId = 14
$workflowId = 78
$targetFile = "..\e2e\input.xlsx"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)

New-ExcelInputFile -workflowInformation $workflowInformation -targetFile $targetFile -overwrite $false -showFile $true
