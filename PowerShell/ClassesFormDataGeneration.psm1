using module  .\ClassesWebcon.psm1

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