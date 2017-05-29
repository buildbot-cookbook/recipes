#!/bin/bash


function install_hook {
    # Install git hook in codebase to trigger buildbot tests.
    #
    # Usage: install_hook template project codebase
    #
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


function ci {
    # Commit in a git codebase to trigger buildbot tests
    #
    # Usage: ci codebase
    #
    # For example:
    #     codebase: libgreet
    #
    #     here   : /path/to/buildbot-cookbook/recipes
    #     root   : /path/to/buildbot-cookbook
    #     git_dir: /path/to/buildbot-cookbook/libgreet
    #     changes: /path/to/buildbot-cookbook/libgreet/changes

    codebase=$1

    here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    root=$(dirname $here)
    git_dir=$root/${codebase}

    echo $git_dir

    cd $git_dir
    date > changes
    git add changes
    git commit -m changes
    git push origin master
}
