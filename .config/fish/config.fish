set fish_greeting "Hello Giu,

   ／l、             
 （ﾟ､ ｡ ７         
   l  ~ヽ       
   じしf_,)ノ
"

set -gx TERM xterm-256color
set -gx EDITOR nvim

# aliases
alias vim "nvim"
if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH node_modules/.bin $PATH

# FZF theme
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# starship
starship init fish | source
