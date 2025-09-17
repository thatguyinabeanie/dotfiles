# Context7 Documentation Cache

This directory stores cached documentation from Context7 library fetches.

## Structure
- Each library gets its own subdirectory named after the Context7 library ID
- Documentation is stored as markdown files for easy reference
- Cache helps avoid repeated API calls for the same documentation

## Usage
- OpenCode automatically caches Context7 fetches here
- Manual caching can be done via OpenCode commands
- Files are safe to delete - they will be re-fetched as needed
