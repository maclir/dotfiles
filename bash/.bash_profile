export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/git/bin
export PATH=$PATH:$HOME/Development/Android/sdk/platform-tools
export PATH=$PATH:$HOME/Development/Android/sdk/tools

source ~/.bash_scripts/git-completion.bash
source ~/.env.sh

export ANDROID_HOME="$HOME/Development/Android/sdk"
export ANDROID_LINT_INCLUDE_LDPI="true"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#Go
export GOPATH=$HOME/Go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Don't save duplicates in bash history
export HISTCONTROL=erasedups

# Add ssh agents
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s`
  ssh-add
fi

# Aliases
curl_circleci() {
    curl -v -X POST https://circleci.com/api/v1/project/Saltside/android/tree/$1?circle-token=${CIRCLECI_TOKEN}
}
alias circleci=curl_circleci

run_instance_ip_tmux() {
    ~/work/platform-utilities/instance-ips/./tmux-split-aws-ip $(~/work/platform-utilities/instance-ips/./aws-instance-ips $1)
}
alias instanceIpTmux=run_instance_ip_tmux
alias instanceIps=~/work/platform-utilities/instance-ips/./aws-instance-ips

