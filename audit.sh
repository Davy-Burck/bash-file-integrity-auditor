#!/bin/bash

# Output log file
LOGFILE="file_audit.log"

# Function to check if a file is world-writable
check_world_writable() {
    # Check if file is writable and if the "others" permission includes write (7 means rwx)
    if [ -w "$1" ] && [ "$(stat -c "%a" "$1" | cut -c 3)" -eq 7 ]; then
        echo "WARNING: World-writable file found - $1"
        ((world_writable_count++))
    fi
}

# Function to process files modified in the last 7 days
process_files() {
    # Find all files modified in the last 7 days, suppress permission errors
    for file in $(find "$1" -type f -mtime -7 2>/dev/null); do
        # Get file owner and modification date
        owner=$(stat -c "\%U" "$file")
        mod_date=$(stat -c "\%y" "$file")
        
        # Log the information
        echo "$file \vert{} Owner:$owner | Modified: $mod_date" >> "$LOGFILE"
        ((total_files++))
        check_world_writable "$file"
    done
}

# Main script logic
# Check for exactly one argument and that it's a valid directory
if [ $# -ne 1 ] || [ ! -d "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Clear previous log content
> "$LOGFILE"

# Initialize counters
total_files=0
world_writable_count=0

# Start processing files
process_files "$1"

# Print summary
echo "Scan complete. Results:"
echo "------------------------"
echo "Total files modified in last 7 days: $total_files"
echo "World-writable files: $world_writable_count"
echo "Log saved to $LOGFILE"
