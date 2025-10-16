#!/bin/zsh
{{- if lookPath "fnm" }}
  # Set FNM environment variables
  export FNM_VERSION_FILE_STRATEGY="local"
  export FNM_DIR="{{ .chezmoi.homeDir }}/.local/share/fnm"
  export FNM_LOGLEVEL="info"
  export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
  export FNM_COREPACK_ENABLED="false"
  export FNM_RESOLVE_ENGINES="true"
  export FNM_ARCH="arm64"
  # Initialize FNM environment
  eval "$(fnm env --use-on-cd)"
{{- end }}
