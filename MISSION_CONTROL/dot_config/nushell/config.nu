source ~/.config/nushell/env.nu
source ~/.config/nushell/aliases.nu
source ~/.config/nushell/secrets.nu
# source ~/.cache/carapace/init.nu

if ($env.WORK_ENVIRONMENT? == "true" || $env.WORK_ENVIRONMENT? == true) {
    source ~/.config/nushell/work.nu
}

# Load Catppuccin theme based on CATPPUCCIN_FLAVOR env var
match ($env.CATPPUCCIN_FLAVOR? | default "mocha") {
    "latte" => { source ~/.config/nushell/.catppuccin/themes/catppuccin_latte.nu },
    "frappe" => { source ~/.config/nushell/.catppuccin/themes/catppuccin_frappe.nu },
    "macchiato" => { source ~/.config/nushell/.catppuccin/themes/catppuccin_macchiato.nu },
    "mocha" => { source ~/.config/nushell/.catppuccin/themes/catppuccin_mocha.nu },
    _ => { source ~/.config/nushell/.catppuccin/themes/catppuccin_mocha.nu }
}

# Source FZF theme
source ~/.config/fzf/fzf-theme.nu

$env.config.show_banner = false

mise activate nu            | save -f ($nu.data-dir | path join "vendor/autoload/mise_activate.nu")
zoxide init nushell         | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
starship init nu            | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

if ($env.HOME | path join ".cargo/env.nu" | path exists) {
  cp ($env.HOME | path join ".cargo/env.nu") ($nu.data-dir | path join "vendor/autoload")
}

# pokeget random --hide-name | fastfetch --file-raw -