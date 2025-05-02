# Path to the text file containing file paths (one per line)
$fileListPath = "C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\graph_label_changes\file_list.txt"

# Read the list of file paths
$filePaths = Get-Content -Path $fileListPath

# Loop through each file path
foreach ($filePath in $filePaths) {
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($filePath)) {
        continue
    }
    
    # Check if file exists
    if (Test-Path $filePath) {
        # Create the new file path with "_labeled" appended
        $directory = [System.IO.Path]::GetDirectoryName($filePath)
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($filePath)
        $extension = [System.IO.Path]::GetExtension($filePath)
        $newFilePath = Join-Path -Path $directory -ChildPath "$filename`_labeled$extension"
        
        Write-Host "Processing: $filePath"
        Write-Host "Saving to: $newFilePath"
        
        # Read content, perform replacements, and write to new file
        (Get-Content -Path $filePath) | ForEach-Object {
            $_ -replace "mean_scaled_translated", "Mean Temp (°C)" `
            -replace "mean_scaled", "Mean Temp (°C)" `
            -replace "Mod_R_deltaTMyr_scaled", "ΔMean Temp (°C)/Ma" `
            -replace "Mod_scaled_translated", "ΔMean Temp (°C)/Ma" `
            -replace "Mod_scaled", "ΔMean Temp (°C)/Ma" `
            -replace "rotated_lat_scaled", "Paleolatitude" `
            -replace "wmmcmm_boxcox_scaled", "Seasonality (°C)" `
            -replace "wmmcmm_scaled_translated", "Seasonality (°C)" `
            -replace "map_scaled_translated", "Mean Annual Precipitation (mm)" `
            -replace "map_scaled", "Mean Annual Precipitation (mm)" `
            -replace "time", "Time (Ma)" `
            -replace "mat_scaled_translated", "Mean Annual Temp (℃)" `
            -replace "mat_scaled", "Mean Annual Temp (℃)" 
        } | Set-Content -Path $newFilePath
        
        Write-Host "Completed: $newFilePath"
    } else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

Write-Host "All files processed!" -ForegroundColor Green

# Create a list of the new test files for the runner script
$newFilePaths = $filePaths | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
    if (Test-Path $_) {
        $directory = [System.IO.Path]::GetDirectoryName($_)
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($_)
        $extension = [System.IO.Path]::GetExtension($_)
        Join-Path -Path $directory -ChildPath "$filename`_labeled$extension"
    }
}

# Save the list of new files
$newFilesListPath = "C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\graph_label_changes\new_file_list.txt"
$newFilePaths | Set-Content -Path $newFilesListPath

Write-Host "Created list of new files at: $newFilesListPath"