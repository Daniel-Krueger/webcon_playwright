Import-Module .\UtilityFunctions.psm1 -Force
$dbId = 14
$workflowId = 78

Set-AccessToken
$stepInformation = Get-WorkflowStepInformation -dbId $dbId -workflowId $workflowId
$stepInformation[0].Paths[0]