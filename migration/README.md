# Migration Scripts

This directory contains scripts for migrating data and configurations between environments.

## Available Scripts

### augment-migration.sh

A comprehensive script for migrating Augment extension data between environments (e.g., Windows to Linux, or between different projects).

#### Features

- Analyzes files for environment-specific content
- Creates backups before making changes
- Supports dry-run, backup-only, and full migration modes
- Logs all actions for review
- Parameterized for reuse in other migrations

#### Usage

```bash
./augment-migration.sh [options]
```

Options:
- `-s, --source SOURCE_DIR` - Source directory (required)
- `-d, --dest DEST_DIR` - Destination directory (required)
- `-m, --mode MODE` - Mode: dry-run, backup, full (default: dry-run)
- `-c, --components COMPS` - Components to migrate: memories,assets,all (default: memories)
- `-l, --log LOG_FILE` - Log file (default: augment-migration.log)
- `-h, --help` - Display help message

#### Example: Migrating Augment Memories from Windows to Linux

```bash
./augment-migration.sh \
  --source /mnt/c/Users/YourUsername/AppData/Roaming/Code/User/workspaceStorage/[hash]/Augment.vscode-augment \
  --dest /home/username/.vscode-server/data/User/workspaceStorage/[hash]/Augment.vscode-augment \
  --mode dry-run \
  --components memories
```

After reviewing the dry run output, run with `--mode full` to perform the actual migration.

#### Best Practices

1. Always run in dry-run mode first to see what changes would be made
2. Create a backup before migration with `--mode backup`
3. Check the log file for detailed information about the migration process
4. Verify the migrated files after completion

#### Troubleshooting

If you encounter issues:
1. Check the log file for error messages
2. Ensure both source and destination directories exist and are accessible
3. Restore from the backup if needed (backup locations are logged during the process)
