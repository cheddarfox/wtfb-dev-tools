# WTFB Development Tools

A collection of tools, scripts, and best practices for WTFB development.

## Browser Profiles for Development

### Why Use Dedicated Browser Profiles?

Using dedicated browser profiles for development work offers several advantages:

1. **Separation of concerns**: Keeps development cookies, cache, and extensions separate from personal browsing
2. **Clean testing environment**: Ensures a consistent starting point for testing
3. **Prevents conflicts**: Avoids issues with extensions or settings that might interfere with development
4. **Security**: Reduces risk of accidentally using production credentials in development environments
5. **Organized bookmarks**: Maintain development-specific bookmarks and resources

### Chrome Development Profile

We've created a script to launch Chrome with a dedicated development profile:

```bash
# Launch Chrome with development profile
~/Projects/wtfb-dev-tools/launch-dev-chrome.sh

# Launch Chrome with development profile and open a specific URL
~/Projects/wtfb-dev-tools/launch-dev-chrome.sh http://localhost:3000
```

### Best Practices for Development Browsers

1. **Use dedicated profiles**: Always use the development profile for testing and development work
2. **Install development-specific extensions**: 
   - React Developer Tools
   - Redux DevTools
   - Accessibility Insights
   - Web Vitals
   - Clerk DevTools (for authentication testing)
3. **Disable cache when DevTools is open**: In DevTools > Settings > Preferences
4. **Use incognito mode for testing user flows**: Especially for authentication and onboarding
5. **Clear browser data regularly**: Start fresh before testing critical features
6. **Test across multiple browsers**: Chrome, Firefox, Safari, and Edge
7. **Test responsive designs**: Use responsive design mode in DevTools

## Setting Up Your Development Profile

1. Run the `launch-dev-chrome.sh` script to create and open the development profile
2. Install the recommended extensions
3. Configure DevTools settings:
   - Enable "Disable cache (while DevTools is open)"
   - Enable "Show rulers on hover"
   - Enable network request blocking for testing offline scenarios
4. Bookmark important development resources:
   - Local development URLs (http://localhost:3000)
   - Clerk Dashboard
   - Supabase Dashboard
   - GitHub repository
   - Jira board
   - Confluence documentation

## Additional Tools

More development tools will be added to this repository as they are created.

---

Created and maintained by the WTFB development team.
