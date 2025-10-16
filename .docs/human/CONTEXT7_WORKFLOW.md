## Context7 Documentation Workflow

### Overview

Context7 integration is enabled in the OpenCode configuration (`dot_config/opencode/config.toml.tmpl`) to provide up-to-date library documentation during AI-assisted development. This system automatically fetches and caches documentation for better development workflows.

### Configuration

**OpenCode Context7 Settings**:
```toml
[context7]
enabled = true
cache_dir = "{{ .chezmoi.homeDir }}/.local/share/chezmoi/.docs/context7"
```

### Usage Workflow

1. **Automatic Fetching**: When using OpenCode AI assistance, Context7 automatically:
   - Resolves library names to Context7-compatible IDs
   - Fetches relevant documentation for the libraries you're working with
   - Caches results in `.docs/context7/` for faster subsequent access

2. **Manual Documentation Access**: You can also manually request library documentation:
   ```bash
   # From within Neovim/OpenCode
   :OpenCodeContext7 <library-name>
   ```

3. **Cache Management**: 
   - Documentation is cached locally in `.docs/context7/`
   - Each library gets its own subdirectory
   - Safe to delete cache - documentation will be re-fetched as needed
   - Cache persists across sessions for better performance

### Supported Libraries

Context7 provides documentation for popular libraries including:
- **Frontend**: React, Vue, Angular, Next.js, Svelte
- **Backend**: Express, FastAPI, Django, Rails  
- **Databases**: MongoDB, PostgreSQL, Redis
- **Cloud**: AWS, GCP, Azure services
- **DevOps**: Docker, Kubernetes, Terraform
- **And many more...** (see Context7 library index)

### Cache Structure

```text
.docs/context7/
├── README.md                    # Cache overview and usage
├── mongodb-docs/               # MongoDB documentation cache
│   ├── overview.md
│   └── api-reference.md
├── react/                      # React documentation cache
│   ├── hooks.md
│   └── components.md
└── nextjs/                     # Next.js documentation cache
    ├── routing.md
    └── deployment.md
```

### Best Practices

1. **Let Context7 auto-fetch**: Normal OpenCode usage will automatically fetch needed docs
2. **Review cached docs**: Check `.docs/context7/` for locally cached library documentation
3. **Clean cache periodically**: Remove outdated cache directories to get fresh documentation
4. **Use specific topics**: When manually fetching, specify topics like "routing" or "authentication" for focused results

### Integration Benefits

- **Up-to-date information**: Always gets latest library documentation
- **Reduced hallucination**: AI has access to current, accurate library information  
- **Faster responses**: Cached documentation provides quick access to previously fetched content
- **Offline reference**: Cached docs available even when Context7 service is unavailable
- **Development continuity**: Persistent cache across development sessions

### Troubleshooting

**Common Issues**:
- **Cache not updating**: Delete specific library cache directory to force refresh
- **Network issues**: Check internet connection; Context7 requires online access for fresh fetches
- **Library not found**: Verify library name spelling or try alternative names (for example, "nextjs" vs "next.js")

**Debug Commands**:
```bash
# Check cache contents
ls -la .docs/context7/

# Remove specific library cache
rm -rf .docs/context7/mongodb-docs/

# Check OpenCode configuration
cat dot_config/opencode/config.toml.tmpl
```

This Context7 integration enhances the development experience by providing accurate, current library documentation directly within the AI-assisted development workflow.
