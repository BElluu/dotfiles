#!/bin/bash
# Displays all tmux sessions; highlights the current one
current=$(tmux display-message -p '#S' 2>/dev/null)
i=0
while IFS= read -r name; do
  i=$((i + 1))
  if [ "$name" = "$current" ]; then
    printf "#[fg=#1e1e2e,bg=#89b4fa,bold] %d.%s #[fg=#89b4fa,bg=#1e1e2e,nobold]" "$i" "$name"
  else
    printf "#[fg=#585b70,bg=#1e1e2e] %d.%s " "$i" "$name"
  fi
done < <(tmux ls -F '#{session_name}' 2>/dev/null)
