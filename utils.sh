#!/bin/bash


function install_hook {
    # Usage: install_hook template project codebase

    # For example:
    #     template: /path/to/buildbot-cookbook/recipes/post-receive
    #     project : hello
    #     codebase: libgreet
    #
    #     here    : /path/to/buildbot-cookbook/recipes
    #     root    : /path/to/buildbot-cookbook
    #     fn      : post-receive
    #     hook_dir: /path/to/buildbot-cookbook/libgreet.git/hooks

    template=$1
    project=$2
    codebase=$3

    here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    root=$(dirname $here)
    fn=$(basename $template)

    hook_dir=$root/${codebase}.git/hooks

    sed -e s/PROJECT/$project/ \
        -e s/CODEBASE/$codebase/ \
        $template \
        > $hook_dir/$fn
}


