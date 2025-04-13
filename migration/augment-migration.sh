#!/bin/bash

# Augment Migration Script
# This script migrates Augment extension data between environments
# Created by Auggie (ARCHitect-in-the-IDE)

# Default values
DRY_RUN=true
BACKUP_ONLY=false
LOG_FILE="augment-migration.log"
COMPONENTS="memories"  # Default to just migrating memories

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display usage information
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -s, --source SOURCE_DIR    Source directory (required)"
    echo "  -d, --dest DEST_DIR        Destination directory (required)"
    echo "  -m, --mode MODE            Mode: dry-run, backup, full (default: dry-run)"
    echo "  -c, --components COMPS     Components to migrate: memories,assets,all (default: memories)"
    echo "  -l, --log LOG_FILE         Log file (default: augment-migration.log)"
    echo "  -h, --help                 Display this help message"
    echo ""
    echo "Example:"
    echo "  $0 --source /mnt/c/Users/Scott/AppData/Roaming/Code/User/workspaceStorage/3c540e917b94c41f10f7f8bd49a88fb7/Augment.vscode-augment \\"
    echo "     --dest /home/cheddarfox/.vscode-server/data/User/workspaceStorage/05485d8a6ebb8f20e623dd25dd2ff75e/Augment.vscode-augment \\"
    echo "     --mode full --components memories,assets"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source)
            SOURCE_DIR="$2"
            shift 2
            ;;
        -d|--dest)
            DEST_DIR="$2"
            shift 2
            ;;
        -m|--mode)
            MODE="$2"
            case $MODE in
                dry-run)
                    DRY_RUN=true
                    BACKUP_ONLY=false
                    ;;
                backup)
                    DRY_RUN=false
                    BACKUP_ONLY=true
                    ;;
                full)
                    DRY_RUN=false
                    BACKUP_ONLY=false
                    ;;
                *)
                    echo -e "${RED}Error: Invalid mode '$MODE'. Use dry-run, backup, or full.${NC}"
                    usage
                    ;;
            esac
            shift 2
            ;;
        -c|--components)
            COMPONENTS="$2"
            shift 2
            ;;
        -l|--log)
            LOG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo -e "${RED}Error: Unknown option '$1'${NC}"
            usage
            ;;
    esac
done

# Validate required parameters
if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo -e "${RED}Error: Source and destination directories are required.${NC}"
    usage
fi

# Initialize log file
init_log() {
    echo "=== Augment Migration Log ===" > "$LOG_FILE"
    echo "Date: $(date)" >> "$LOG_FILE"
    echo "Source: $SOURCE_DIR" >> "$LOG_FILE"
    echo "Destination: $DEST_DIR" >> "$LOG_FILE"
    echo "Mode: $MODE" >> "$LOG_FILE"
    echo "Components: $COMPONENTS" >> "$LOG_FILE"
    echo "===========================" >> "$LOG_FILE"
}

# Log a message to both console and log file
log() {
    local level="$1"
    local message="$2"
    local color=""

    case $level in
        INFO)
            color="$BLUE"
            ;;
        SUCCESS)
            color="$GREEN"
            ;;
        WARNING)
            color="$YELLOW"
            ;;
        ERROR)
            color="$RED"
            ;;
        *)
            color="$NC"
            ;;
    esac

    echo -e "${color}[$level] $message${NC}"
    echo "[$level] $message" >> "$LOG_FILE"
}

# Create a backup of the destination directory
create_backup() {
    local backup_dir="${DEST_DIR}_backup_$(date +%Y%m%d_%H%M%S)"

    log "INFO" "Creating backup of destination directory to $backup_dir"

    if [ "$DRY_RUN" = true ]; then
        log "INFO" "[DRY RUN] Would create backup: $backup_dir"
    else
        if cp -r "$DEST_DIR" "$backup_dir"; then
            log "SUCCESS" "Backup created successfully"
        else
            log "ERROR" "Failed to create backup"
            exit 1
        fi
    fi

    echo "$backup_dir"
}

# Analyze a file to determine if it's environment-specific
analyze_file() {
    local file="$1"
    local filename=$(basename "$file")

    log "INFO" "Analyzing file: $filename"

    # Check if file contains environment-specific paths
    if grep -q "/mnt/c/Users/Scott" "$file" 2>/dev/null; then
        log "WARNING" "File contains Windows-specific paths: $filename"
        echo "environment-specific"
    elif grep -q "C:\\\\Users\\\\Scott" "$file" 2>/dev/null; then
        log "WARNING" "File contains Windows-specific paths: $filename"
        echo "environment-specific"
    else
        # Check file type
        case "$filename" in
            *Index.json|*Cache.json)
                log "INFO" "File is an index or cache file: $filename"
                echo "environment-specific"
                ;;
            Augment-Memories)
                log "INFO" "File is the memories file: $filename"
                echo "merge"
                ;;
            *.png|*.jpg|*.jpeg|*.gif)
                log "INFO" "File is an image asset: $filename"
                echo "copy"
                ;;
            *)
                # Default to portable for unknown files
                log "INFO" "File appears portable: $filename"
                echo "copy"
                ;;
        esac
    fi
}

# Merge memories files
merge_memories() {
    local source_file="$SOURCE_DIR/Augment-Memories"
    local dest_file="$DEST_DIR/Augment-Memories"
    local merged_file="$DEST_DIR/Augment-Memories.merged"

    log "INFO" "Merging memories files"

    if [ ! -f "$source_file" ]; then
        log "ERROR" "Source memories file not found: $source_file"
        return 1
    fi

    if [ ! -f "$dest_file" ]; then
        log "WARNING" "Destination memories file not found, will copy source file"
        if [ "$DRY_RUN" = true ]; then
            log "INFO" "[DRY RUN] Would copy source memories file to destination"
        else
            cp "$source_file" "$dest_file"
            log "SUCCESS" "Copied source memories file to destination"
        fi
        return 0
    fi

    # Create merged file
    # Start with destination file content
    cat "$dest_file" > "$merged_file"

    # Add a separator
    echo -e "\n# Migrated Memories from Windows Environment\n" >> "$merged_file"

    # Extract sections from source file that don't exist in destination
    log "INFO" "Analyzing memories file for new sections to merge"

    # Track sections for reporting
    new_sections=""

    while IFS= read -r line; do
        if [[ "$line" =~ ^#\ .* ]]; then
            # This is a section header
            section=$(echo "$line" | sed 's/^# //')
            if ! grep -q "^# $section$" "$dest_file"; then
                # Section doesn't exist in destination, add it
                echo -e "\n$line" >> "$merged_file"
                in_new_section=true
                new_sections="$new_sections\n - $section"
                log "INFO" "Found new section to merge: $section"
            else
                in_new_section=false
            fi
        elif [[ "$in_new_section" = true && "$line" =~ ^-\ .* ]]; then
            # This is a bullet point in a new section
            echo "$line" >> "$merged_file"
        fi
    done < "$source_file"

    if [ -z "$new_sections" ]; then
        log "INFO" "No new sections found to merge"
    else
        log "INFO" "New sections to merge:$new_sections"
    fi

    if [ "$DRY_RUN" = true ]; then
        log "INFO" "[DRY RUN] Would merge memories files with the sections above"
        # Clean up the temporary file in dry run mode
        rm "$merged_file"
    else
        # Replace the destination file with the merged file
        mv "$merged_file" "$dest_file"
        log "SUCCESS" "Merged memories files successfully"
    fi
}

# Migrate a specific component
migrate_component() {
    local component="$1"

    case "$component" in
        memories)
            log "INFO" "Migrating memories component"
            merge_memories
            ;;
        assets)
            log "INFO" "Migrating user assets"
            local assets_dir="$SOURCE_DIR/augment-user-assets"
            local dest_assets_dir="$DEST_DIR/augment-user-assets"

            if [ ! -d "$assets_dir" ]; then
                log "WARNING" "Source assets directory not found: $assets_dir"
                return
            fi

            if [ ! -d "$dest_assets_dir" ]; then
                if [ "$DRY_RUN" = true ]; then
                    log "INFO" "[DRY RUN] Would create destination assets directory"
                else
                    mkdir -p "$dest_assets_dir"
                fi
            fi

            # Copy image files
            for asset in "$assets_dir"/*.{png,jpg,jpeg,gif}; do
                if [ -f "$asset" ]; then
                    local filename=$(basename "$asset")
                    if [ "$DRY_RUN" = true ]; then
                        log "INFO" "[DRY RUN] Would copy asset: $filename"
                    else
                        cp "$asset" "$dest_assets_dir/"
                        log "SUCCESS" "Copied asset: $filename"
                    fi
                fi
            done
            ;;
        all)
            log "INFO" "Migrating all components"
            migrate_component "memories"
            migrate_component "assets"

            # Copy any other files that aren't environment-specific
            for file in "$SOURCE_DIR"/*; do
                if [ -f "$file" ]; then
                    local filename=$(basename "$file")
                    local analysis=$(analyze_file "$file")

                    if [ "$analysis" = "copy" ]; then
                        if [ "$DRY_RUN" = true ]; then
                            log "INFO" "[DRY RUN] Would copy file: $filename"
                        else
                            cp "$file" "$DEST_DIR/"
                            log "SUCCESS" "Copied file: $filename"
                        fi
                    elif [ "$analysis" = "merge" ] && [ "$filename" != "Augment-Memories" ]; then
                        # We already handled Augment-Memories separately
                        log "WARNING" "File needs manual merging: $filename"
                    fi
                fi
            done
            ;;
        *)
            log "ERROR" "Unknown component: $component"
            ;;
    esac
}

# Main function
main() {
    init_log

    log "INFO" "Starting Augment migration in ${MODE} mode"

    # Validate directories
    if [ ! -d "$SOURCE_DIR" ]; then
        log "ERROR" "Source directory does not exist: $SOURCE_DIR"
        exit 1
    fi

    if [ ! -d "$DEST_DIR" ]; then
        log "ERROR" "Destination directory does not exist: $DEST_DIR"
        exit 1
    fi

    # Create backup
    local backup_dir=$(create_backup)

    if [ "$BACKUP_ONLY" = true ]; then
        log "SUCCESS" "Backup completed successfully. Exiting as requested."
        exit 0
    fi

    # Process each requested component
    IFS=',' read -ra COMP_ARRAY <<< "$COMPONENTS"
    for comp in "${COMP_ARRAY[@]}"; do
        migrate_component "$comp"
    done

    if [ "$DRY_RUN" = true ]; then
        log "SUCCESS" "Dry run completed. No changes were made."
        log "INFO" "To perform the actual migration, run with --mode full"
    else
        log "SUCCESS" "Migration completed successfully"
        log "INFO" "Backup is available at: $backup_dir"
    fi
}

# Run the main function
main
