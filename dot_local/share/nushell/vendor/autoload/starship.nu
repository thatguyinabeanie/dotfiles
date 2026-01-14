# this file is both a valid
# - overlay which can be loaded with `overlay use starship.nu`
# - module which can be used with `use starship.nu`
# - script which can be used with `source starship.nu`
export-env { $env.STARSHIP_SHELL = "nu"; load-env {
    STARSHIP_SESSION_KEY: (random chars -l 16)
    PROMPT_MULTILINE_INDICATOR: (
        ^starship prompt --continuation
    )

    # Starship vi mode indicators
    # Uses the vimcmd_symbol from starship.toml for vi command mode
    # When in insert mode, shows empty indicator; command mode shows ❮
    PROMPT_INDICATOR: ""
    PROMPT_INDICATOR_VI_INSERT: ""
    PROMPT_INDICATOR_VI_NORMAL: ""  # Starship's character module handles this

    PROMPT_COMMAND: {||
        # jobs are not supported
        (
            ^starship prompt
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }

    config: ($env.config? | default {} | merge {
        render_right_prompt_on_last_line: true
    })

    PROMPT_COMMAND_RIGHT: {||
        (
            ^starship prompt
                --right
                --cmd-duration $env.CMD_DURATION_MS
                $"--status=($env.LAST_EXIT_CODE)"
                --terminal-width (term size).columns
        )
    }
}}
