using module  .\MergedClasses.psm1


$currentDirectory = Get-Item -Path .
if ($currentDirectory.Name -ne "PowerShell") {
    Set-Location .\PowerShell
}
Import-Module .\utilityFunctions.psm1 -Force -ErrorAction Stop

$dbId = 14
$workflowId = 78
$targetFolder = "..\e2e\automatedUi"
$inputDataFilePath = "..\e2e\input_20240428.xlsx"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
Export-FormData -workflowInformation $workflowInformation -targetFolderPath $targetFolder -inputDataFilePath $inputDataFilePath 