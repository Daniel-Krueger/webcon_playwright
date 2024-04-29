using module  .\MergedClasses.psm1

$ErrorActionPreference = 'Inquire'

function Assert-ImportExcelModule {
    if (Get-Module -ListAvailable -Name ImportExcel) {
        
    } 
    else {
        Write-Host "Import excel was not yet installed, going to install it"
        Install-Module -Name ImportExcel  -scope CurrentUser -Force
    }
    Import-Module -Name ImportExcel -Force
}

$excelConfig = @{
    "fieldNameRow"        = 1 
    "typeRow"             = 2
    "columNameRow"        = 3
    "idRow"               = 4
    "guidRow"             = 5
    "fieldStartingColumn" = 2
    "stepStartingRow"     = 6 
    "fieldInfoSheet"      = "FieldInformation" 
}

#region WEBCON API functions

# Set's the global configuration information. Secret information are read from a file outside of the repository.
function Set-WEBCONTargetInformation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$filePath = "..\.auth\webconConfig.json"
    )    
    process {
        Write-Host "Setting up WEBCON configuration"
        $global:WEBCONConfig = New-Object WEBCONConfig
        if (!(Test-Path $filePath) ) {
            $defaultConfig = New-Object WEBCONConfig
            ConvertTo-Json $defaultConfig
            New-Item $filePath  -Value (ConvertTo-Json $defaultConfig)
            $filePath = Resolve-Path $filePath 
            explorer.exe $filePath 
            $filePath | clip
            Write-Error "The configuration file does not exist. Please update the information in file '$filePath'. It should have opened, but the path is also copied to the clipboard"
        }
        $customConfig = Get-Content -LiteralPath $filePath  -Encoding UTF8 | ConvertFrom-Json 
        $global:WEBCONConfig.UpdateFromConfig($customConfig)    
    }
} 
<#
.SYNOPSIS
Retrieves a access token using the configuration from global::WEBCONConfig and stores it in the global variable $Global::accessToken 
#

#>
function Set-AccessToken {
    Set-WEBCONTargetInformation 
    $uri = "$($global:WEBCONConfig.Hostname)/api/oauth2/token"
    Write-Host "Getting token from $uri"
    $authorization = Invoke-RestMethod `
        -Method Post `
        -Uri  $uri `
        -ContentType "application/x-www-form-urlencoded" `
        -Headers @{"accept" = "application/json" } `
        -Body "grant_type=client_credentials&client_id=$($global:WEBCONConfig.ClientId)&client_secret=$([System.Web.HttpUtility]::UrlEncode($global:WEBCONConfig.ClientSecret))"
        
   
    $Global:accessToken = $authorization.access_token;
}

<#
.SYNOPSIS
    Return the step information for the given workflow and database including the type of the step.
.EXAMPLE
    Get-WorkflowStepInformation -dbId 14 -workflowId 78
#>
function Get-WorkflowStepInformation {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $dbId,
        [Parameter()]
        [int]
        $workflowId
    )
    begin {
        $stepInformation = [System.Collections.Generic.List[WebconStep]]::new()
    }
    process {
        $stepResult = Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/workflows/$($workflowId)/steps"           
        foreach ($step in $stepResult.steps) {
            <#
            $step = $stepResult.steps[0]
            #>
            $webconStep = New-Object WebconStep $step
            $addintionalStepInformation = Invoke-AuthenticatedGetRequest -hostRelativeUri $step.links[0].href
            $webconStep.Type = $addintionalStepInformation.type
            [void]$stepInformation.Add($webconStep)        
        }
    }
    end {
        return $stepInformation
    }
}

<#
.SYNOPSIS
    Return the associated form types of the workflow
.EXAMPLE
    Get-WorkflowStepInformation -dbId 14 -workflowId 78
#>
function Get-WorkflowFormTypes {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $dbId,
        [Parameter()]
        [int]
        $workflowId
    )
    begin {        
        
        $formTypes = [System.Collections.Generic.List[WebconAssociatedFormType]]::new()
        
    }
    process {
        $formTypeResult = Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/workflows/$($workflowId)/associatedFormTypes"           
        foreach ($formType in $formTypeResult.associatedFormTypes) {
            <#
            $formType = $formTypeResult.associatedFormTypes[0]
            #>            
            [void]$formTypes.Add((New-Object WebconAssociatedFormType $formType))
        }
    }
    end {
        return $formTypes
    }
}

<#
.SYNOPSIS
    Return the step information for the given workflow and database including the type of the step.
.EXAMPLE
    Get-WorkflowStepInformation -dbId 14 -workflowId 78
#>
function Get-WorkflowStepInformation {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $dbId,
        [Parameter()]
        [int]
        $workflowId
    )
    begin {
        $stepInformation = [System.Collections.Generic.List[WebconStep]]::new()
    }
    process {
        $stepResult = Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/workflows/$($workflowId)/steps"           
        foreach ($step in $stepResult.steps) {
            <#
            $step = $stepResult.steps[0]
            #>
            $webconStep = New-Object WebconStep $step
            $addintionalStepInformation = Invoke-AuthenticatedGetRequest -hostRelativeUri $step.links[0].href
            $webconStep.Type = $addintionalStepInformation.type
            [void]$stepInformation.Add($webconStep)        
        }
    }
    end {
        return $stepInformation
    }
}

<#
.SYNOPSIS
    Return the associated form types of the workflow
.EXAMPLE
    Get-WorkflowFormTypes -dbId 14 -workflowId 78
#>
function Get-WorkflowFormTypes {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $dbId,
        [Parameter()]
        [int]
        $workflowId
    )
    begin {        
        
        $formTypes = [System.Collections.Generic.List[WebconAssociatedFormType]]::new()
        
    }
    process {
        $formTypeResult = Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/workflows/$($workflowId)/associatedFormTypes"           
        foreach ($formType in $formTypeResult.associatedFormTypes) {
            <#
            $formType = $formTypeResult.associatedFormTypes[0]
            #>            
            [void]$formTypes.Add((New-Object WebconAssociatedFormType $formType))
        }
    }
    end {
        return $formTypes
    }
}

<#
.SYNOPSIS
    Return the associated form types of the workflow
.EXAMPLE
    using module .\MergedClasases.psm1
    Import-Module .\UtilityFunctions.psm1 -Force
    $dbId = 14
    $workflowId = 78  
    Set-AccessToken
       
    $formTypes = Get-WorkflowFormTypes  -dbId $dbId -workflowId $workflowId
    $steps = Get-WorkflowStepInformation -dbId $dbId -workflowId $workflowId
    $stepId = $steps[0].id
    $formTypeId = $formTypes[0].id
    Get-WorkflowFormTypes -dbId $dbId -stepId $stepId -formTypeId $formTypeId
#>

function Get-FormLayout {
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]
        $dbId,
        [Parameter()]
        [int]
        $stepId,
        [Parameter()]
        [int]
        $formTypeId
    )
    begin {        
        
        
    }
    process {
        $formLayoutResult = Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/formlayout?step=$stepId&formType=$formTypeId"           
        #return [WebconFormLayout]::new($formLayoutResult)
        return [WebconFormLayout]::new($formLayoutResult, $handleLayoutFields)                      
    }

}
<# Passed to the class instances to create the correct field based on the configuration  #>
$handleLayoutFields = { param($json, $instance)
    foreach ($jsonField in $json.fields) {
        <#
        $jsonField = $json.fields[0]
        #>
        if ($null -eq $jsonField.configuration ) {
            continue
        }
        $field = $instance.fields | Where-Object { $_.id -eq $jsonField.id }
        switch ($field.type) {
            ([WebconFieldTypes]::Autocomplete) { $field.configuration = [WebconAutocompleteConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::Decimal) { $field.configuration = [WebconDecimalConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::ChoicePicker) { $field.configuration = [WebconDropdownConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::Int) { $field.configuration = [WebconIntegerConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::Multiline) { $field.configuration = [WebconMultilineConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::ChoicePicker) { $field.configuration = [WebconPickerConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::RatingScale) { $field.configuration = [WebconRatingScaleConfig]::new($jsonField.configuration) }
            ([WebconFieldTypes]::SurveyChoose) { $field.configuration = [WebconSurveyChooseConfig]::new($jsonField.configuration) }
        }
    }

}
<#
.SYNOPSIS
    Processes the get request by adding the necessary headers like authentication
.EXAMPLE
    Invoke-AuthenticatedGetRequest -hostRelativeUri "/api/data/$($Global:WEBCONConfig.ApiVersion)/db/$($dbId)/workflows/$($workflowId)/steps"  
#>
function Invoke-AuthenticatedGetRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $hostRelativeUri
    )
    $uri = "$($global:WEBCONConfig.Hostname)$hostRelativeUri"
    Write-Host "Executing request against uri: $uri"    
    Return Invoke-RestMethod `
        -Method Get `
        -Uri  $uri `
        -ContentType "application/json" `
        -Headers @{"accept" = "application/json"; "Authorization" = "Bearer $($Global:accessToken) " } `

}



#endregion

#region Generated form data 
<#
.EXAMPLE
Import-Module .\utilityFunctions.psm1 -ErrorAction Stop

$dbId = 14
$workflowId = 78
$targetFolder = "..\e2e\automatedUi"
$inputDataFilePath = "..\e2e\input_20240428.xlsx"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
Export-FormData -workflowInformation $workflowInformation -targetFolderPath $targetFolder -inputDataFilePath $inputDataFilePath 
#>
function Export-FormData {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WorkflowInformation]
        $workflowInformation,
        [Parameter(Mandatory)]
        [string]
        $targetFolderPath,
        [Parameter()]
        [string]
        $inputDataFilePath
    )
    begin {
        
        $addExcelData = $false -eq [string]::IsNullOrWhiteSpace($inputDataFilePath)
        if ($addExcelData) {          
            $excelInformation = Get-ExcelInformation -inputDataFilePath $inputDataFilePath            
        }
        else {
            $excelInformation = $null
        }
    }
    process {
      
        
        foreach ($formStepLayout in $workflowInformation.FormStepLayout) {
            <# 
            $formStepLayout = $workflowInformation.FormStepLayout[0]
            #>
            $formTypeFolder = New-item -path "$targetFolderPath\$(Remove-ForbiddenCharacters $formStepLayout.FormType.name)\$(Remove-ForbiddenCharacters $formStepLayout.Step.name)" -ItemType Directory -Force
            $formData = New-FormData -formStepLayout $formStepLayout -excelInformation $excelInformation
            $dataFileLocation = "$($formTypeFolder.FullName)\formData.ts"
            Write-Host "Exporting form data to: $dataFileLocation"
            $formData.ToString() | Out-File -LiteralPath $dataFileLocation            
        }
    }
    end {
                
    }
}

function Get-ExcelInformation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputDataFilePath,        
        [Parameter()]
        [int]       
        $maxFields = 300,
        [Parameter()]
        [int]       
        $maxSteps = 100
    )
    begin {
        Assert-ImportExcelModule
        $excelFile = Open-ExcelPackage -Path $inputDataFilePath -KillExcel
        $fieldInformation = $excelFile.Workbook.Worksheets[$excelConfig.fieldInfoSheet]
       
      
       
    }
    process {
        $currentColumn = $excelConfig.fieldStartingColumn
        $fieldColumnMap = [System.Collections.Generic.Dictionary[int, int]]::new()
        do {
            $fieldId = $fieldInformation.Cells[$excelConfig.idRow, $currentColumn].value
            $break = $null -eq $fieldId
            if ($false -eq $break -and $currentColumn -gt $maxFields ) {
                throw "The current column number exceeds the maximum fields (columns), which are set to $maxFields"
            }
            if ($false -eq $break) {
                [void]$fieldColumnMap.add($fieldId, $currentColumn)
            }
            $currentColumn++
        } while ($break -eq $false)

        $currentStep = $excelConfig.stepStartingRow
        $stepRowMap = [System.Collections.Generic.Dictionary[string, int]]::new()
        do {
            $stepName = $fieldInformation.Cells[$currentStep, 1].value
            $break = $null -eq $stepName
            if ($false -eq $break -and $currentStep -gt $maxSteps ) {
                throw "The current row exceeds the maximum steps (rows), which are set to $maxSteps"
            }
            if ($false -eq $break) {
                [void]$stepRowMap.add($stepName, $currentStep)
            }
            $currentStep++
        } while ($break -eq $false)
    }
    end {
        return @{ "fieldColumnMap" = $fieldColumnMap; "stepRowMap" = $stepRowMap; "fieldInformation" = $fieldInformation }
    }
}
<#
.EXAMPLE

Import-Module .\UtilityFunctions.psm1 -Force
$dbId = 14
$workflowId = 78
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
$formStepLayout = $workflowInformation.FormStepLayout[0]
$formStepLayout.GetType() -eq [WorkflowFormStepLayout]
$formData =  New-FormData -formStepLayout $formStepLayout
#>

function New-FormData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WorkflowFormStepLayout]
        $formStepLayout,
        [Parameter()]        
        $excelInformation
    )
    begin {
        $typeScript = [System.Text.StringBuilder]::new()
        if ($null -ne $excelInformation) {
            $currentExcelRow = $excelInformation.stepRowMap[$formStepLayout.Step.name]
        }
           
    }
    process {
        [void]$typeScript.AppendLine("import * as FieldDefinitions from `"types/fields`"");
        [void]$typeScript.AppendLine("import { IFormData } from `"types/formData`"");
        [void]$typeScript.AppendLine();
        [void]$typeScript.AppendLine("export const data: IFormData = {");        
        $formStepLayout.Layout.paths | ForEach-Object {             
            [void]$typeScript.AppendLine("// pathId: $($_.id), // $($_.name) path visibility: $($_.visibility)") 
        }
        if ($formStepLayout.Step.type -in @([WebconStepTypes]::FinishPositive, [WebconStepTypes]::FinishNegative)) {
            [void]$typeScript.AppendLine(" pathId: 0,")
        }
       
        [void]$typeScript.AppendLine("currentStepId: $($formStepLayout.Step.id), // $($formStepLayout.Step.name)")
        [void]$typeScript.AppendLine("controls: [")
        $rootHiearchy = $formStepLayout.GetFieldHierarchy()
        foreach ($currentHierachy in $rootHiearchy) {
            <#
            $currentHierachy = $rootHiearchy[1]
            #>
            Add-TypeScriptFormData -currentHierachy ([FieldHierachy]$currentHierachy) -typeScript $typeScript -excelInformation $excelInformation -currentExcelRow $currentExcelRow
        }
        [void]$typeScript.AppendLine("]}")
    }
    end {
        return $typeScript.ToString();
    }
}

<#
.EXAMPLE

Import-Module .\UtilityFunctions.psm1 -Force
$dbId = 14
$workflowId = 78
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
$formStepLayout = $workflowInformation.FormStepLayout[0]
$rootHiearchy = $formStepLayout.GetFieldHierarchy()
$currentHierachy = $rootHiearchy[2]
$typeScript = [System.Text.StringBuilder]::new()
Add-TypeScriptFormData  -currentHierachy $currentHierachy -typeScript $typeScript
#>
function Add-TypeScriptFormData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [FieldHierachy]
        $currentHierachy,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript,
        [Parameter()]
        $excelInformation,
        [Parameter()]
        [int]
        $currentExcelRow
    )
    begin {
        $field = $currentHierachy.parentField
    }
    process {
        switch ($field.type) {
            { $_ -in [WebconFieldTypes]::TabPanel, [WebconFieldTypes]::Tab, [WebconFieldTypes]::AttributesGroup } {
                Add-TypeScriptContainerField -currentHierachy $currentHierachy -typeScript $typeScript -excelInformation $excelInformation -currentExcelRow $currentExcelRow
            }
            Default {
                Add-TypeScriptField -field $field -typeScript $typeScript  -excelInformation $excelInformation -currentExcelRow $currentExcelRow
            }
        }
    }
    end {
        
    }
}


<#
.EXAMPLE

Import-Module .\UtilityFunctions.psm1 -Force
$dbId = 14
$workflowId = 78
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
$formStepLayout = $workflowInformation.FormStepLayout[0]
$rootHiearchy = $formStepLayout.GetFieldHierarchy()
$currentHierachy = $rootHiearchy[2]
$typeScript = [System.Text.StringBuilder]::new()
Add-TypeScriptContainerField  -currentHierachy $currentHierachy -typeScript $typeScript
#>

function Add-TypeScriptContainerField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [FieldHierachy]
        $currentHierachy,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript,
        [Parameter()]
        $excelInformation,
        [Parameter()]
        [int]
        $currentExcelRow   
    )
    begin {
        $field = $currentHierachy.parentField
        $className = "FieldTypeNotHandled"
    }
    process {
        switch ($field.type) {
            { $_ -eq [WebconFieldTypes]::Tab } { $className = 'TabField'; break }
            { $_ -eq [WebconFieldTypes]::TabPanel } { $className = 'TabPanelField'; break }
            { $_ -eq [WebconFieldTypes]::AttributesGroup } { $className = 'GroupField'; break }
            else {
                Write-Host "Type '$_' of field $($field.name)($($field.dbColumn)) is not handled." -ForegroundColor DarkRed
            }
        }
        [void]$typeScript.AppendLine("new FieldDefinitions.$className(`"$($field.name)`", $($field.id), [")
        $currentHierachy.children | ForEach-Object { Add-TypeScriptFormData -currentHierachy $_ -typeScript $typeScript -excelInformation $excelInformation -currentExcelRow $currentExcelRow }
        [void]$typeScript.AppendLine("]),")   
    }
    end {
        
    }
}


<#
.EXAMPLE

Import-Module .\UtilityFunctions.psm1 -Force
$dbId = 14
$workflowId = 78
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)
$formStepLayout = $workflowInformation.FormStepLayout[0]
$rootHiearchy = $formStepLayout.GetFieldHierarchy()
$currentHierachy = $rootHiearchy[2]
$typeScript = [System.Text.StringBuilder]::new()
$field = $currentHierachy.children[0].parentField
Add-TypeScriptField -field $field -typeScript $typeScript
#>
function Add-TypeScriptField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WebconLayoutField]
        $field,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript,
        [Parameter()]
        $excelInformation
        ,
        [Parameter()]
        [int]
        $currentExcelRow
    )
    begin {
        $className = "FieldTypeNotHandled"
    }
    process {        
        if ($null -eq $excelInformation) {
            $value = "TBD_VALUE"
        } 
        else {
            $value = $excelInformation.fieldInformation.Cells[$currentExcelRow, $excelInformation.fieldColumnMap[$field.id]].value
            $value = ConvertTo-Json $value
        }
        switch ($field.type) {
            { $_ -eq [WebconFieldTypes]::SingleLine } { $className = 'TextField'; break }
            { $_ -eq [WebconFieldTypes]::Multiline } { $className = 'MultiLineTextField'; break }
            { $_ -eq [WebconFieldTypes]::Int } { $className = 'NumberField'; break }
            { $_ -eq [WebconFieldTypes]::Decimal } { $className = 'NumberField' ; break }
            { $_ -eq [WebconFieldTypes]::People } { $className = 'ChooseFieldPopupSearch' ; break }
            default {
                Write-Host "Type '$_' of field $($field.name)($($field.dbColumn)) is not handled." -ForegroundColor DarkRed
            }
        }
        [void]$typeScript.AppendLine("new FieldDefinitions.$className(`"$($field.name)`", `"$($field.dbColumn.replace('WFD_',''))`",$value,{")
        # Options
        [void]$typeScript.AppendLine("isRequired: $(($field.requiredness -eq [WebconRequired]::Mandatory).ToString().ToLower()),")
        [void]$typeScript.AppendLine("editability: FieldDefinitions.FieldEditability.$($field.editability),")
        [void]$typeScript.AppendLine("visibility: FieldDefinitions.FieldVisibility.$($field.visibility),")
        $action = "FieldDefinitions.FieldActionType.None"
        if ($field.visibility -ne [WebconVisible]::Hidden) {
            $action = $field.editability -eq [WebconEditable]::Editable ? 'FieldDefinitions.FieldActionType.SetAndCheck' : 'FieldDefinitions.FieldActionType.CheckOnly'
        }
        [void]$typeScript.AppendLine("action: $action,")
        [void]$typeScript.AppendLine("}),")
    }
    end {
        
    }
}
#endregion

#region Create excel input file

<#
.SYNOPSIS
Will create a new input file for the provided workflow information
#

.DESCRIPTION
This function will remove all workflow instances lised in the excel file. 
It's expected that this file has only one worksheet and that the first row contains the header information.

The API application  must have business administrator permissions for this.

The result will be written into the column right to the instanceIdColumn
.PARAMETER workflowInformation
The retrieved workflow information

.PARAMETER targetFile
The target file where the excel will be saved.

.PARAMETER overwrite
Default value is $false

.PARAMETER -showFile
Will display the file in Excel. Default value is $true

.EXAMPLE
$global:ErrorActionPreference = "stop"
Import-Module  -Name ".\UtilityFunctions.psm1" -Force

$dbId = 14
$workflowId = 78
$targetFile = "..\e2e\automatedUi\input.xlsx"
$workflowInformation = [WorkflowInformation]::new($dbId, $workflowId)

New-ExcelInputFile -workflowInformation $workflowInformation -targetFile $targetFile -overwrite $true -showFile $true

#>
function New-ExcelInputFile {
    [CmdletBinding()]
    param (        
        [Parameter(Mandatory)]
        [WorkflowInformation]
        $workflowInformation,
        [Parameter(Mandatory)]
        [string]
        $targetFile,
        [Parameter()]
        [bool]
        $overwrite = $false
        ,
        [Parameter()]
        [bool]
        $showFile = $true
    )    
    begin {
        
        Assert-ImportExcelModule
        if ((Test-Path -Path $targetFile)) {
            if ($overwrite -eq $false) {
                $key = Read-Host "The file already exists, it will be overwritten, if you continue. Press C and Enter to continue"
                if ($key -ne 'C') { exit }
            }
            Remove-Item $targetFile
        }
        
        $excel = Open-ExcelPackage -Path $targetFile -Create    
        $fieldInformationSheet = Add-WorkSheet -ExcelPackage $excel -WorksheetName $excelConfig.fieldInfoSheet
       
        $fieldsToSkip = @(           
            [WebconFieldTypes]::Unspecified,
            [WebconFieldTypes]::Comments,
            [WebconFieldTypes]::AttributesGroup,
            [WebconFieldTypes]::Tab,
            [WebconFieldTypes]::TabPanel)
        $stepsToSkip = @(
            [WebconStepTypes]::SystemWaitingForScan,
            [WebconStepTypes]::SystemWaitingForOtherWorkFlow,
            [WebconStepTypes]::FlowControl,
            [WebconStepTypes]::SystemWaitingForTextLayer,
            [WebconStepTypes]::SystemWaitingForOcrAi,
            [WebconStepTypes]::SystemWaitingForOcrAiLearn,
            [WebconStepTypes]::SystemStart

        )
        $fieldInformationSheet.DefaultColWidth = 15
        $fieldInformationSheet.Cells[$excelConfig.fieldNameRow, 1].Value = "Name"
        $fieldInformationSheet.Cells[$excelConfig.typeRow, 1].Value = "Type"
        $fieldInformationSheet.Cells[$excelConfig.columNameRow, 1].Value = "DB Column"
        $fieldInformationSheet.Cells[$excelConfig.idRow, 1].Value = "Id"
        $fieldInformationSheet.Cells[$excelConfig.guidRow, 1].Value = "GUID"            
    }
    process {
        $fieldColumn = $excelConfig.fieldStartingColumn
        foreach ($field in $workflowInformation.FormStepLayout[0].Layout.fields) {
            <#
            $field = $workflowInformation.FormStepLayout[0].Layout.fields[1]
            #>
            if ($field.type -in $fieldsToSkip) { continue }
            
            $fieldInformationSheet.Cells[$excelConfig.fieldNameRow, $fieldColumn].Value = $field.name
            $fieldInformationSheet.Cells[$excelConfig.typeRow, $fieldColumn].Value = $field.type
            $fieldInformationSheet.Cells[$excelConfig.columNameRow, $fieldColumn].Value = $field.dbColumn
            $fieldInformationSheet.Cells[$excelConfig.idRow, $fieldColumn].Value = $field.id
            $fieldInformationSheet.Cells[$excelConfig.guidRow, $fieldColumn].Value = $field.guid
            $fieldColumn ++;
        }
        
        $steprow = $excelConfig.stepStartingRow
        foreach ($step in $workflowInformation.Steps) {
            <#
            $step = $workflowInformation.Steps[0]
            #>
            if ($step.type -in $stepsToSkip) { continue }
            $fieldInformationSheet.Cells[$steprow, 1].Value = $step.name
            $steprow ++;
        }
    }
    end {
        
        $fieldInformationSheet.Row($excelConfig.columNameRow).Hidden = $true
        $fieldInformationSheet.Row($excelConfig.idRow).Hidden = $true
        $fieldInformationSheet.Row($excelConfig.guidRow).Hidden = $true
        $fieldinformationSheet.View.FreezePanes($excelConfig.stepStartingRow, 2)
        $excel.Save()
        
        if ($showFile) {
            . $targetFile
        }
        
    }
}

#endregion


function Remove-ForbiddenCharacters {
    param (
        [string]$inputString
    )

    $invalidFileNameChars = [System.IO.Path]::GetInvalidFileNameChars()
    $invalidPathChars = [System.IO.Path]::GetInvalidPathChars()
    $invalidChars = $invalidFileNameChars + $invalidPathChars

    # Replace each invalid character with an empty string
    foreach ($char in $invalidChars) {
        $inputString = $inputString -replace [Regex]::Escape($char), ''
    }

    return $inputString
}
