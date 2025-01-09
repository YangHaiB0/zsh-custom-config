# make sure you execute this *after* asdf or other version managers are loaded
if (( $+commands[orbctl] )); then
  eval "$(orbctl completion zsh)"
  compdef _orbctl orbctl
  compdef _orbctl orb
fi
