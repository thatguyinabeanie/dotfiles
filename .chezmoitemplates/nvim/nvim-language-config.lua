-- Auto-generated language tooling configuration
-- Generated: {{ now }}
-- Sources: lsp.yaml, formatters.yaml, linters.yaml, parsers.yaml

return {
  -- TreeSitter parsers configuration
  treesitter = {
    parsers = {
{{- range .treesitter_parsers }}
      "{{ .name }}",
{{- end }}
    },

    -- Parser categories for organization
    categories = {
{{- $categories := dict }}
{{- range .treesitter_parsers }}
  {{- $list := index $categories .category | default list }}
  {{- $list = append $list .name }}
  {{- $categories = set $categories .category $list }}
{{- end }}
{{- range $category, $parsers := $categories }}
      {{ $category }} = {
  {{- range $parsers }}
        "{{ . }}",
  {{- end }}
      },
{{- end }}
    },
  },

  -- Mason packages (explicitly marked for Mason management)
  mason = {
    core_tools = {
{{- range .language_servers }}
  {{- if and (hasKey . "mason_ensure_installed") .mason_ensure_installed }}
      "{{ if hasKey . "mason_name" }}{{ .mason_name }}{{ else }}{{ .name }}{{ end }}",
  {{- end }}
{{- end }}
{{- range .formatters }}
  {{- if and (hasKey . "mason_ensure_installed") .mason_ensure_installed }}
      "{{ if hasKey . "mason_name" }}{{ .mason_name }}{{ else }}{{ .name }}{{ end }}",
  {{- end }}
{{- end }}
{{- range .linters }}
  {{- if and (hasKey . "mason_ensure_installed") .mason_ensure_installed }}
      "{{ if hasKey . "mason_name" }}{{ .mason_name }}{{ else }}{{ .name }}{{ end }}",
  {{- end }}
{{- end }}
    },
    exploration_tools = {
{{- range .dev_tools }}
  {{- if and (hasKey . "mason_ensure_installed") .mason_ensure_installed }}
      "{{ if hasKey . "mason_name" }}{{ .mason_name }}{{ else }}{{ .name }}{{ end }}",
  {{- end }}
{{- end }}
    },
  },

  -- Filetype associations
  filetypes = {
    templates = {
      bash = { "sh.tmpl", "zsh.tmpl" },
      lua = { "lua.tmpl" },
      nu = { "nu.tmpl" },
      toml = { "toml.tmpl" },
    },
    lsp_servers = {
{{- range $server := .language_servers }}
{{- range $server.languages }}
      {{ . }} = "{{ $server.name }}",
{{- end }}
{{- end }}
    },
    web_frameworks = {
      "javascriptreact",
      "typescriptreact",
      "html",
      "astro",
      "svelte",
      "vue",
    },
  },

  -- Language server configuration
  lsp = {
    servers = {
{{- range .language_servers }}
      ["{{ .name }}"] = {
        languages = { {{- range .languages }}"{{ . }}", {{- end }} },
        install_via = "{{ .install_via }}",
        runtime = "{{ .runtime }}",
        provides_formatting = {{ .provides_formatting }},
        description = "{{ .description }}",
      },
{{- end }}
    },

    -- Language to LSP server mapping
    language_map = {
{{- range $server := .language_servers }}
  {{- range $server.languages }}
      {{ . }} = "{{ $server.name }}",
  {{- end }}
{{- end }}
    },

    -- Servers by installation method
    by_install_method = {
{{- $byInstall := dict }}
{{- range .language_servers }}
  {{- $list := index $byInstall .install_via | default list }}
  {{- $list = append $list .name }}
  {{- $byInstall = set $byInstall .install_via $list }}
{{- end }}
{{- range $method, $servers := $byInstall }}
      {{ $method }} = {
  {{- range $servers }}
        "{{ . }}",
  {{- end }}
      },
{{- end }}
    },
  },

  -- Formatter configuration
  formatters = {
    tools = {
{{- range .formatters }}
      ["{{ .name }}"] = {
        languages = { {{- range .languages }}"{{ . }}", {{- end }} },
        install_via = "{{ .install_via }}",
        runtime = "{{ .runtime }}",
        description = "{{ .description }}",
        {{- if hasKey . "conflicts_with_lsp_formatting" }}
        conflicts_with_lsp_formatting = {{ .conflicts_with_lsp_formatting }},
        {{- end }}
        {{- if hasKey . "builtin_to_toolchain" }}
        builtin_to_toolchain = {{ .builtin_to_toolchain }},
        {{- end }}
      },
{{- end }}
    },

    -- Language to formatter mapping
    language_map = {
{{- range $formatter := .formatters }}
  {{- range $formatter.languages }}
      {{ . }} = "{{ $formatter.name }}",
  {{- end }}
{{- end }}
    },

    -- Formatters by installation method
    by_install_method = {
{{- $byInstall := dict }}
{{- range .formatters }}
  {{- $list := index $byInstall .install_via | default list }}
  {{- $list = append $list .name }}
  {{- $byInstall = set $byInstall .install_via $list }}
{{- end }}
{{- range $method, $formatters := $byInstall }}
      {{ $method }} = {
  {{- range $formatters }}
        "{{ . }}",
  {{- end }}
      },
{{- end }}
    },
  },

  -- Linter configuration
  linters = {
    tools = {
{{- range .linters }}
      ["{{ .name }}"] = {
        languages = { {{- range .languages }}"{{ . }}", {{- end }} },
        install_via = "{{ .install_via }}",
        runtime = "{{ .runtime }}",
        description = "{{ .description }}",
        {{- if hasKey . "builtin_to_toolchain" }}
        builtin_to_toolchain = {{ .builtin_to_toolchain }},
        {{- end }}
      },
{{- end }}
    },

    -- Language to linter mapping
    language_map = {
{{- $langMap := dict }}
{{- range $linter := .linters }}
  {{- range $linter.languages }}
    {{- $list := index $langMap . | default list }}
    {{- $list = append $list $linter.name }}
    {{- $langMap = set $langMap . $list }}
  {{- end }}
{{- end }}
{{- range $lang, $linters := $langMap }}
      {{ $lang }} = { {{- range $linters }}"{{ . }}", {{- end }} },
{{- end }}
    },

    -- Linters by installation method
    by_install_method = {
{{- $byInstall := dict }}
{{- range .linters }}
  {{- $list := index $byInstall .install_via | default list }}
  {{- $list = append $list .name }}
  {{- $byInstall = set $byInstall .install_via $list }}
{{- end }}
{{- range $method, $linters := $byInstall }}
      {{ $method }} = {
  {{- range $linters }}
        "{{ . }}",
  {{- end }}
      },
{{- end }}
    },
  },

  -- Complete language configuration (combines LSP, formatters, linters, parsers)
  languages = {
{{- $allLanguages := dict }}
{{- range $server := .language_servers }}
  {{- range $server.languages }}
    {{- $config := index $allLanguages . | default dict }}
    {{- $config = set $config "lsp" $server.name }}
    {{- $allLanguages = set $allLanguages . $config }}
  {{- end }}
{{- end }}
{{- range $formatter := .formatters }}
  {{- range $formatter.languages }}
    {{- $config := index $allLanguages . | default dict }}
    {{- $formatters := index $config "formatters" | default list }}
    {{- $formatters = append $formatters $formatter.name }}
    {{- $config = set $config "formatters" $formatters }}
    {{- $allLanguages = set $allLanguages . $config }}
  {{- end }}
{{- end }}
{{- range $linter := .linters }}
  {{- range $linter.languages }}
    {{- $config := index $allLanguages . | default dict }}
    {{- $linters := index $config "linters" | default list }}
    {{- $linters = append $linters $linter.name }}
    {{- $config = set $config "linters" $linters }}
    {{- $allLanguages = set $allLanguages . $config }}
  {{- end }}
{{- end }}
{{- range .treesitter_parsers }}
  {{- $config := index $allLanguages .language | default dict }}
  {{- $config = set $config "parser" .name }}
  {{- $allLanguages = set $allLanguages .language $config }}
{{- end }}
{{- range $lang, $config := $allLanguages }}
    {{ $lang }} = {
  {{- if index $config "lsp" }}
      lsp = "{{ index $config "lsp" }}",
  {{- end }}
  {{- if index $config "formatters" }}
      formatters = { {{- range index $config "formatters" }}"{{ . }}", {{- end }} },
  {{- end }}
  {{- if index $config "linters" }}
      linters = { {{- range index $config "linters" }}"{{ . }}", {{- end }} },
  {{- end }}
  {{- if index $config "parser" }}
      parser = "{{ index $config "parser" }}",
  {{- end }}
    },
{{- end }}
  },

  -- Installation summary
  installation = {
    -- All tools that need to be installed via mise
    mise_tools = {
{{- $miseTools := list }}
{{- range .language_servers }}
  {{- if eq .install_via "mise" }}
    {{- $miseTools = append $miseTools .name }}
  {{- end }}
{{- end }}
{{- range .formatters }}
  {{- if eq .install_via "mise" }}
    {{- $miseTools = append $miseTools .name }}
  {{- end }}
{{- end }}
{{- range .linters }}
  {{- if eq .install_via "mise" }}
    {{- $miseTools = append $miseTools .name }}
  {{- end }}
{{- end }}
{{- $miseTools = uniq $miseTools }}
{{- range $miseTools }}
      "{{ . }}",
{{- end }}
    },

    -- All tools that need to be installed via brew
    brew_tools = {
{{- $brewTools := list }}
{{- range .language_servers }}
  {{- if eq .install_via "brew" }}
    {{- $brewTools = append $brewTools .name }}
  {{- end }}
{{- end }}
{{- range .formatters }}
  {{- if eq .install_via "brew" }}
    {{- $brewTools = append $brewTools .name }}
  {{- end }}
{{- end }}
{{- range .linters }}
  {{- if eq .install_via "brew" }}
    {{- $brewTools = append $brewTools .name }}
  {{- end }}
{{- end }}
{{- $brewTools = uniq $brewTools }}
{{- range $brewTools }}
      "{{ . }}",
{{- end }}
    },
  },
}
