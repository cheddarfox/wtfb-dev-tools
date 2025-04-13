# VS Code Configuration

This directory contains VS Code configuration files and scripts for WTFB projects.

## Contents

- **bootstrap/** - Bootstrap files for VS Code project setup
  - `bootstrap.sh` - Bash script for Linux/WSL environment setup
  - `bootstrap.ps1` - PowerShell script for Windows environment setup
  - `settings.json` - VS Code settings for WTFB projects
  - `tasks.json` - VS Code tasks for WTFB projects
  - `extensions.json` - Recommended VS Code extensions

## Usage

### Adding to a New Project

1. Create a `.vscode` directory in your project root:
   ```bash
   mkdir -p .vscode
   ```

2. Copy the bootstrap files to your project:
   ```bash
   cp -r /path/to/wtfb-dev-tools/vscode/bootstrap/* .vscode/
   ```

3. Make the bootstrap script executable:
   ```bash
   chmod +x .vscode/bootstrap.sh
   ```

### Running the Bootstrap Script

The bootstrap script performs several checks to ensure your environment is properly configured:

- Verifies you're running in WSL
- Checks working directory
- Shows git branch context
- Links to Jira tickets
- Checks for Claude availability
- Verifies Node.js installation
- Ensures proper project structure

To run the bootstrap script:

1. From the command line:
   ```bash
   bash .vscode/bootstrap.sh
   ```

2. From VS Code:
   - Press `Ctrl+Shift+B` to run the default build task
   - This will execute the bootstrap script

## Bootstrap Script Output

The bootstrap script provides color-coded output to indicate the status of various checks:

- ✅ Green: Check passed
- ⚠️ Yellow: Warning or suggestion
- ❌ Red: Check failed

## Customization

You can customize the bootstrap files for your specific project needs. Common customizations include:

- Adding project-specific environment checks
- Configuring different Node.js versions
- Adding custom tasks to the tasks.json file

## Troubleshooting

If you encounter issues with the bootstrap script:

1. Ensure you're running in a WSL environment
2. Check that all paths in the script are correct for your environment
3. Verify that you have the necessary tools installed (git, node, etc.)
