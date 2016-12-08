export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/git/bin
export PATH=$PATH:$HOME/Development/Android/sdk/platform-tools
export PATH=$PATH:$HOME/Development/Android/sdk/tools

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
curl_jira() {
	curl -s -X GET -H "Authorization: Basic ${JIRA_TOKEN}" -H "Content-Type: application/json" "https://saltside.atlassian.net/rest/api/2/search?jql=assignee=currentuser()+AND+status!=\"open\"+AND+status!=\"closed\"+AND+status!=\"To+Do\"+AND+status!=\"Done\"&fields=summary" | jq '.issues[] | .key + ": " + .fields.summary'
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
alias sandbox="saltside-workstation sandbox"
