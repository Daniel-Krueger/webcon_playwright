# using module  .\ClassesWebcon.psm1
# using module  .\ClassesFormDataGeneration.psm1

$ErrorActionPreference = 'Inquire'

#region WEBCON API functions
# Configuration class

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
    Return the associated form types of the workflow
.EXAMPLE
using module .\ClassesWebcon.psm1
Import-Module .\UtilityFunctions.psm1 -Force
    $dbId = 14
    $workflowId = 78  
    Set-AccessToken
       
    $formTypes = Get-WorkflowFormTypes  -dbId $dbId -workflowId $workflowId
    $steps = Get-WorkflowStepInformation -dbId $dbId -workflowId $workflowId
    $stepId = $steps[0].id
    $formTypeId = $formTypes[0].id
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
    Return the associated form types of the workflow
.EXAMPLE
using module .\ClassesWebcon.psm1
Import-Module .\UtilityFunctions.psm1 -Force
    $dbId = 14
    $workflowId = 78  
    Set-AccessToken
       
    $formTypes = Get-WorkflowFormTypes  -dbId $dbId -workflowId $workflowId
    $steps = Get-WorkflowStepInformation -dbId $dbId -workflowId $workflowId
    $stepId = $steps[0].id
    $formTypeId = $formTypes[0].id
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


function Export-FormData {
    
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WorkflowInformation]
        $workflowInformation,
        [Parameter(Mandatory)]
        [string]
        $targetFolderPath
    )
    begin {
        $targetFolder = new-item -Path $targetFolderPath -ItemType Directory -Force
    }
    process {
        foreach ($formStepLayout in $workflowInformation.FormStepLayout) {
            <# 
            $formStepLayout = $workflowInformation.FormStepLayout[0]
            #>
            $formTypeFolder = New-item -path "$targetFolderPath\$(Remove-ForbiddenCharacters $formStepLayout.FormType.name)\$(Remove-ForbiddenCharacters $formStepLayout.Step.name)" -ItemType Directory -Force
            $formData = New-FormData -formStepLayout $formStepLayout
            $dataFileLocation = "$($formTypeFolder.FullName)\formData.ts"
            Write-Host "Exporting form data to: $dataFileLocation"
            $formData.ToString() | Out-File -LiteralPath $dataFileLocation            
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
$formStepLayout.GetType() -eq [WorkflowFormStepLayout]
$formData =  New-FormData -formStepLayout $formStepLayout
#>

function New-FormData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WorkflowFormStepLayout]
        $formStepLayout
    )
    begin {
        $typeScript = [System.Text.StringBuilder]::new()
        
    }
    process {
        [void]$typeScript.AppendLine("import * as FieldDefinitions from `"types/fields`"");
        [void]$typeScript.AppendLine("import { IFormData } from `"types/formData`"");
        [void]$typeScript.AppendLine();
        [void]$typeScript.AppendLine("export const data: IFormData = {");
        $formStepLayout.Layout.paths | ForEach-Object { [void]$typeScript.AppendLine("// pathId: $($_.id), // $($_.name) path visibility: $($_.visibility)") }
       
        [void]$typeScript.AppendLine("currentStepId: $($formStepLayout.Step.id), // $($formStepLayout.Step.name)")
        [void]$typeScript.AppendLine("controls: [")
        $rootHiearchy = $formStepLayout.GetFieldHierarchy()
        foreach ($currentHierachy in $rootHiearchy) {
            <#
            $currentHierachy = $rootHiearchy[1]
            #>
            Add-TypeScriptFormData -currentHierachy ([FieldHierachy]$currentHierachy) -typeScript $typeScript
        }
        [void]$typeScript.AppendLine("]}")
    }
    end {
        return $typeScript.ToString();
    }
}


function Add-TypeScriptFormData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [FieldHierachy]
        $currentHierachy,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript
    )
    begin {
        $field = $currentHierachy.parentField
    }
    process {
        switch ($field.type) {
            { $_ -in [WebconFieldTypes]::TabPanel, [WebconFieldTypes]::Tab, [WebconFieldTypes]::AttributesGroup } {
                Add-TypeScriptContainerField -currentHierachy $currentHierachy -typeScript $typeScript
            }
            Default { Add-TypeScriptField -field $field -typeScript $typeScript }
        }
    }
    end {
        
    }
}

function Add-TypeScriptContainerField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [FieldHierachy]
        $currentHierachy,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript       
    )
    begin {
        $field = $currentHierachy.parentField     
        $className = "FieldTypeNotHandled"
    }
    process {
        switch ($field.type) {
            {$_ -eq [WebconFieldTypes]::Tab } { $className = 'TabField'; break }
            {$_ -eq [WebconFieldTypes]::TabPanel } { $className = 'TabPanelField'; break  }
            {$_ -eq [WebconFieldTypes]::AttributesGroup } { $className = 'GroupField'; break  }

        }
        [void]$typeScript.AppendLine("new FieldDefinitions.$className(`"$($field.name)`", $($field.id), [")
        $currentHierachy.children | ForEach-Object { Add-TypeScriptFormData -currentHierachy $_ -typeScript $typeScript }
        [void]$typeScript.AppendLine("]),")   
    }
    end {
        
    }
}

function Add-TypeScriptField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [WebconLayoutField]
        $field,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder]
        $typeScript
    )
    begin {
        $field = $currentHierachy.parentField
    }
    process {
        switch ($field.type) {
            {$_ -eq [WebconFieldTypes]::SingleLine } { $className = 'TextField'; break  }
            {$_ -eq [WebconFieldTypes]::Multiline } { $className = 'MultiLineTextField'; break  }
            {$_ -eq [WebconFieldTypes]::Int } { $className = 'NumberField'; break  }
            {$_ -eq [WebconFieldTypes]::Decimal } { $className = 'NumberField' ; break }
        }
        [void]$typeScript.AppendLine("new FieldDefinitions.$className(`"$($field.name)`", `"$($field.dbColumn.replace('WFD_',''))`",'TBD_VALUE',{")
        # Options
        [void]$typeScript.AppendLine("isRequired: $(($field.requiredness -eq [WebconRequired]::Optional).ToString().ToLower()),")
        [void]$typeScript.AppendLine("editability: FieldDefinitions.FieldEditability.$($field.editability),")
        [void]$typeScript.AppendLine("visibility: FieldDefinitions.FieldVisibility.$($field.visibility),")
        [void]$typeScript.AppendLine("action: $($field.editability -eq [WebconEditable]::Editable ? 'FieldDefinitions.FieldActionType.SetAndCheck' : 'FieldDefinitions.FieldActionType.CheckOnly'),")
        [void]$typeScript.AppendLine("}),")
    }
    end {
        
    }
}

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