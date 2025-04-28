##
## DIRECTORY ALIASES
##

alias l = ls 
alias ll = ls -a
alias la = ls -la

##
##  CHEZMOI
##
alias chezmoi_update = chezmoi init --apply --exclude=scripts
alias cia = chezmoi init --apply
alias chezmoi_data = cat ~/.config/chezmoi/chezmoi.toml
alias chezmoi_data_edit = nvim ~/.config/chezmoi/chezmoi.toml

# Function to update the system and install packages
def chezmoi_reset [] {
  rm -rf ~/.config/chezmoi
  chezmoi state reset
  chezmoi init --apply --exclude=scripts
}

##
## NEOVIM 
##

# Function to open a specific Obsidian vault in Neovim
def obsidian_nvim [vault] {
  nvim $"~/.config/obsidian/vaults/($vault)"
}

# Function to reset Neovim configuration
def reset_nvim [] {
  rm -rf ~/.config/nvim 
  rm -rf ~/.local/share/nvim 
  rm -rf ~/.local/state/nvim

  chezmoi apply --exclude=scripts
}

##
## GITHUB 
##
# Function to create a new GitHub repository
def gh-create-repo [
    name: string, 
    --private (-p) = false, 
    --description (-d): string = ""
] {
    let visibility = if $private { "private" } else { "public" }
    cd ~/source/
    gh repo create $name --$visibility --description $description
}

# Function to clone a GitHub reposi:tory
def gh-clone-repo [
    repo: string, 
    --destination (-d): string = "."
] {
    cd ~/source
    gh repo clone $repo $destination
}

# Function to list repositories for the authenticated user
def gh-list-repos [
    --limit (-l): int = 30
] {
    gh repo list --limit $limit 
}

# Function to delete a GitHub repository
def gh-delete-repo [
    repo: string
] {
    gh repo delete $repo --confirm
}

# Function to add a remote to an existing local repository
def gh-add-remote [
    remote_name: string, 
    repo: string
] {
    gh repo view $repo --json sshUrl | get sshUrl | each { git remote add $remote_name }
}

# Function to open a GitHub repository in the browser
def gh-open-repo [
    repo: string
] {
    gh repo view $repo --web
}

##
## OTHER 
##

# Function to show the current system information with a random image of a Pokémon
def poke_system_info [] {
  pokeget random --hide-name | fastfetch --file-raw -
}
alias y = yazi
alias cat = bat --style=plain
alias tks = tmux kill-server

