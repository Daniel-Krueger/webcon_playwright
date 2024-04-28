$ErrorActionPreference = 'Inquire'

function Convert-ToElementName($string) {
    $name = $string -replace '\d.0.', ''
    $name = $name -replace '\.', ''
    $name = $name -replace 'Webcon', ''
    return 'Webcon' + $name
}

function New-WebconPowerShellClass {
    param (
        [Parameter(Mandatory)]
        [string]$StartingDefinition,

        [Parameter(Mandatory)]
        [PSCustomObject]$Definitions,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, boolean]]$ResolvedDefinitions
        ,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, string]]$ClassInherits
        ,
        [Parameter(Mandatory)]
        [System.Text.StringBuilder] $output 
    )
    begin {
        Write-host "Creating class/enum for $StartingDefinition"
        if ($ResolvedDefinitions.ContainsKey($StartingDefinition) ) {
            if ($ResolvedDefinitions[$StartingDefinition] -eq $true) {
                return
            }
            $ResolvedDefinitions[$StartingDefinition] = $true
        }
        $definition = $swagger.components.schemas.$StartingDefinition
    
    }
    process {
        if ($null -eq $definition) {
            throw "Schema does not contain a definition for '$StartingDefinition'"
        }
        $name = Convert-ToElementName $StartingDefinition
        if ($null -ne $definition."enum") {
            [void]$output.AppendLine("enum $name {");    
            $definition."enum" | ForEach-Object { [void]$output.AppendLine($_) };    
            [void]$output.AppendLine("}");    
            return
        }
    
    
        [void]$output.Append("class $name ");    
        if ($ClassInherits.ContainsKey($name)) {
            [void]$output.Append(" : $($ClassInherits[$name]) ");    
        }
        [void]$output.AppendLine(" {");    

        $anyOf = $definition.anyOf
        if ($null -ne $anyOf) { 
            foreach ($item in $anyOf) {                
                $anyName = Add-ReferencedDefinition $item.'$ref' $ResolvedDefinitions 
                $ClassInherits.Add($anyName, $name)
            }            
        }   
        $constructor = New-Object System.Text.StringBuilder
        [void]$constructor.AppendLine(@"
        $name () {
        }
"@       );     
        [void]$constructor.AppendLine(@"
        $name ([PSCustomObject] `$json) {
            `$this.Init(`$json) 
        }
"@       );      
        [void]$constructor.AppendLine(@"
        $name ([PSCustomObject] `$json, [scriptblock] `$action) {
            `$this.Init(`$json)            
            if (`$null -ne `$action ) { 
                Invoke-Command -ScriptBlock `$action -ArgumentList `$json, `$this
            }
        }
"@       ); 
        [void]$constructor.AppendLine("    hidden Init(`$json) {")
        foreach ($property in $definition.properties.PSObject.Properties) {
            <#
            $property = $definition.properties.PSObject.Properties.Item("type")
            #>
            #$propertyName = Convert-ToElementName $property.Name
            #$propertyName = Convert-ToElementName $property.Name
            $type = $property.Value.type
            $ref = $property.Value.'$ref'
        
            switch ($true) {
                ($null -ne $ref) { 
                    $typeName = '[' + (Add-ReferencedDefinition $ref $ResolvedDefinitions) + ']'
                }             
                ($type -eq 'integer') {
                    $typeName = '[int]'
                }
                ($type -eq 'string') {
                    $typeName = '[string]'
                }
                ($type -eq 'boolean') {
                    $typeName = '[bool]'
                }
                ($type -eq 'array') {                    
                    $typeName = '[System.Collections.Generic.List[' + (Add-ReferencedDefinition $property.Value.items.'$ref' $ResolvedDefinitions) + ']]' 
                }               
                Default {}
            }
            
            if ($type -eq 'array') {                    
                [void]$output.AppendLine("    $typeName`$$($property.Name) = $($typeName)::new()")
                [void]$constructor.AppendLine("`$json.$($property.Name) | ForEach-Object {`$this.$($property.Name).add([$((Add-ReferencedDefinition $property.Value.items.'$ref' $ResolvedDefinitions))]::new(`$_))}")
            } 
            else {
                [void]$output.AppendLine("    $typeName`$$($property.Name)")
                [void]$constructor.AppendLine("if (`$null -ne `$json.`"$($property.Name)`") { `$this.$($property.Name) = `$json.$($property.Name)}")
            }
            
        }
        
        [void]$constructor.AppendLine('    }')
        
        [void]$output.Append($constructor.ToString())
        [void]$output.AppendLine("}");
    }
    end {
        $ResolvedDefinitions[$StartingDefinition] = $true
        $unresolvedDefinition = $null
        foreach ($key in $ResolvedDefinitions.Keys) {
            if ($ResolvedDefinitions[$key] -eq $false) {
                $unresolvedDefinition = $key
                break  # Exit the loop after finding the first key
            }
        }
        if ($null -ne $unresolvedDefinition) {            
            New-WebconPowerShellClass -StartingDefinition $unresolvedDefinition -Definitions $Definitions -output $output -ResolvedDefinitions $ResolvedDefinitions  -ClassInherits $classInherits
        }        
    }
}

function Add-ReferencedDefinition {
    param (
        [Parameter(Mandatory)]
        [string]$referencedDefinition,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, boolean]]$ResolvedDefinitions
       
    )

    $refDefinitionName = $referencedDefinition -replace '#/components/schemas/', ''
    if ($ResolvedDefinitions.ContainsKey($refDefinitionName) -eq $false) {
        $ResolvedDefinitions.Add($refDefinitionName, $false);
    }
    return Convert-ToElementName $refDefinitionName
}