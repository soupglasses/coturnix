#!/usr/bin/env zsh

if ! tty -s || [ ! -n "$TERM" ] || [ "$TERM" = dumb ] || (( ! $+commands[grc] ))
then
  return
fi

cmds=(
  configure
  cvs
  df
  diff
  dig
  du
  free
  gmake
  ifconfig
  last
  ldap
  lsattr
  lsblk
  lsmod
  lsof
  lspci
  mount
  mtr
  netstat
  nmap
  ping
  ping6
  ps
  pv
  semanageboolean
  semanagefcontext
  semanageuser
  sensors
  ss
  sysctl
  traceroute
  traceroute6
  uptime
  wdiff
  whois
  iwconfig
);


# Set alias for available commands.
for cmd in $cmds ; do
  if (( $+commands[$cmd] )) ; then
    $cmd() {
      grc --colour=auto ${commands[$0]} "$@"
    }
  fi
done

# Clean up variables
unset cmds cmd
