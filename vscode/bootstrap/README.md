# VS Code Bootstrap Files

These files provide a standardized VS Code setup for WTFB projects.

## Files

- `bootstrap.sh` - Bash script for Linux/WSL environment setup
- `bootstrap.ps1` - PowerShell script for Windows environment setup
- `settings.json` - VS Code settings for WTFB projects
- `tasks.json` - VS Code tasks for WTFB projects
- `extensions.json` - Recommended VS Code extensions

## Bootstrap Script

The `bootstrap.sh` script performs several important checks:

1. **Environment Verification**
   - Confirms you're running in WSL
   - Checks working directory

2. **Project Context**
   - Shows current git branch
   - Links to Jira ticket (if branch follows naming convention)

3. **Tool Availability**
   - Checks for Claude installation
   - Verifies ANTHROPIC_API_KEY is set
   - Checks Node.js installation via nvm

4. **Security & Best Practices**
   - Warns about untrusted directories
   - Suggests recommended project structure

## VS Code Settings

The `settings.json` file configures VS Code with WTFB-specific settings:

- Sets WSL as the default terminal
- Configures code formatting options
- Sets consistent line endings
- Enables trailing whitespace trimming

## Tasks

The `tasks.json` file defines VS Code tasks:

- Sets up the bootstrap script as the default build task
- Configures task presentation options

## Extensions

The `extensions.json` file recommends VS Code extensions:

- WSL Remote extension for Windows users

## Usage

These files should be placed in the `.vscode` directory of your project. The bootstrap script can be run with:

```bash
bash .vscode/bootstrap.sh
```

Or by pressing `Ctrl+Shift+B` in VS Code.
