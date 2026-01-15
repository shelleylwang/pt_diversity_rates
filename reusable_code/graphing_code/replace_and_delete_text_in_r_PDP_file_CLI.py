#!/usr/bin/env python3
"""
Script to replace specific text patterns in R files.
Usage: python replace_r_text.py input_file.R [output_file.R]
"""

import sys
import re
import argparse
from pathlib import Path

################################################################################
# FUNCTION TO DELETE UNNEEDED GRAPHS
################################################################################

def perform_deletion_operations(lines):
    """
    Perform sequential deletion operations on R file lines.
    
    Args:
        lines (list): List of lines from the R file
        
    Returns:
        list: Modified list of lines after deletions
    """
    
    print("\n" + "="*80)
    print("STARTING DELETION OPERATIONS")
    print("="*80 + "\n")
    
    # DELETION #1: Delete from line AFTER "suppressPackageStartupMessages" to first line starting with "par(las" (INCLUSIVE of par(las, EXCLUSIVE of suppress)
    print("DELETION #1: Removing lines after 'suppressPackageStartupMessages' to 'par(las' (inclusive of par(las, exclusive of suppress)")
    print("-" * 80)
    
    start_idx = None
    end_idx = None
    
    # Find start: line containing "suppressPackageStartupMessages"
    for i, line in enumerate(lines):
        if "suppressPackageStartupMessages" in line:
            start_idx = i + 1  # Start deletion AFTER the suppressPackageStartupMessages line
            print(f"  ✓ Found 'suppressPackageStartupMessages' line at index {i}: {line.strip()[:70]}...")
            print(f"  ✓ Deletion will start at index {start_idx} (line after 'suppressPackageStartupMessages')")
            break
    
    # Find end: first line starting with "par(las" after start
    if start_idx is not None:
        for i in range(start_idx, len(lines)):
            stripped = lines[i].strip()
            # Look for lines that start with "par(las"
            if stripped.startswith("par(las"):
                end_idx = i
                print(f"  ✓ Found 'par(las' line at index {i}: {lines[i].strip()[:60]}...")
                break
    
    if start_idx is not None and end_idx is not None:
        deleted_lines = lines[start_idx:end_idx+1]
        print(f"  ✓ Deleting {len(deleted_lines)} lines (indices {start_idx} to {end_idx})")
        lines = lines[:start_idx] + lines[end_idx+1:]
        print(f"  ✓ DELETION #1 COMPLETE\n")
    else:
        print(f"  ✗ Could not find boundaries for deletion #1")
        if start_idx is None:
            print(f"  ✗ Could not find 'suppressPackageStartupMessages' line\n")
        elif end_idx is None:
            print(f"  ✗ Could not find 'par(las' line after suppressPackageStartupMessages\n")
    
    # DELETION #2: Complex deletion around first 'legend' line and 'extinction'
    print("DELETION #2: Removing lines from ylim (before legend) to ylim (before extinction)")
    print("-" * 80)
    
    legend_line = "legend('topleft', bty = 'n', legend = leg, title = 'biome', pch = rep(22, 4), pt.bg = adjustcolor(col, alpha = 0.2), pt.cex = 2, lty = 1, seg.len = 1, col = col)"
    
    # Find first instance of legend line
    legend_idx = None
    for i, line in enumerate(lines):
        if legend_line in line:
            legend_idx = i
            print(f"  ✓ Found legend line at index {i}")
            break
    
    start_idx = None
    end_idx = None
    
    if legend_idx is not None:
        # Find closest preceding ylim line (start of deletion)
        for i in range(legend_idx - 1, -1, -1):
            if lines[i].strip().startswith("ylim"):
                start_idx = i
                print(f"  ✓ Found start ylim line at index {i}: {lines[i].strip()[:60]}...")
                break
        
        # Find first instance of 'extinction' string
        extinction_idx = None
        for i in range(legend_idx, len(lines)):
            if 'extinction' in lines[i].lower():
                extinction_idx = i
                print(f"  ✓ Found 'extinction' at index {i}: {lines[i].strip()[:60]}...")
                break
        
        # Find closest preceding ylim line before extinction (end boundary, NOT inclusive)
        if extinction_idx is not None:
            for i in range(extinction_idx - 1, -1, -1):
                if lines[i].strip().startswith("ylim"):
                    end_idx = i
                    print(f"  ✓ Found end ylim line at index {i}: {lines[i].strip()[:60]}...")
                    break
    
    if start_idx is not None and end_idx is not None and start_idx < end_idx:
        deleted_lines = lines[start_idx:end_idx]
        print(f"  ✓ Deleting {len(deleted_lines)} lines (indices {start_idx} to {end_idx-1})")
        lines = lines[:start_idx] + lines[end_idx:]
        print(f"  ✓ DELETION #2 COMPLETE\n")
    else:
        print(f"  ✗ Could not find boundaries for deletion #2\n")
    
    # DELETION #3: Same pattern as #2 but with 'net diversification' instead of 'extinction'
    print("DELETION #3: Removing lines from ylim (before legend) to ylim (before 'net diversification')")
    print("-" * 80)
    
    # Find first remaining instance of legend line
    legend_idx = None
    for i, line in enumerate(lines):
        if legend_line in line:
            legend_idx = i
            print(f"  ✓ Found legend line at index {i}")
            break
    
    start_idx = None
    end_idx = None
    
    if legend_idx is not None:
        # Find closest preceding ylim line (start of deletion)
        for i in range(legend_idx - 1, -1, -1):
            if lines[i].strip().startswith("ylim"):
                start_idx = i
                print(f"  ✓ Found start ylim line at index {i}: {lines[i].strip()[:60]}...")
                break
        
        # Find first instance of 'net diversification' string
        netdiv_idx = None
        for i in range(legend_idx, len(lines)):
            if 'net diversification' in lines[i].lower():
                netdiv_idx = i
                print(f"  ✓ Found 'net diversification' at index {i}: {lines[i].strip()[:60]}...")
                break
        
        # Find closest preceding ylim line before net diversification (end boundary, NOT inclusive)
        if netdiv_idx is not None:
            for i in range(netdiv_idx - 1, -1, -1):
                if lines[i].strip().startswith("ylim"):
                    end_idx = i
                    print(f"  ✓ Found end ylim line at index {i}: {lines[i].strip()[:60]}...")
                    break
    
    if start_idx is not None and end_idx is not None and start_idx < end_idx:
        deleted_lines = lines[start_idx:end_idx]
        print(f"  ✓ Deleting {len(deleted_lines)} lines (indices {start_idx} to {end_idx-1})")
        lines = lines[:start_idx] + lines[end_idx:]
        print(f"  ✓ DELETION #3 COMPLETE\n")
    else:
        print(f"  ✗ Could not find boundaries for deletion #3\n")
    
    # DELETION #4: From ylim (before legend) to end of file (excluding "n <- dev.off()")
    print("DELETION #4: Removing lines from ylim (before legend) to end (excluding 'n <- dev.off()')")
    print("-" * 80)
    
    # Find first remaining instance of legend line
    legend_idx = None
    for i, line in enumerate(lines):
        if legend_line in line:
            legend_idx = i
            print(f"  ✓ Found legend line at index {i}")
            break
    
    start_idx = None
    end_idx = None
    
    if legend_idx is not None:
        # Find closest preceding ylim line (start of deletion)
        for i in range(legend_idx - 1, -1, -1):
            if lines[i].strip().startswith("ylim"):
                start_idx = i
                print(f"  ✓ Found start ylim line at index {i}: {lines[i].strip()[:60]}...")
                break
        
        # Find "n <- dev.off()" line (should be last line)
        for i in range(len(lines) - 1, -1, -1):
            if "n <- dev.off()" in lines[i]:
                end_idx = i
                print(f"  ✓ Found 'n <- dev.off()' at index {i}: {lines[i].strip()[:60]}...")
                break
    
    if start_idx is not None and end_idx is not None and start_idx < end_idx:
        deleted_lines = lines[start_idx:end_idx]
        print(f"  ✓ Deleting {len(deleted_lines)} lines (indices {start_idx} to {end_idx-1})")
        lines = lines[:start_idx] + lines[end_idx:]
        print(f"  ✓ DELETION #4 COMPLETE\n")
    else:
        print(f"  ✗ Could not find boundaries for deletion #4\n")
    
    print("="*80)
    print("ALL DELETION OPERATIONS COMPLETE")
    print("="*80 + "\n")
    
    return lines


################################################################################
# FUNCTIONS FOR TEXT REPLACEMENTS AND LABEL TRANSFORMATIONS
################################################################################
def define_text_replacements():
    """
    Return a list of tuples for text replacements.
    Each tuple contains (old_text, new_text).
    """
    return [
        # Handle wmmcmm_z_trans before cmm_z_trans 
        ('wmmcmm_z_trans', 'AtmT Seasonality (°C)'),
        ('cmm_z_trans', 'Coldest Month AtmT (°C)'),
        
        # Other replacements
        ('speciation', 'Speciation'),
        ('extinction', 'Extinction'),
        ('net diversification', 'Net Diversification'),
        ("'Latitudinal Range'", "'Latitudinal Range (Log Transform)'"),
        ('lat_range_z_trans', 'Latitudinal Range (Log Transform)'),
        ('mat_z_trans', 'Mean Annual AtmT (°C)'),
        ('map_z_trans', 'Mean Annual Precipitation (mm/day)'),
        ('wmm_z_trans', 'Warmest Month AtmT (°C)'),
        ('wetmon_z_trans', 'Wettest Month (mm/day)'),
        ('drymon_z_trans', 'Dryest Month (mm/day)'),
        ('wetdry_z_trans', 'Precipitation Seasonality (mm/day)'),
        ('mean_z_trans', 'Mean Annual SST (°C)'),
        ('Mod_R_deltaTMyr_z_trans', 'Mean SST Shift (°C/myr)'),
        ('mean_pt_1myr_z_trans', 'Mean Annual SST (°C)'),
        ('Mod_R_deltaTMyr_pt_1myr_z_trans', 'Mean SST Shift (°C/myr)'),
        ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Speciation')",
            "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Speciation', log = 'x', xaxt = 'n') \n# Define the tick positions (to keep them from defaulting to scientific notation) \nx_ticks <- c(0.001, 0.01, 0.1, 1, 10, 100) \n# Add custom x-axis with decimal format labels \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))"),
        ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Extinction')",
            "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Extinction', log = 'x', xaxt = 'n') \n# Add custom x-axis with decimal format labels. x_ticks defined previously \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))"),
        ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Net Diversification')",
            "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Net Diversification', log = 'x', xaxt = 'n') \n# Add custom x-axis with decimal format labels. x_ticks defined previously \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))")
    ]

def perform_text_replacements(content, verbose=True):
    replacements = define_text_replacements()
    for old_text, new_text in replacements:
        content = content.replace(old_text, new_text)
    return content

def comment_out_titles(content, verbose=True):
    """
    Comment out any title(main = ...) patterns.
    """
    title_pattern = r"title\s*\(\s*main\s*=\s*[^)]+\)"
    matches = re.findall(title_pattern, content, re.IGNORECASE)
    if matches:
        content = re.sub(title_pattern, lambda m: f"# {m.group(0)}", content, flags=re.IGNORECASE)
        if verbose:
            print(f"\nFound and commented out {len(matches)} title(main = ...) statement(s)\n")
    return content

def add_biome_xlabels(content, verbose=True):
    """
    Find plot() functions with empty xlab near biome titles and add 'Latitudinal Biome'.
    """
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
    
    if verbose:
        if replacements_made == 0:
            print("No empty xlab plot parameters found near 'biome' titles")
        else:
            print(f"Added {replacements_made} Latitudinal Biome xlabel(s)")
    
    return content

################################################################################
# FUNCTION TO KEEP ONLY ONE Y AXIS LABEL PER ROW, REMOVE ALL OTHERS
################################################################################

def remove_duplicate_ylab_strings(content):
    """
    Remove all instances EXCEPT the first of specific ylab strings.
    """
    ylab_strings = [
        ", ylab = 'Speciation'",
        ", ylab = 'Extinction'",
        ", ylab = 'Net Diversification'"
    ]
    
    for ylab_str in ylab_strings:
        count = content.count(ylab_str)
        if count > 1:
            # Find the end of the first occurrence
            first_pos = content.find(ylab_str)
            first_end = first_pos + len(ylab_str)
            
            # Keep everything up to and including the first occurrence
            before_and_first = content[:first_end]
            
            # Replace all occurrences in the remainder only
            after_first = content[first_end:].replace(ylab_str, ", ylab = ''")
            
            content = before_and_first + after_first
            print(f"Removed {count - 1} duplicate instance(s) of '{ylab_str}'")
    
    return content


################################################################################
# FUNCTION TO MAKE ANY NEGATIVE OBS_X VALUES IN LAT RANGE GRAPHS INTO 0.01
################################################################################
# since lat range graphs are now log scale, we need to ensure no negative or zero obs_x values
# this needs to happen AFTER the text replacements, since those change the plot() lines we are searching for

def insert_after_obs_x(content, verbose=True):
    """
    For specific plot() lines:
    - Insert negative xlim and tr fixes BEFORE the plot line
    - Insert negative obs_x fix AFTER the obs_x line
    """
    
    # Lines to insert BEFORE the plot() call
    lines_before_plot = [
        "xlim[xlim > -1 & xlim < 0] <- 0.01",
        "tr[tr > -1 & tr < 0] <- 0.01"
    ]
    
    # Line to insert AFTER obs_x
    line_after_obs_x = "obs_x[obs_x > -1 & obs_x < 0] <- 0.01"
    
    # The trigger lines (transformed versions after text replacements)
    trigger_lines = [
        "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Speciation', log = 'x', xaxt = 'n')",
        "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Extinction', log = 'x', xaxt = 'n')",
        "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Net Diversification', log = 'x', xaxt = 'n')"
    ]
    
    lines = content.split('\n')
    insertions_made = 0
    
    for trigger in trigger_lines:
        # Find the trigger line
        trigger_idx = None
        for i, line in enumerate(lines):
            if trigger in line:
                trigger_idx = i
                break
        
        if trigger_idx is None:
            if verbose:
                print(f"  ✗ Could not find trigger line: {trigger[:60]}...")
            continue
        
        # INSERT BEFORE PLOT: xlim and tr fixes
        for j, new_line in enumerate(lines_before_plot):
            lines.insert(trigger_idx + j, new_line)
        
        # Adjust trigger_idx since we just inserted lines above it
        trigger_idx += len(lines_before_plot)
        
        # Find the next line starting with "obs_x" after the trigger
        obs_x_idx = None
        for i in range(trigger_idx + 1, len(lines)):
            if lines[i].strip().startswith("obs_x"):
                obs_x_idx = i
                break
        
        if obs_x_idx is None:
            if verbose:
                print(f"  ✗ Could not find 'obs_x' line after trigger at index {trigger_idx}")
            continue
        
        # INSERT AFTER OBS_X: obs_x fix
        lines.insert(obs_x_idx + 1, line_after_obs_x)
        
        insertions_made += 1
        
        if verbose:
            print(f"  ✓ Inserted negative xlim, tr, and obs_x fixes around latitudinal range (log transform) plot at index {trigger_idx}")
    
    if verbose:
        print(f"Total latitudinal range (log transform) plot sections modified: {insertions_made}")
    
    return '\n'.join(lines)


################################################################################
# FINAL FUNCTION CALLING GRAPH DELETIONS, YAXIS DELETIONS, TEXT REPLACEMENTS
################################################################################

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
    
    ################################################################################
    # PERFORM GRAPH DELETION OPERATIONS BEFORE TEXT REPLACEMENTS
    ################################################################################
    
    # Convert content to lines for deletion operations
    lines = content.split('\n')
    original_line_count = len(lines)
    
    # Perform all deletion operations
    lines = perform_deletion_operations(lines)
    
    # Convert back to content string
    content = '\n'.join(lines)
    
    print(f"Line count: {original_line_count} → {len(lines)} (removed {original_line_count - len(lines)} lines)\n")
    
    ################################################################################
    # PERFORM TEXT REPLACEMENTS
    ################################################################################
    
    original_content = content # Used later for checking if there were any text replacements
    
    content = perform_text_replacements(content)
    content = comment_out_titles(content)
    content = add_biome_xlabels(content)
    content = insert_after_obs_x(content)
    
    # # Define replacement patterns (order matters for some replacements)
    # replacements = [
    #     # Handle wmmcmm_z_trans before cmm_z_trans 
    #     ('wmmcmm_z_trans', 'AtmT Seasonality (°C)'),
    #     ('cmm_z_trans', 'Coldest Month AtmT (°C)'),
        
    #     # Other replacements
    #     ('speciation', 'Speciation'),
    #     ('extinction', 'Extinction'),
    #     ('net diversification', 'Net Diversification'),
    #     ("'Latitudinal Range'", "'Latitudinal Range (Log Transform)'"),
    #     ('lat_range_z_trans', 'Latitudinal Range (Log Transform)'),
    #     ('mat_z_trans', 'Mean Annual AtmT (°C)'),
    #     ('map_z_trans', 'Mean Annual Precipitation (mm/day)'),
    #     ('wmm_z_trans', 'Warmest Month AtmT (°C)'),
    #     ('wetmon_z_trans', 'Wettest Month (mm/day)'),
    #     ('drymon_z_trans', 'Dryest Month (mm/day)'),
    #     ('wetdry_z_trans', 'Precipitation Seasonality (mm/day)'),
    #     ('mean_z_trans', 'Mean Annual SST (°C)'),
    #     ('Mod_R_deltaTMyr_z_trans', 'Mean SST Shift (°C/myr)'),
    #     ('mean_pt_1myr_z_trans', 'Mean Annual SST (°C)'),
    #     ('Mod_R_deltaTMyr_pt_1myr_z_trans', 'Mean SST Shift (°C/myr)'),
    #     ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Speciation')",
    #         "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Speciation', log = 'x', xaxt = 'n') \n# Define the tick positions (to keep them from defaulting to scientific notation) \nx_ticks <- c(0.001, 0.01, 0.1, 1, 10, 100) \n# Add custom x-axis with decimal format labels \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))"),
    #     ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Extinction')",
    #         "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Extinction', log = 'x', xaxt = 'n') \n# Add custom x-axis with decimal format labels. x_ticks defined previously \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))"),
    #     ("plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Net Diversification')",
    #         "plot(0, 0, type = 'n', xlim = xlim, ylim = ylim, xlab = 'Latitudinal Range (Log Transform)', ylab = 'Net Diversification', log = 'x', xaxt = 'n') \n# Add custom x-axis with decimal format labels. x_ticks defined previously \naxis(1, at = x_ticks, labels = format(x_ticks, scientific = FALSE, drop0trailing = TRUE))")
    # ]
    
    # # Perform text replacements
    # original_content = content
    # for old_text, new_text in replacements:
    #     content = content.replace(old_text, new_text)
    
    # # Comment out any title(main = ...) patterns
    # title_pattern = r"title\s*\(\s*main\s*=\s*[^)]+\)"
    # matches = re.findall(title_pattern, content, re.IGNORECASE)
    # if matches:
    #     content = re.sub(title_pattern, lambda m: f"# {m.group(0)}", content, flags=re.IGNORECASE)
    #     print(f"\nFound and commented out {len(matches)} title(main = ...) statement(s)\n")
    
    # # Look for plot() functions with empty xlab and add 'Latitudinal Biome'
    # # Strategy: Find empty xlab, then look ahead for commented title(main='biome')
    # plot_pattern = r'(plot\s*\([^)]*xlab\s*=\s*)[\'\"]\s*[\'\"]([^)]*\))'
    # matches = list(re.finditer(plot_pattern, content, re.IGNORECASE))
    
    # replacements_made = 0
    # for match in matches:
    #     # Look ahead from the match position for the biome title pattern
    #     search_start = match.end()
        
    #     # Find the next 100 lines from the match position
    #     remaining_content = content[search_start:]
    #     lines_ahead = remaining_content.split('\n', 100)[:100]
    #     context_ahead = '\n'.join(lines_ahead)
        
    #     # Check if there's a commented title(main='biome') ahead
    #     # Pattern allows for any number of # symbols
    #     biome_title_pattern = r'#+\s*title\s*\(\s*main\s*=\s*[\'"]biome[\'"]\s*\)'
        
    #     if re.search(biome_title_pattern, context_ahead, re.IGNORECASE):
    #         replacement = match.group(1) + "'Latitudinal Biome'" + match.group(2)
    #         content = content.replace(match.group(0), replacement, 1)  # Replace only first occurrence
    #         replacements_made += 1
    #         print(f"Added xlab = 'Latitudinal Biome' to plot function (found biome title ahead)")
    
    # if replacements_made == 0:
    #     print("No empty xlab parameters found near biome title comments")

    ################################################################################
    # PERFORM YAXIS LABEL DELETIONS
    ################################################################################
    # Remove duplicate ylab strings (keep only first instance of each)
    content = remove_duplicate_ylab_strings(content)

    ################################################################################
    # OUTPUT
    ################################################################################
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
            for old_text, new_text in define_text_replacements():
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


################################################################################
# COMMAND LINE INTERFACE
################################################################################

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
    
    if input_path.suffix.lower() != '.r':
        print(f"Warning: '{args.input_file}' does not appear to be an R file.")
    
    # Process the file
    success = replace_text_in_r_file(args.input_file, args.output_file)
    
    if not success:
        sys.exit(1)

if __name__ == "__main__":
    main()
