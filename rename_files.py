import os

def rename_files_in_folder(folder_path, source_string, target_string):
    try:
        # List all files in the given folder
        for filename in os.listdir(folder_path):
            # Check if the source_string is in the filename
            if source_string in filename:
                # Create the new filename by replacing the source_string with target_string
                new_filename = filename.replace(source_string, target_string)
                
                # Get the full paths for the old and new filenames
                old_file = os.path.join(folder_path, filename)
                new_file = os.path.join(folder_path, new_filename)
                
                # Rename the file
                os.rename(old_file, new_file)
                print(f'Renamed: {old_file} to {new_file}')
    
    except Exception as e:
        print(f"An error occurred: {e}")

# Specify the folder path and strings to replace
folder_path = r'C:\path\to\your\folder'  # Change this to your folder path
source_string = 'model_'  # The string you want to replace
target_string = 'test_'   # The string you want to replace with

# Call the function to rename files
rename_files_in_folder(folder_path, source_string, target_string)