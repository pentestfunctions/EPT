# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


hacktricks() { brave-browser "https://book.hacktricks.xyz"; sleep 2; clear; }
youtube() { brave-browser "https:/youtube.com"; sleep 2; clear; }
tryhackme() { brave-browser "https://tryhackme.com"; sleep 2; clear; }
ipinfo() { brave-browser "https://shodan.io/"; brave-browser "https://search.censys.io/"; sleep 2; clear; }

process() {
  if [ -z "$1" ]; then
    echo "Please provide a process name to search for."
    return 1
  fi

  local pids=$(pgrep -f "$1")

  if [ -z "$pids" ]; then
    echo "No matching processes found."
    return 1
  fi

  ps -f -p $pids
}

hacknexus() {
    if [ "$#" -ne 2 ] || [ "$1" != "-u" ]; then
	echo "Usage: hacknexus -u <domain>"
	return 1
    fi
    dirsearch "$@"
}

escalation() {
    {
        printf "%-60s %s\n" "Task Description:" "Command:"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding files with the SUID bit set:" "find / -perm -u=s -type f 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"


	    printf "%-60s %s\n" "Exploiting unset path vulnerabilities:" "export PATH=\$(pwd):\$PATH"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding files with the SUID bit set:" "find / -perm -4000 -type f 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding files with the SGID bit set:" "find / -perm -2000 -type f 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding world-writable files:" "find / -perm -2 ! -type l -ls 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding world-writable directories:" "find / -perm -222 -type d 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Finding files with no owner:" "find / -nouser -ls 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Checking cron jobs:" "ls -la /etc/cron* /var/spool/cron/crontabs 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Checking /etc/passwd and /etc/shadow access:" "ls -l /etc/passwd /etc/shadow 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Find plaintext passwords/sensitive info in configs:" "find / -type f -name \"*.conf\" -exec grep -i password {} \; -print 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Checking writable configuration files:" "find /etc/ -writable -type f 2>/dev/null"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

        printf "%-60s %s\n" "Pkexec dual SSH switch (SUID):"
        printf "%-60s %s\n" "echo \$\$"
        printf "%-60s %s\n" "pkttyagent --process <PID>"
        printf "%-60s %s\n" "pkexec '/bin/bash'"
        printf '%s\n' "------------------------------------------------------------ -----------------------------------------"

    } | lolcat
}


alias cls='clear'
alias python='python3'
alias ifconfig='/sbin/ifconfig'
alias zip2john='/usr/sbin/zip2john'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias wget="wget -U 'noleak'"
alias curl="curl --user-agent 'noleak'"
alias neofetch="neofetch | lolcat"
alias whoami="whoami | lolcat"
alias anonftp='clear; target=$(zenity --entry --text "What is your target?" --title "Set Target Variable" 2>/dev/null) && echo "You have chosen: $target" && mkdir -p "$target" && cd "$target" && wget -m --no-passive ftp://anonymous:anonymous@"$target" && ls -lah'
alias portscan='clear; target=$(zenity --entry --text "What is your target?" --title "Set Target Variable" 2>/dev/null) && echo "You have chosen: $target" && rustscan --accessible --ulimit 5000 -t 20000 -a $target -- -A -sC -sV -Pn'
