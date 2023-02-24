export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8

gui ()
{
  if [ $# -gt 0 ] ; then
    ($@ &) &>/dev/null
  else
    echo "missing argument"
  fi
}

function x {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: x <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       x <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.bin|*.img|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}


hstats() {
	history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n10
}



ver () {
  source /etc/os-release
  echo -e "--------------------------System Information-------------------------"
  echo -e "OS:\t\t$PRETTY_NAME"
  echo -e "Architecture:\t"$(vserver=$(lscpu | grep Hypervisor | wc -l); [ $vserver -gt 0 ] && echo "Virtual " || echo "Physical ")$(lscpu |awk '/Arch/ {print $2}')
  echo -e "Processor:\t"`awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//'`
  echo -e "Kernel:\t\t"`uname -o` `uname -r`
  echo -e "Kernel date:\t"`uname -v`
  echo -e "Timestamp:\t"`date +"%Y.%m.%d - %T %Z"`
  echo -e "Uptime:\t\t"`uptime | grep -Eo '^[^,]+' | sed 's/^ *//'`
  echo -e "Hostname:\t"`cat /etc/hostname`
  echo -e "Active User:\t"`whoami`
  echo -e "--------------------------Network Information------------------------"
  echo -e "MAC:\t\t"`ip -br link | awk '/UP / {print $1" "$3}'`
  echo -e "System IP:\t"`ip -br a | awk '/UP/ {print $1" "$3" "$4}'`
  echo -e "Public IP:\t"`curl -s ipinfo.io/ip`
  echo -e "Gateway:\t"`ip neighbor | awk '{print $1}'`
  echo -e "---------------------------CPU/Memory Usage--------------------------"
  echo -e "Memory Usage:\t"`free | awk '/Mem/{printf("%.2f%"), $3/$2*100}'`"\t"`free -h | awk '/Mem/ {print $3}'`
  echo -e "Swap Usage:\t"`free | awk '/Swap/{printf("%.2f%"), $3/$2*100}'`"\t"`free -h | awk '/Swap/ {print $3}'`
  echo -e "CPU Usage:\t"`cat /proc/stat | awk '/cpu /{printf("%.2f%"), 100*(1-$5/($2+$3+$4+$5+$6+$7+$8+$9+$10))}'`
  echo -e "---------------------------------------------------------------------"
  echo ""
}

lscolors (){
  for theme in $(vivid themes); do
      echo "Theme: $theme"
      LS_COLORS=$(vivid generate $theme) ls -CFA
      echo
  done
}

lscolor (){
  export LS_COLORS="$(vivid generate $1)"
}

dl() {
  [ -z "$1" ] && echo "download URL sage: dl <url>" && return 1
  [ -z "$2" ] && wget "$1" -O "$(basename "$1")" || wget -O "$2" "$1"
}

mcd() {
  [ -z "$1" ] && echo "make and change to dir Usage: mcd <dir>" && return 1
  mkdir -p $1 && cd $1
}

f() {
  [ -z "$1" ] && echo "find file: f [dir] <filename>" && return 1
  [ -z "$2" ] && find . -name "$1" || find "$1" -name "$2"
}

fin() {
  [ -z "$1" ] && echo "find in file: fin [file or dir] <string>" && return 1
  [ -z "$2" ] && grep -rnw * -e "$1" || grep -rnw "$1" -e "$2"
}

safepath() { 
    echo $PATH | sed -e 's,/mnt[^:]*,,g' | sed -r 's/:+/:/g'
}

export SAFEPATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export UPX="--lzma --best"
git config --global core.pager "less -FRSX"

## ALIAS
# DEBIAN/UBUNTU
alias up='apt list --upgradable; sudo -E apt update && sudo apt upgrade -y && sudo apt autoremove --purge -y'
alias i='sudo -E apt install -y'
alias ..='cd ..'
alias cd..='cd ..'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias l='ls -CFA  --color=auto'
alias d='ls -CFA  --color=auto'
alias ll='ls -alsF --color=auto'
alias la='ls -A --color=auto'
alias md='mkdir'
alias su='sudo -i'
alias s='sudo -E'
alias now='date +"%T"'
alias today='date +"%Y.%m.%d"'
alias path='echo -e ${PATH//:/\\n}'
alias reboot='sudo /sbin/reboot'
alias shutdown='wsl.exe --shutdown'
alias shutd='wsl.exe --shutdown'
alias df='df -H'
alias du1='/usr/bin/du -hd 1'
alias meminfo='free -m -l -t'
alias cpuinfo='lscpu'
alias chexe='chmod +x'
alias dockersize='sudo -E du -hd 1 /var/lib/docker/'
alias dockerclean='docker stop $(docker ps -a -q) -t 0 ; sudo -E docker system prune -a'
alias donde='which'
alias profil='micro ~/.profile ; source ~/.profile'
alias rc='micro ~/.bashrc ; source ~/.bashrc'
alias wsl='wsl.exe'
alias start='explorer.exe'
alias untar='tar -zxvf '
alias ipi='hostname -I'
alias ipe='echo $(curl -s ipinfo.io/ip)'
alias www='python3 -m http.server'
alias du='ncdu'
alias top='htop'
alias nautilus='gui nautilus'
alias cls='reset;ver'
alias ipconfig='ip address'
alias ifconfig='ip address'
alias entropy='binwalk -E'
alias mc='mc -P "/tmp/mc-$USER/mc.pwd"; cd `cat /tmp/mc-$USER/mc.pwd`; yes | rm -f /tmp/mc-$USER/mc.pwd'
alias mk='PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin make'

ver

# set oh-my-posh prompt
eval "$(oh-my-posh init $(oh-my-posh get shell))"
[[ $(oh-my-posh get shell) == 'zsh' ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh || true