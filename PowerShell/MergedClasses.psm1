class WebconFormLayout  {
    [System.Collections.Generic.List[WebconLayoutField]]$fields = [System.Collections.Generic.List[WebconLayoutField]]::new()
    [System.Collections.Generic.List[WebconLayoutList]]$itemLists = [System.Collections.Generic.List[WebconLayoutList]]::new()
    [System.Collections.Generic.List[WebconLayoutPath]]$paths = [System.Collections.Generic.List[WebconLayoutPath]]::new()
        WebconFormLayout () {
        }
        WebconFormLayout ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconFormLayout ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
$json.fields | ForEach-Object {$this.fields.add([WebconLayoutField]::new($_))}
$json.itemLists | ForEach-Object {$this.itemLists.add([WebconLayoutList]::new($_))}
$json.paths | ForEach-Object {$this.paths.add([WebconLayoutPath]::new($_))}
    }
}
class WebconLayoutField  {
    [int]$id
    [string]$guid
    [string]$name
    [WebconFieldTypes]$type
    [WebconRequired]$requiredness
    [WebconVisible]$visibility
    [WebconPosition]$position
    [int]$parentId
    [WebconBaseConfiguration]$configuration
    [string]$dbColumn
    [WebconEditable]$editability
        WebconLayoutField () {
        }
        WebconLayoutField ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconLayoutField ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
if ($null -ne $json."type") { $this.type = $json.type}
if ($null -ne $json."requiredness") { $this.requiredness = $json.requiredness}
if ($null -ne $json."visibility") { $this.visibility = $json.visibility}
if ($null -ne $json."position") { $this.position = $json.position}
if ($null -ne $json."parentId") { $this.parentId = $json.parentId}
if ($null -ne $json."configuration") { $this.configuration = $json.configuration}
if ($null -ne $json."dbColumn") { $this.dbColumn = $json.dbColumn}
if ($null -ne $json."editability") { $this.editability = $json.editability}
    }
}
class WebconLayoutList  {
    [int]$id
    [string]$guid
    [string]$name
    [WebconFieldTypes]$type
    [WebconRequired]$requiredness
    [WebconVisible]$visibility
    [WebconPosition]$position
    [int]$parentId
    [System.Collections.Generic.List[WebconLayoutColumn]]$columns = [System.Collections.Generic.List[WebconLayoutColumn]]::new()
        WebconLayoutList () {
        }
        WebconLayoutList ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconLayoutList ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
if ($null -ne $json."type") { $this.type = $json.type}
if ($null -ne $json."requiredness") { $this.requiredness = $json.requiredness}
if ($null -ne $json."visibility") { $this.visibility = $json.visibility}
if ($null -ne $json."position") { $this.position = $json.position}
if ($null -ne $json."parentId") { $this.parentId = $json.parentId}
$json.columns | ForEach-Object {$this.columns.add([WebconLayoutColumn]::new($_))}
    }
}
class WebconLayoutPath  {
    [int]$id
    [string]$guid
    [string]$name
    [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]$links = [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]::new()
    [string]$description
    [WebconVisible]$visibility
        WebconLayoutPath () {
        }
        WebconLayoutPath ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconLayoutPath ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
$json.links | ForEach-Object {$this.links.add([WebconBPSCloudCorePublicApiLinksLink]::new($_))}
if ($null -ne $json."description") { $this.description = $json.description}
if ($null -ne $json."visibility") { $this.visibility = $json.visibility}
    }
}
enum WebconFieldTypes {
Unspecified
Comments
DateTime
Date
Decimal
Int
HyperLink
ImageLink
ChoiceTree
ChoiceList
Autocomplete
ChoicePicker
People
Picture
HandwrittenSignature
SingleLine
Multiline
Email
Boolean
ItemList
AttributesGroup
Tab
TabPanel
CooridnatesMap
AddressMap
RatingScale
SurveyChoose
Html
}
enum WebconRequired {
Mandatory
Optional
Conditional
}
enum WebconVisible {
Visible
Hidden
Conditional
}
class WebconPosition  {
    [int]$order
    [WebconPlaceholder]$placeholder
        WebconPosition () {
        }
        WebconPosition ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconPosition ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."order") { $this.order = $json.order}
if ($null -ne $json."placeholder") { $this.placeholder = $json.placeholder}
    }
}
class WebconBaseConfiguration  {
        WebconBaseConfiguration () {
        }
        WebconBaseConfiguration ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconBaseConfiguration ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
    }
}
enum WebconEditable {
Editable
ReadOnly
ReadOnlyJS
Conditional
}
class WebconLayoutColumn  {
    [int]$id
    [string]$guid
    [string]$name
    [WebconColumnTypes]$type
    [WebconRequired]$requiredness
    [WebconVisible]$visibility
        WebconLayoutColumn () {
        }
        WebconLayoutColumn ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconLayoutColumn ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
if ($null -ne $json."type") { $this.type = $json.type}
if ($null -ne $json."requiredness") { $this.requiredness = $json.requiredness}
if ($null -ne $json."visibility") { $this.visibility = $json.visibility}
    }
}
class WebconBPSCloudCorePublicApiLinksLink  {
    [string]$href
    [string]$method
    [string]$rel
        WebconBPSCloudCorePublicApiLinksLink () {
        }
        WebconBPSCloudCorePublicApiLinksLink ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconBPSCloudCorePublicApiLinksLink ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."href") { $this.href = $json.href}
if ($null -ne $json."method") { $this.method = $json.method}
if ($null -ne $json."rel") { $this.rel = $json.rel}
    }
}
enum WebconPlaceholder {
Other
TopPanel
LeftPanel
RightPanel
BottomPanel
}
class WebconAutocompleteConfig  : WebconBaseConfiguration  {
    [bool]$allowMultipleValues
    [bool]$allowTypedInValue
    [int]$numberOfResults
    [bool]$supportMultiLanguageNames
        WebconAutocompleteConfig () {
        }
        WebconAutocompleteConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconAutocompleteConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."allowMultipleValues") { $this.allowMultipleValues = $json.allowMultipleValues}
if ($null -ne $json."allowTypedInValue") { $this.allowTypedInValue = $json.allowTypedInValue}
if ($null -ne $json."numberOfResults") { $this.numberOfResults = $json.numberOfResults}
if ($null -ne $json."supportMultiLanguageNames") { $this.supportMultiLanguageNames = $json.supportMultiLanguageNames}
    }
}
class WebconDecimalConfig  : WebconBaseConfiguration  {
    [int]$decimalPlaces
    [string]$prefix
    [string]$suffix
    [WebconDecimalDisplayFormat]$amountDisplayFormatting
        WebconDecimalConfig () {
        }
        WebconDecimalConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconDecimalConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."decimalPlaces") { $this.decimalPlaces = $json.decimalPlaces}
if ($null -ne $json."prefix") { $this.prefix = $json.prefix}
if ($null -ne $json."suffix") { $this.suffix = $json.suffix}
if ($null -ne $json."amountDisplayFormatting") { $this.amountDisplayFormatting = $json.amountDisplayFormatting}
    }
}
class WebconDropdownConfig  : WebconBaseConfiguration  {
    [string]$emptyValueText
    [bool]$supportMultiLanguageNames
        WebconDropdownConfig () {
        }
        WebconDropdownConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconDropdownConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."emptyValueText") { $this.emptyValueText = $json.emptyValueText}
if ($null -ne $json."supportMultiLanguageNames") { $this.supportMultiLanguageNames = $json.supportMultiLanguageNames}
    }
}
class WebconIntegerConfig  : WebconBaseConfiguration  {
    [bool]$showGroupSeparator
        WebconIntegerConfig () {
        }
        WebconIntegerConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconIntegerConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."showGroupSeparator") { $this.showGroupSeparator = $json.showGroupSeparator}
    }
}
class WebconMultilineConfig  : WebconBaseConfiguration  {
    [int]$numberOfRows
        WebconMultilineConfig () {
        }
        WebconMultilineConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconMultilineConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."numberOfRows") { $this.numberOfRows = $json.numberOfRows}
    }
}
class WebconPickerConfig  : WebconBaseConfiguration  {
    [bool]$allowMultipleValues
    [bool]$allowTypedInValue
    [bool]$supportMultiLanguageNames
        WebconPickerConfig () {
        }
        WebconPickerConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconPickerConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."allowMultipleValues") { $this.allowMultipleValues = $json.allowMultipleValues}
if ($null -ne $json."allowTypedInValue") { $this.allowTypedInValue = $json.allowTypedInValue}
if ($null -ne $json."supportMultiLanguageNames") { $this.supportMultiLanguageNames = $json.supportMultiLanguageNames}
    }
}
class WebconRatingScaleConfig  : WebconBaseConfiguration  {
    [WebconRatingScale]$scaleValues
    [WebconRatingScaleDescriptions]$scaleDescriptions
    [string]$question
        WebconRatingScaleConfig () {
        }
        WebconRatingScaleConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconRatingScaleConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."scaleValues") { $this.scaleValues = $json.scaleValues}
if ($null -ne $json."scaleDescriptions") { $this.scaleDescriptions = $json.scaleDescriptions}
if ($null -ne $json."question") { $this.question = $json.question}
    }
}
class WebconSurveyChooseConfig  : WebconBaseConfiguration  {
    [bool]$allowMultipleValues
    [bool]$typedInValue
    [string]$typedInValueDescription
    [string]$question
    [System.Collections.Generic.List[WebconSurveyChooseAnswer]]$answers = [System.Collections.Generic.List[WebconSurveyChooseAnswer]]::new()
        WebconSurveyChooseConfig () {
        }
        WebconSurveyChooseConfig ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconSurveyChooseConfig ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."allowMultipleValues") { $this.allowMultipleValues = $json.allowMultipleValues}
if ($null -ne $json."typedInValue") { $this.typedInValue = $json.typedInValue}
if ($null -ne $json."typedInValueDescription") { $this.typedInValueDescription = $json.typedInValueDescription}
if ($null -ne $json."question") { $this.question = $json.question}
$json.answers | ForEach-Object {$this.answers.add([WebconSurveyChooseAnswer]::new($_))}
    }
}
enum WebconColumnTypes {
Unspecified
SingleLine
Multiline
Decimal
CalculatedDecimal
Boolean
Hyperlink
Email
DateTime
Date
ChoiceList
ChoicePicker
Autocomplete
ChoiceTree
CalculatedText
LocalAttachments
RelativeAttachments
SelectColumn
}
enum WebconDecimalDisplayFormat {
None
Auto
DecimalPoint
DecimalComma
}
class WebconRatingScale  {
    [int]$min
    [int]$max
        WebconRatingScale () {
        }
        WebconRatingScale ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconRatingScale ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."min") { $this.min = $json.min}
if ($null -ne $json."max") { $this.max = $json.max}
    }
}
class WebconRatingScaleDescriptions  {
    [string]$min
    [string]$max
        WebconRatingScaleDescriptions () {
        }
        WebconRatingScaleDescriptions ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconRatingScaleDescriptions ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."min") { $this.min = $json.min}
if ($null -ne $json."max") { $this.max = $json.max}
    }
}
class WebconSurveyChooseAnswer  {
    [string]$id
    [string]$name
        WebconSurveyChooseAnswer () {
        }
        WebconSurveyChooseAnswer ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconSurveyChooseAnswer ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."name") { $this.name = $json.name}
    }
}
class WebconStep  {
    [int]$id
    [string]$guid
    [string]$name
    [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]$links = [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]::new()
    [string]$description
    [WebconStepTypes]$type
        WebconStep () {
        }
        WebconStep ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconStep ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
$json.links | ForEach-Object {$this.links.add([WebconBPSCloudCorePublicApiLinksLink]::new($_))}
if ($null -ne $json."description") { $this.description = $json.description}
if ($null -ne $json."type") { $this.type = $json.type}
    }
}
enum WebconStepTypes {
Start
Intermediate
SystemWaitingForScan
SystemWaitingForOtherWorkFlow
FinishPositive
FinishNegative
FlowControl
System
SystemWaitingForTextLayer
SystemWaitingForOcrAi
SystemWaitingForOcrAiLearn
SystemStart
}
class WebconAssociatedFormTypesCollection  {
    [System.Collections.Generic.List[WebconAssociatedFormType]]$associatedFormTypes = [System.Collections.Generic.List[WebconAssociatedFormType]]::new()
        WebconAssociatedFormTypesCollection () {
        }
        WebconAssociatedFormTypesCollection ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconAssociatedFormTypesCollection ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
$json.associatedFormTypes | ForEach-Object {$this.associatedFormTypes.add([WebconAssociatedFormType]::new($_))}
    }
}
class WebconAssociatedFormType  {
    [int]$id
    [string]$guid
    [string]$name
    [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]$links = [System.Collections.Generic.List[WebconBPSCloudCorePublicApiLinksLink]]::new()
        WebconAssociatedFormType () {
        }
        WebconAssociatedFormType ([PSCustomObject] $json) {
            $this.Init($json) 
        }
        WebconAssociatedFormType ([PSCustomObject] $json, [scriptblock] $action) {
            $this.Init($json)            
            if ($null -ne $action ) { 
                Invoke-Command -ScriptBlock $action -ArgumentList $json, $this
            }
        }
    hidden Init($json) {
if ($null -ne $json."id") { $this.id = $json.id}
if ($null -ne $json."guid") { $this.guid = $json.guid}
if ($null -ne $json."name") { $this.name = $json.name}
$json.links | ForEach-Object {$this.links.add([WebconBPSCloudCorePublicApiLinksLink]::new($_))}
    }
}


#using module .\Classes\API.psm1
class WorkflowInformation {
    [System.Collections.Generic.List[WebconAssociatedFormType]]$FormTypes
    [System.Collections.Generic.List[WebconStep]]$Steps
    [System.Collections.Generic.List[WorkflowFormStepLayout]]$FormStepLayout = [System.Collections.Generic.List[WorkflowFormStepLayout]]::new();
    [int]$DBId
    [int]$WorkflowId

    WorkflowInformation ([int]$dbId, [int]$workflowId) {
        Set-AccessToken
        $this.DBId = $dbId
        $this.WorkflowId = $workflowId
        $this.FormTypes = Get-WorkflowFormTypes  -dbId $dbId -workflowId $workflowId
        $this.Steps = Get-WorkflowStepInformation -dbId $dbId -workflowId $workflowId        
        foreach ($formType in $this.FormTypes) {
            foreach ($step in $this.Steps) {
                $stepFormLayout = [WorkflowFormStepLayout]::new();
                $stepFormLayout.FormType = $formType
                $stepFormLayout.Step = $step
                $stepFormLayout.Layout = Get-FormLayout -dbId $this.DBId -stepId $step.id -formTypeId  $formType.id
                $this.FormStepLayout.Add($stepFormLayout);
            }
        }
    }
}

class WorkflowFormStepLayout {
    [WebconAssociatedFormType]$FormType
    [WebconStep]$Step
    [WebconFormLayout]$Layout

    [PSCustomObject] GetFieldHierarchy() {
        
        $idToFieldMapping = [System.Collections.Generic.Dictionary[int, [WebconLayoutField]]]::new()
        
        $this.Layout.fields | ForEach-Object { $idToFieldMapping[$_.id] = $_ }
        $rootFields = [System.Collections.Generic.List[WebconLayoutField]]::new()

        $parentChildMapping = [System.Collections.Generic.Dictionary[[WebconLayoutField], System.Collections.Generic.List[WebconLayoutField]]]::new()
    
        # Iterate through the fields to build the hierarchy
        foreach ($field in $this.Layout.fields) {
            if ($field.parentId -eq 0) {
                $rootFields.Add($field);
                if ($false -eq $parentChildMapping.ContainsKey($field)) {
                    $parentChildMapping.Add($field, [System.Collections.Generic.List[WebconLayoutField]]::new())
                }
                continue
            }

            $parent = $idToFieldMapping[$field.parentId]
            if ($false -eq $parentChildMapping.ContainsKey($parent)) {
                $parentChildMapping.Add($parent, [System.Collections.Generic.List[WebconLayoutField]]::new())
             
            }
            $parentChildMapping[$parent].Add($field)
        }
    
        function BuildTree([WebconLayoutField]$parent) {
            $fieldHierachy = [FieldHierachy]::new()
            $fieldHierachy.parentField = $parent
            foreach ($child in $parentChildMapping[$parent] ) {
                $fieldHierachy.children.Add((BuildTree $child))
            }
            return $fieldHierachy
        }
        $fieldHierachies = [System.Collections.Generic.List[FieldHierachy]]::new()

        $rootFields | ForEach-Object { $fieldHierachies.Add((BuildTree $_)) }        
        return $fieldHierachies 
    }
}

class  FieldHierachy {
    [WebconLayoutField]$parentField
    [System.Collections.Generic.List[FieldHierachy]]$children = [System.Collections.Generic.List[FieldHierachy]]::new()
}
class WEBCONConfig {
    [string]$ClientId
    [string]$ClientSecret
    [string]$Hostname
    [string]$ApiVersion   
    
    [void]UpdateFromConfig([WEBCONConfig] $config) {
        $this.ClientId = $config.ClientId
        $this.ClientSecret = $config.ClientSecret
        $this.Hostname = $config.Hostname
        $this.ApiVersion = $config.ApiVersion
    }
}


