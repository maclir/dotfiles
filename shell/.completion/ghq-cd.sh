#!/usr/bin/sh

__ghq_repositories () {
    local -a _repos
    _repos=( ${(@f)"$(_call_program repositories ghq list --unique)"} )
    _describe -t repositories Repositories _repos
}

_ghq_completion()
{
	_arguments -C \
	'1: :__ghq_repositories' \
	&& ret=0
}

compdef _ghq_completion ghq-cd
