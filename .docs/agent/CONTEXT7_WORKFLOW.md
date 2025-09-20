# Context7 Workflow Agent Guide

## Quick Overview

- **Purpose**: This document explains how to use the Context7 integration for up-to-date library documentation.
- **Integration**: Configured as an MCP server in `opencode.jsonc`.

## Configuration Discovery

- **Primary files**: `opencode.jsonc`
- **Search patterns**: `rg "context7" opencode.jsonc`
- **Template variables**: N/A

## Common Tasks

### Enable/disable Context7

- **Files**: Edit the `enabled` flag in the `context7` section of `opencode.jsonc`.
- **Validation**: N/A
- **Conflicts**: N/A

### Change Context7 URL

- **Files**: Edit the `url` field in the `context7` section of `opencode.jsonc`.
- **Validation**: N/A
- **Conflicts**: N/A

## Validation Checklist

- [ ] N/A

## Troubleshooting

- **Common errors**: Incorrect API key.
- **Conflict resolution**: N/A
- **Rollback**: Revert changes in git.
