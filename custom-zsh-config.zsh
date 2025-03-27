
# Load additional plugins
omz plugin load history-substring-search

# Disable default plugins
omz plugin disable zsh-autosuggestions fzf

# Substring search binding
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Define/override variables
ZSH_THEME=""
CLICOLOR=1
PROMPT='%F{white}[%n@%m %f%~%F{white}]%f$ '
