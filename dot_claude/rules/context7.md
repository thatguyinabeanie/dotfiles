How to query Context7 once you've decided to use it (the MCP server's own instructions cover when).

## Steps

1. Always start with `resolve-library-id` using the library name and what to look up in the library's
   documentation, unless the user provides an exact library ID in `/org/project` format
2. Pick the best match (ID format: `/org/project`) by: exact name match, description relevance, code
   snippet count, source reputation (High/Medium preferred), and benchmark score (higher is better).
   If results don't look right, try alternate names or queries, for example `next.js` rather than
   `nextjs`, or rephrase the question. Use version-specific IDs when the user mentions a version
3. `query-docs` with the selected library ID and what to look up in the library's documentation (not
   single words), scoped to a single concept. If the question spans multiple distinct concepts, for
   example routing and auth and caching, make a separate `query-docs` call per concept with the same
   library ID, unless the question is about how the concepts interact. Combined queries dilute
   ranking and return shallow results for each topic
4. Answer using the fetched docs
