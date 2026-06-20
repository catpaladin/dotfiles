alias ls="eza --icons"
alias ll="eza -lh --icons --git"
alias la="eza -lah --icons --git"
alias tree="eza --tree --icons"

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias k="kubectl"

# Suffix aliases — type a filename (no command) and it opens with the associated tool
alias -s json="jless"

# Config & source files open in bat (syntax-highlighted, auto-paged)
alias -s {conf,config,cfg,ini,env,yaml,yml,toml,properties}="bat"
alias -s {sh,bash,zsh}="bat"
alias -s {py,go,rs,ts,tsx,js,jsx,lua}="bat"
alias -s {tf,tfvars,hcl}="bat"
alias -s {css,html,xml,md,txt,log,csv,tsv}="bat"
