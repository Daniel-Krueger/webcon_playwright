using module  .\ClassesWebcon.psm1
using module  .\ClassesFormDataGeneration.psm1

#Import-module .\PowerShell\WebconClasses.psm1
#Import-module .\PowerShell\FormDataGenerationClasses.psm1
$currentDirectory = Get-Item -Path .
if ($currentDirectory.Name -ne "PowerShell") {
    Set-Location .\PowerShell
}
Import-Module .\UtilityFunctions.psm1 -Force
# 
$dbId = 14
$workflowId = 78
$targetFolder = "..\e2e\automatedUi"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
Export-FormData -workflowInformation $workflowInformation -targetFolderPath $targetFolder