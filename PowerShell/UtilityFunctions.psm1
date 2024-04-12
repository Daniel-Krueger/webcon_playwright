$ErrorActionPreference = 'Inquire'

# Configuration class
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


enum StepType {
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

# StepInformation class
class WebconStep {
    [string]$Id
    [string]$Name
    [string]$Guid
    [StepType]$Type
    [System.Collections.ArrayList]$Paths = @()
    
    WebconStep ([PSCustomObject] $json) {
        $this.Id = $json.id
        $this.Name = $json.name
        $this.Guid = $json.Guid
    }
}
# StepInformation class
class WebconPath {
    [string]$Id
    [string]$Name
    [string]$Guid  
    WebconPath ([PSCustomObject] $json) {
        $this.Id = $json.id
        $this.Name = $json.name
        $this.Guid = $json.Guid
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
Get's an access token using the configuration from global::WEBCONConfig.
#

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
        $stepInformation = New-Object System.Collections.ArrayList
        
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
            $pathInformation = Invoke-AuthenticatedGetRequest -hostRelativeUri ($step.links[0].href + '/paths')
            foreach ($path in $pathInformation.paths) {
                <#
                $path = $pathInformation.paths[0]
                #>            
                [void]$webconStep.Paths.Add((New-Object WebconPath $path))
            }
            [void]$stepInformation.Add($webconStep)        
        }
    }
    end {
        return $stepInformation
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



