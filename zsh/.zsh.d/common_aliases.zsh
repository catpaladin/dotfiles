alias ll="ls -alF --color=auto"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias k="kubectl"

# Suffix aliases — type a filename (no command) and it opens with the associated tool
alias -s json="jless"

# Config & source files open in bat (syntax-highlighted, auto-paged)
alias -s {conf,config,cfg,ini,env,yaml,yml,toml,properties}="bat"
alias -s {sh,bash,zsh}="bat"
alias -s {py,go,rs,ts,tsx,js,jsx,lua}="bat"
alias -s {tf,tfvars,hcl}="bat"
alias -s {css,html,xml,md,txt,log,csv,tsv}="bat"
