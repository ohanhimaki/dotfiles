# --- Easier Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias ~='cd ~'

# --- Navigation Shortcuts ---
alias drop='cd ~/Documents/Dropbox'
alias dt='cd ~/Desktop'
alias docs='cd ~/Documents'
alias dl='cd ~/Downloads'
alias dotf='cd ~/dotfiles'

# --- Directory Listing ---
# List in long format, colorized
alias l='ls -lF --color=auto'
# Only directories
alias lsd='ls -d */'
alias lg='lazygit'

# --- Tools ---
alias vim='nvim'
alias v='nvim'

# Zoxide interactive directory change
zz() {
    local result=$(zoxide query -i)
    if [ -n "$result" ]; then
        cd "$result"
    fi
}

# --- FZF Configuration ---
# Set fzf default options for better UX
export FZF_DEFAULT_OPTS="
  --height=40%
  --layout=reverse
  --border
  --inline-info
  --preview-window=right:50%:wrap
  --bind='ctrl-/:toggle-preview'
  --color=bg+:#3c3836,bg:#282828,border:#504945,spinner:#fb4934,hl:#83a598
  --color=fg:#ebdbb2,header:#83a598,info:#fabd2f,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#83a598"

# Use fd if available for faster file search
if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# FZF useful functions
# Search and open file in vim
fzf_vim() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}')
    if [ -n "$file" ]; then
        nvim "$file"
    fi
}
alias fv='fzf_vim'

# Search and cd into directory
fzf_cd() {
    local dir
    if command -v fd &>/dev/null; then
        dir=$(fd --type d --hidden --follow --exclude .git 2>/dev/null | fzf --preview 'ls -la {}')
    else
        dir=$(find . -type d -not -path '*/\.git/*' 2>/dev/null | fzf --preview 'ls -la {}')
    fi
    if [ -n "$dir" ]; then
        cd "$dir"
    fi
}
alias fcd='fzf_cd'

# Kill process with fzf
fzf_kill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m --preview 'echo {}' --preview-window=down:3:wrap | awk '{print $2}')
    if [ -n "$pid" ]; then
        echo "$pid" | xargs kill -${1:-9}
    fi
}
alias fkill='fzf_kill'

# Git log browser
fzf_git_log() {
    git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" |
        fzf --ansi --no-sort --reverse --tiebreak=index \
            --preview 'echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always' \
            --bind 'enter:execute(echo {} | grep -o "[a-f0-9]\{7\}" | head -1 | xargs git show --color=always | less -R)'
}
alias fgl='fzf_git_log'
