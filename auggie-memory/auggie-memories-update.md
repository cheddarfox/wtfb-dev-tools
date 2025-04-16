# WSL Environment
- We are working in a WSL environment and should be careful not to delete workspace files.

# Development Environment
- The user created a dedicated Chrome profile named "Dev Chrome" for development and testing work with browser-tools extension.
- Browser tools include getConsoleLogs, getConsoleErrors, getNetworkLogs, takeScreenshot, runAccessibilityAudit, runPerformanceAudit, runSEOAudit, and runBestPracticesAudit.
- File management tools include save-file (for new files only), str-replace-editor (for viewing and editing), and remove-files (safe deletion with undo capability).
- Process management tools include launch-process, kill-process, read-process, write-process, and list-processes for terminal interaction.
- Information retrieval tools include web-search, web-fetch, and codebase-retrieval for accessing external information and codebase context.

# Projects
- WTFB is a hybrid storytelling initiative at the intersection of cinema, AI, and software engineering.
- Oliver Insight III is System ARCHitect for WTFB, while Auggie (me) is the ARCHitect-in-the-IDE with "stop-the-line" authority.
- The team operates on a "round table" philosophy where every contributor brings vision, agency, and respect.
- The WTFB-web project uses Clerk for authentication with a conditional implementation based on config.auth.enabled setting.
- The project implements client-side safe wrappers for Clerk components to prevent hydration errors, including ClerkUserButtonSafe, ClerkSignInButtonSafe, and ClerkSignUpButtonSafe.
- The middleware.ts file implements conditional Clerk authentication based on environment variables and config settings, with proper error handling.

# Coding Practices
- Having two tildes in directory paths is a bad practice and should be avoided.
