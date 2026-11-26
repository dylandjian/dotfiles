#!/usr/bin/env bash
# tmux-resurrect save command strategy: the pane's newest non-shell child.
# The stock ps/pgrep strategies take the first child, which is the async
# prompt's `-zsh` worker, so nvim and friends were never restored.

PANE_PID="$1"
[ -z "$PANE_PID" ] && exit 0

ps -ao "ppid=,pid=,args=" |
	awk -v ppid="$PANE_PID" '$1 == ppid {
		$1 = ""; $2 = ""; sub(/^ +/, "")
		if ($0 !~ /^-?(zsh|bash|sh)( |$)/) cmd = $0
	} END { if (cmd != "") print cmd }'
