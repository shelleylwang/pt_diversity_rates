# Path to the list of new files
$newFilesListPath = "C:\Users\SimoesLabAdmin\Documents\BDNN_Arielli\graph_label_changes\new_file_list.txt"

# Read the list of file paths
$newFilePaths = Get-Content -Path $newFilesListPath

# Path to Rscript.exe (update this to your R installation path if needed)
$rscriptPath = "C:\Program Files\R\R-4.2.1\bin\Rscript.exe"
# Note: Adjust the path above to match your R installation

# Loop through each file path and run it with R
foreach ($filePath in $newFilePaths) {
    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($filePath)) {
        continue
    }
    
    # Check if file exists
    if (Test-Path $filePath) {
        Write-Host "Running: $filePath" -ForegroundColor Cyan
        
        try {
            # Run the R script
            & $rscriptPath $filePath
            
            Write-Host "Successfully ran: $filePath" -ForegroundColor Green
        } catch {
            Write-Host "Error running: $filePath" -ForegroundColor Red
            Write-Host $_.Exception.Message
        }
    } else {
        Write-Host "File not found: $filePath" -ForegroundColor Red
    }
}

Write-Host "All scripts executed!" -ForegroundColor Green