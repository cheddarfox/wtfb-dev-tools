#!/bin/bash

# WTFB Daily Bootstrap Protocol
# ARCHitect-in-the-IDE: Auggie

# Check if we're in WSL
if [[ "$(uname -r)" != *Microsoft* && "$(uname -r)" != *microsoft* ]]; then
  echo "❌ WARNING: Not running in WSL. This script is designed for WSL environment."
  echo "Please run this in a WSL terminal for proper functionality."
else
  echo "✅ Running in WSL environment"
fi

# Check working directory
CURRENT_DIR=$(pwd)
if [[ "$CURRENT_DIR" == "/" || "$CURRENT_DIR" == "$HOME" ]]; then
  echo "❌ WARNING: Running from root or home directory. Please run from a project folder."
  echo "  Recommended: mkdir -p ~/dev/wtfb-session && cd ~/dev/wtfb-session"
else
  echo "✅ Working directory: $CURRENT_DIR"
fi

# Step 1: Confirm branch context
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "🧠 Current branch: $BRANCH"

# Step 2: Link to Jira ticket (pattern: WTFB-123)
# Extract ticket number
TICKET=$(echo $BRANCH | grep -oE 'WTFB-[0-9]+')
echo "🔗 Jira Ticket: $TICKET"

# Step 3: Claude Code sync (if available)
which claude >/dev/null && echo "✅ Claude ready" || echo "❌ Claude missing"

# Check for ANTHROPIC_API_KEY
if [ -z "$ANTHROPIC_API_KEY" ]; then
  echo "❌ ANTHROPIC_API_KEY not set. Claude may not function properly."
  echo "  Consider adding 'export ANTHROPIC_API_KEY=your-key-here' to your .bashrc"
else
  echo "✅ ANTHROPIC_API_KEY is set"
fi

# Check .bashrc PATH consistency
if [ -f "$HOME/.bashrc" ]; then
  if grep -q "export PATH=\"\$PATH:\$\(npm bin -g\)\"" "$HOME/.bashrc"; then
    echo "✅ npm global bin is in PATH via .bashrc"
  else
    echo "⚠️ Consider adding 'export PATH=\"\$PATH:\$\(npm bin -g\)\"' to your .bashrc"
  fi
fi

echo "💡 Claude Code pre-scan trigger (manual/manual+API)"

# Step 4: Check Node.js installation via nvm
if command -v nvm >/dev/null; then
  echo "✅ nvm is installed"
  NODE_VERSION=$(node -v 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo "✅ Node.js $NODE_VERSION is available"
  else
    echo "❌ Node.js not found. Consider installing via nvm"
  fi
else
  echo "❌ nvm not found. Please install nvm for Node.js version management"
  echo "  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash"
fi

# Step 5: Check for recommended project structure and security
if [[ "$CURRENT_DIR" != *"/dev/wtfb-"* ]]; then
  echo "⚠️ Consider using the recommended project structure: ~/dev/wtfb-session"
fi

# Security check for untrusted directories
if [[ "$CURRENT_DIR" == *"/Downloads"* || "$CURRENT_DIR" == *"/tmp"* ]]; then
  echo "❌ WARNING: Running from potentially untrusted directory. Security risk!"
  echo "  Never run Claude sessions from downloaded/unvetted directories."
fi

# Step 6: Signal ready state
echo "🧠 Auggie is online and CLAUDE is cleared for takeoff."
