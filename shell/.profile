if [ -x /opt/homebrew/bin/brew ]; then
	export HOMEBREW_PREFIX=/opt/homebrew
elif [ -x /usr/local/bin/brew ]; then
	export HOMEBREW_PREFIX=/usr/local
fi
export PATH="$HOMEBREW_PREFIX/opt/python/libexec/bin:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

source ~/.env.sh

export ANDROID_LINT_INCLUDE_LDPI="true"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#Go
export GOPATH=$HOME/go-workspace
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export GO111MODULE=on

#FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

#Use android studio java version
export JAVA_HOME=/Applications/Android\ Studio.app/Contents/jre/Contents/Home/

# Don't save duplicates in bash history
export HISTCONTROL=erasedups

# Add ssh agents
if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add -K
fi

# gcloud

source ~/google-cloud-sdk/completion.zsh.inc
source ~/google-cloud-sdk/path.zsh.inc

# Aliases
login_application() {
	adb shell input keyboard text "${1}" && adb shell input keyevent 61 && adb shell input text "${2}" && adb shell input keyevent 66
}
alias flogin=login_application

take_adb_screenshot() {
	adb shell screencap -p /sdcard/${1}.png
	adb pull /sdcard/${1}.png ~/Desktop/adb-screenshots/${1}.png
	adb shell rm /sdcard/${1}.png
}
alias adb_screenshot=take_adb_screenshot

watch_command() {
	fswatch -o . | xargs -n1 -I % sh -c "
	echo \"----\"
	$@
	if [ $? != 0 ]
	then
		echo \"Success :)\"
	else
		echo \"Failed :'(\"
	fi
	"
}
alias follow=watch_command

ghq-cd () {
    if [ -n "$1" ]; then
        dir="$(ghq list --full-path --exact "$1")"
        if [ -z "$dir" ]; then
            echo "no directroies found for '$1'"
            return 1
        fi
        cd "$dir"
        return
    fi
    echo 'usage: ghq-cd $repo'
    return 1
}

export BASH_COMPLETION_COMPAT_DIR="$HOMEBREW_PREFIX/etc/bash_completion.d"
[[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
