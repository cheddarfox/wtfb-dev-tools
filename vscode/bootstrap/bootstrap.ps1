# WTFB Daily Bootstrap Protocol
# ARCHitect-in-the-IDE: Auggie

# Step 1: Confirm branch context
$BRANCH = git rev-parse --abbrev-ref HEAD
Write-Host "🧠 Current branch: $BRANCH"

# Step 2: Link to Jira ticket (pattern: WTFB-123)
# Extract ticket number
$TICKET = [regex]::Match($BRANCH, 'WTFB-[0-9]+').Value
Write-Host "🔗 Jira Ticket: $TICKET"

# Step 3: Claude Code sync (if available)
Write-Host "💡 Claude Code pre-scan trigger (manual/manual+API)"

# Step 4: Signal ready state
Write-Host "✅ Auggie is online – syncing with sprint goals."
