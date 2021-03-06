alias ls='ls --color=auto'
if [ -z "$BASH_EXECUTION_STRING" ]; then exec fish; fi
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]; then exec fish; fi

