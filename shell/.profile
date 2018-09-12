export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/git/bin
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

source ~/.env.sh

export ANDROID_LINT_INCLUDE_LDPI="true"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export NVM_DIR="$HOME/.nvm"
source /usr/local/opt/nvm/nvm.sh

#Go
export GOPATH=$HOME/go-workspace
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

#FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Don't save duplicates in bash history
export HISTCONTROL=erasedups

# Add ssh agents
if [ -z "$SSH_AUTH_SOCK" ] ; then
	eval `ssh-agent -s`
	ssh-add
fi

# gcloud

source ~/.google-cloud-sdk/completion.zsh.inc
source ~/.google-cloud-sdk/path.zsh.inc

# Aliases
curl_jira() {
	curl -s -X GET -H "Authorization: Basic ${JIRA_TOKEN}" -H "Content-Type: application/json" "https://frontiercargroup.atlassian.net/rest/api/2/search?jql=assignee=currentuser()+AND+status!=\"open\"+AND+status!=\"closed\"+AND+status!=\"Backlog\"+AND+status!=\"Live\"+AND+status!=\"Done\"+ORDER+BY+status+ASC&fields=summary,status" | jq '.issues[] | .key + " (" + .fields.status.name + "): " + .fields.summary'
}
alias jira=curl_jira

curl_circleci() {
	curl -v -X POST https://circleci.com/api/v1/project/Saltside/android/tree/$1?circle-token=${CIRCLECI_TOKEN}
}
alias circleci=curl_circleci

run_instance_ip_tmux() {
	~/work/platform-utilities/instance-ips/./tmux-split-aws-ip $(~/work/platform-utilities/instance-ips/./aws-instance-ips $1)
}
alias instanceIpTmux=run_instance_ip_tmux
alias instanceIps=~/work/platform-utilities/instance-ips/./aws-instance-ips

run_open_pull_request() {
	git push -u origin $(git rev-parse --abbrev-ref HEAD)
	curl -i -u maclir:$GITHUB_TOKEN \
		-H "Accept: application/vnd.github.v3+json" \
		-H "Content-Type: application/json" \
		https://api.github.com/repos/saltside/android/pulls \
		-X POST -d @- << EOF
{
	"title": "${2}",
	"body": "[${3}](https://saltside.atlassian.net/browse/${3})",
	"head": "$(git rev-parse --abbrev-ref HEAD)",
	"base": "${1}"
}
EOF
}
alias pull_request=run_open_pull_request


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
