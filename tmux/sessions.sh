#!/bin/bash
# status-left: bieżąca sesja + licznik sesji.
# Pełna lista sesji jest pod C-a o (popup z sesh) — nie mieści się w barze
# przy kilkunastu sesjach, dlatego tu tylko kontekst "gdzie jestem".

current=$(tmux display-message -p '#S' 2>/dev/null) || exit 0
[ -z "$current" ] && exit 0

total=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | wc -l)
idx=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | grep -nxF "$current" | cut -d: -f1)
[ -z "$idx" ] && idx=1

printf "#[fg=#1e1e2e,bg=#89b4fa,bold] %s #[fg=#89b4fa,bg=#313244,nobold]#[fg=#a6adc8,bg=#313244] %s/%s #[fg=#313244,bg=#1e1e2e]" \
  "$current" "$idx" "$total"
