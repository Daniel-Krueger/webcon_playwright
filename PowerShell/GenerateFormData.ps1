using module  .\MergedClasses.psm1

#Import-module .\PowerShell\WebconClasses.psm1
#Import-module .\PowerShell\FormDataGenerationClasses.psm1
$currentDirectory = Get-Item -Path .
if ($currentDirectory.Name -ne "PowerShell") {
    Set-Location .\PowerShell
}
Import-Module .\utilityFunctions.psm1 -ErrorAction Stop

$dbId = 14
$workflowId = 78
$targetFolder = "..\e2e\automatedUi"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
Export-FormData -workflowInformation $workflowInformation -targetFolderPath $targetFolder