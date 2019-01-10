# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish


#############
#   EXTRA   #
#############

# some alias
alias v "vim"

alias tmr "tmuxinator"
alias tm "tmux"

alias gt "git"
# checkout to the first commit for reading source code easily
alias ginit "gt co -b init (gt lg| tail -5|awk '/^commit/{print $2}')"

alias vinit "virtualenv .venv; and source .venv/bin/activate.fish"
alias pipr "pip install -r requirements.txt"

alias p "python3"
alias p2 "python2"

alias py "ptpython3"
alias py2 "ptpython2"
alias ipy "ptipython3"
alias ipy2 "ptipython2"

alias els "etcdctl ls --sort -r -p"
alias egt "etcdctl get"

alias diff "colordiff"

# virtualfish
# ensure that you load virtualfish after those modifications
eval (python -m virtualfish compat_aliases projects global_requirements)

# autojump
[ -f /usr/share/autojump/autojump.fish ]; and . /usr/share/autojump/autojump.fish

# environment variable
set -gx EDITOR /usr/bin/vim
#set -gx GOROOT /usr/local/go
set -gx GOPATH ~/go
set -gx GOBIN $GOPATH/bin
set -gx GOSRC $GOPATH/src
set -gx GOPKG $GOPATH/pkg
set -gx PATH $GOBIN $PATH

set -gx JAVA_HOME /usr/lib/jvm/java-8-oracle
set -gx JRE_HOME $JAVA_HOME/jre
set -gx CLASSPATH ".:$JAVA_HOME/lib:$JRE_HOME/lib"
set -gx PATH $JAVA_HOME/bin $PATH

set -gx PATH $HOME/.cargo/bin $PATH

# fuck the GFW with XX-Net
function fuck --description "fuck the gfw"
    export http_proxy=http://127.0.0.1:8087
    export https_proxy=http://127.0.0.1:8087
    export GIT_SSL_NO_VERIFY=1
end

# unfuck the GFW with XX-Net
function unfuck --description "unfuck the gfw"
    set -x http_proxy
    set -x https_proxy
    set -x GIT_SSL_NO_VERIFY
end

# docker scripts
function dcd --description "dcd <container>"
    docker ps -a | grep $argv[1] | awk '{print $1}' | xargs docker rm -f
end

function did --description "did <image>"
    docker images | grep $argv[1] | awk '{print $3}' | xargs docker rmi -f
end

# windows remote desktop
function rdp --description "remote desktop access to windows"
    rdesktop -u wtf -p wtf -g 80% -PK 127.0.0.1 # if need full-screen, add "-f"
end

# filezilla
function filez --description "quick login ftp"
    filezilla ftp://wtf:wtf@127.0.0.1:21/ -a /home/wtf
end

function mountwin --description "mount windows shared directory"
    mkdir -p ~/WIN
    sudo mount -t cifs -o "username=wtf,password=wtf" //192.168.1.1/wtf/ ~/WIN
end

function umountwin --description "umount windows shared directory"
    sudo umount ~/WIN
end

# emacs terminal
alias em "emacs -nw"

# ll sort by time
alias ll "ls -tl"
alias ll1 "ll|head -n2"

# tarz
function tarz --description "simplify tar zcvf"
    tar zcvf $argv[1].tar.gz $argv[1]
end

# ps list by process name
function pslist
    ps -fp (pgrep $argv[1])
end

# tail -f
function tailf
    tail -n0 -f $argv[1]
end

# cross the GFW by ssh
function cross
    sudo systemctl restart polipo
    set crossPID (lsof -i:8765|grep LISTEN|head -n1|awk '{print $2}')
    test -n crossPID; and kill -9 "$crossPID"
    ssh -p 22222 -fND localhost:8765 root@x.x.x.x
end


# log
function log
    switch $argv[1]
        case info
            echo $argv[2]
        case error
            set_color red; echo -n "[Error]: "; set_color normal; echo $argv[2]
        case done
            set_color green; echo -n "[Success]: "; set_color normal; echo $argv[2]
    end
end

# global substitute appeared string
function gsub
    # example: gsub "hello" "world"
    if test -n $argv[3]
        set search_dir "$PWD"
    else
        set search_dir $argv[3]
    end
    log info "- Substitute \"$argv[1]\" with \"$argv[2]\" at directory $search_dir"
    set result (sed -i -e "s/$argv[1]/$argv[2]/g" (rg -wl -- $argv[1] "$search_dir") 2>&1)
    if test -z "$result"
        log done
    else
        log error "$result"
    end
end

# global delete appeared string
function gdel
    # example: gsdel "hello"
    if test -n $argv[2]
        set search_dir "$PWD"
    else
        set search_dir $argv[2]
    end
    log info "- Delete line where \"$argv[1]\" appears at directory $search_dir"
    set result (sed -i -e "/$argv[1]/d" (rg -wl $argv[1] "$search_dir") 2>&1)
    if test -z "$result"
        log done
    else
        log error "$result"
    end
end

# openstack
function showhyper
    nova show $argv[1]|grep -E "hypervisor|instance"|awk '{print $4}'
end
# get console of vm
function console
    set ip $argv[1]
    set uuid (nova list|grep "$ip"|awk '{print $2}')
    set hyper (showhyper "$uuid")
    set host (echo "$hyper" | awk '{print $1}')
    set vm (echo "$hyper" | awk '{print $2}')
    ssh -t "$host" virsh console "$vm"
end

# jenkins-cli
alias jk "java -jar /home/wtf/j/jenkins-cli.jar -s http://192.168.9.105:8080/ -auth wtf:wtf"

# openresty
function xconf
    vi + /etc/openresty/nginx.conf
end
function agentzh
    sudo systemctl restart openresty
end
