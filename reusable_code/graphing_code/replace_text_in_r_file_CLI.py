#!/usr/bin/env python3
"""
Script to replace specific text patterns in R files.
Usage: python replace_r_text.py input_file.R [output_file.R]
"""

import sys
import re
import argparse
from pathlib import Path

def replace_text_in_r_file(input_file, output_file=None):
    """
    Replace specified text patterns in an R file.
    
    Args:
        input_file (str): Path to input R file
        output_file (str): Path to output R file (optional, defaults to overwriting input)
    """
    
    # Read the input file
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
        return False
    except Exception as e:
        print(f"Error reading file '{input_file}': {e}")
        return False
    
    # Define replacement patterns (order matters for some replacements)
    replacements = [
        # Handle wmmcmm_z_trans before cmm_z_trans 
        ('wmmcmm_z_trans', 'AtmT Seasonality (°C)'),
        ('cmm_z_trans', 'Coldest Month AtmT (°C)'),
        
        # Other replacements
        ('speciation', 'Speciation'),
        ('extinction', 'Extinction'),
        ('net diversification', 'Net Diversification'),
        ('lat_range_z_trans', 'Latitudinal Range'),
        ('mat_z_trans', 'Mean Annual AtmT (°C)'),
        ('map_z_trans', 'Mean Annual Precipitation (mm/day)'),
        ('wmm_z_trans', 'Warmest Month AtmT (°C)'),
        ('wetmon_z_trans', 'Wettest Month (mm/day)'),
        ('drymon_z_trans', 'Dryest Month (mm/day)'),
        ('wetdry_z_trans', 'Precipitation Seasonality (mm/day)'),
        ('mean_z_trans', 'Mean Annual SST (°C)'),
        ('Mod_R_deltaTMyr_z_trans', 'Mean SST Shift (°C/myr)'),
        ('mean_pt_1myr_z_trans', 'Mean Annual SST (°C)'),
        ('Mod_R_deltaTMyr_pt_1myr_z_trans', 'Mean SST Shift (°C/myr)')
    ]
    
    # Perform text replacements
    original_content = content
    for old_text, new_text in replacements:
        content = content.replace(old_text, new_text)
    
   # Also handle other variations with flexible spacing and quote types
    biome_pattern = r"title\s*\(\s*main\s*=\s*['\"]biome['\"]\s*\)"
    if re.search(biome_pattern, content, re.IGNORECASE):
        content = re.sub(biome_pattern, r"# title(main='biome')", content, flags=re.IGNORECASE)
        print("\nFound and commented out title(main = 'biome') \n")
    
    stage_pattern = r"title\s*\(\s*main\s*=\s*['\"]Stage['\"]\s*\)"
    if re.search(stage_pattern, content, re.IGNORECASE):
        content = re.sub(stage_pattern, r"# title(main='Stage')", content, flags=re.IGNORECASE)
        print("Found and commented out title(main = 'Stage') \n")
    
    # Look for plot() functions with empty xlab and add 'Latitudinal Biome'
    # Strategy: Find empty xlab, then look ahead for commented title(main='biome')
    plot_pattern = r'(plot\s*\([^)]*xlab\s*=\s*)[\'\"]\s*[\'\"]([^)]*\))'
    matches = list(re.finditer(plot_pattern, content, re.IGNORECASE))
    
    replacements_made = 0
    for match in matches:
        # Look ahead from the match position for the biome title pattern
        search_start = match.end()
        
        # Find the next 100 lines from the match position
        remaining_content = content[search_start:]
        lines_ahead = remaining_content.split('\n', 100)[:100]
        context_ahead = '\n'.join(lines_ahead)
        
        # Check if there's a commented title(main='biome') ahead
        # Pattern allows for any number of # symbols
        biome_title_pattern = r'#+\s*title\s*\(\s*main\s*=\s*[\'"]biome[\'"]\s*\)'
        
        if re.search(biome_title_pattern, context_ahead, re.IGNORECASE):
            replacement = match.group(1) + "'Latitudinal Biome'" + match.group(2)
            content = content.replace(match.group(0), replacement, 1)  # Replace only first occurrence
            replacements_made += 1
            print(f"Added xlab = 'Latitudinal Biome' to plot function (found biome title ahead)")
    
    if replacements_made == 0:
        print("No empty xlab parameters found near biome title comments")

    # Determine output file
    if output_file is None:
        output_file = input_file
    
    # Write the modified content
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        # Report changes made
        if content != original_content:
            print(f"\nSuccessfully processed '{input_file}'")
            if output_file != input_file:
                print(f"\nOutput saved to '{output_file}'")
            else:
                print("\nFile updated in place \n")
            
            # Count replacements made
            changes_made = []
            for old_text, new_text in replacements:
                if old_text in original_content:
                    changes_made.append(f"'{old_text}' → '{new_text}'")
            
            if changes_made:
                print("Replacements made:")
                for change in changes_made:
                    print(f"  - {change}")
        else:
            print(f"\nNo changes needed in '{input_file}'")
        
        return True
        
    except Exception as e:
        print(f"\nError writing to file '{output_file}': {e}")
        return False

def main():
    parser = argparse.ArgumentParser(
        description='Replace specific text patterns in R files',
        epilog="""
Examples:
  python replace_r_text.py myfile.R
  python replace_r_text.py input.R output.R
        """
    )
    
    parser.add_argument('input_file', help='Input R file path')
    parser.add_argument('output_file', nargs='?', help='Output R file path (optional)')
    
    args = parser.parse_args()
    
    # Validate input file
    input_path = Path(args.input_file)
    if not input_path.exists():
        print(f"Error: Input file '{args.input_file}' does not exist.")
        sys.exit(1)
    
    if not input_path.suffix.lower() in ['.r', '.R']:
        print(f"Warning: '{args.input_file}' does not appear to be an R file.")
    
    # Process the file
    success = replace_text_in_r_file(args.input_file, args.output_file)
    
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()
