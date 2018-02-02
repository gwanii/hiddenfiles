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

alias p2 "python2"
alias p3 "python3"

alias py "ptpython2"
alias py3 "ptpython3"
alias ipy "ptipython2"
alias ipy3 "ptipython3"

alias els "etcdctl ls --sort -r -p"
alias egt "etcdctl get"

# virtualfish
# ensure that you load virtualfish after those modifications
eval (python -m virtualfish compat_aliases projects global_requirements)

# autojump
[ -f /usr/share/autojump/autojump.fish ]; and . /usr/share/autojump/autojump.fish

# environment variable
set -gx EDITOR /usr/bin/vim
#set -gx GOROOT /usr/local/go
#set -gx GOBIN /usr/local/go/bin
set -gx GOPATH ~/GO
set -gx PATH $GOBIN $GOPATH/bin $PATH

set -gx JAVA_HOME /usr/lib/jvm/java-8-oracle
set -gx JRE_HOME $JAVA_HOME/jre
set -gx CLASSPATH ".:$JAVA_HOME/lib:$JRE_HOME/lib"
set -gx PATH $JAVA_HOME/bin $PATH

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

# emacs terminal
alias em "emacs -nw"

# ll sort by time
alias ll "ls -tl"
