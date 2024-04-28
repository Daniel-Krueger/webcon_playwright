$filesToMerge = @(
    ".\Classes\Api.psm1",
    ".\Classes\FormDataGeneration.psm1",
    ".\Classes\Utility.psm1"
)

$outputFile = ".\MergedClasses.psm1"

# Initialize an empty string to hold the merged content
$mergedContent = [System.Text.StringBuilder]::new()

# Iterate through each file and append its content to the merged content
foreach ($file in $filesToMerge) {
    <#
    $file = $filesToMerge[1]
    #>
    if (Test-Path $file -PathType Leaf) {
        $fileContent = Get-Content $file -Raw -Encoding utf8
        $fileContent = $fileContent -split "`r?`n" | ForEach-Object {
            if ($_ -match '^using module') {
                [void]$mergedContent.AppendLine("#$_")
            } else {
                [void]$mergedContent.AppendLine("$_")
            }
        }        
    } else {
        Write-Warning "File not found: $file"
    }
}

# Write the merged content to the output file
$mergedContent.ToString() | Out-File $outputFile -Encoding utf8