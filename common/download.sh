#!/bin/bash

if [[ "$VER" != "" ]];then
    set -- $VER  $@

fi

echo "$0 input params are $@"


if [[ " $@ " != *"--no-gui"* ]] &&  [[ "$0" == "bash" ]]; then
    echo "This script is deprecated! Please use the following command"
    echo ""
    echo "bash <(curl https://i.hiddify.com/$1)"
    echo ""
    exit 1
fi

echo "Downloading '$@'"

if [[ " $@ " == *" v8 "* ]]; then
    sudo bash -c "$(curl -sLfo- https://raw.githubusercontent.com/zzxym/Hiddify-Manager/main/common/download_install.sh)"
    exit $?
fi


mkdir -p /tmp/hiddify/
chmod 600 /tmp/hiddify/
rm -rf /tmp/hiddify/*


branch="${1:-release}"

echo "Detecting branch/tag: $branch"

if [[ "$branch" == v* ]]; then
    # If input starts with 'v', try both branch and tag paths
    branch_url="https://raw.githubusercontent.com/zzxym/Hiddify-Manager/refs/heads/$branch/"
    tag_url="https://raw.githubusercontent.com/zzxym/Hiddify-Manager/refs/tags/$branch/"
    
    # Test branch URL first
    echo "Testing branch URL: $branch_url"
    if curl -sL -o /dev/null -w "%{http_code}" $branch_url/common/utils.sh | grep -q "200"; then
        base_url="$branch_url"
        echo "Using branch URL"
    else
        # Test tag URL
        echo "Testing tag URL: $tag_url"
        if curl -sL -o /dev/null -w "%{http_code}" $tag_url/common/utils.sh | grep -q "200"; then
            base_url="$tag_url"
            echo "Using tag URL"
        else
            echo "Error: Neither branch nor tag found for $branch"
            exit 1
        fi
    fi
elif [[ "$branch" == "beta" ]]; then
    # If input is 'beta', use beta branch
    base_url="https://raw.githubusercontent.com/zzxym/Hiddify-Manager/refs/heads/beta/"
elif [[ "$branch" == "dev" ]]; then
    # If input is 'dev', use dev branch
    base_url="https://raw.githubusercontent.com/zzxym/Hiddify-Manager/refs/heads/dev/"
else
    # Otherwise, use main branch
    base_url="https://raw.githubusercontent.com/zzxym/Hiddify-Manager/refs/heads/main/"
fi

echo "Using base URL: $base_url"
curl -sL -o /tmp/hiddify/hiddify_installer.sh $base_url/common/hiddify_installer.sh
curl -sL -o /tmp/hiddify/utils.sh $base_url/common/utils.sh
chmod 700 /tmp/hiddify/*

/tmp/hiddify/hiddify_installer.sh $@