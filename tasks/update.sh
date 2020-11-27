#!/bin/sh

if [ ! -z "${PT_repo}" ]; then
    /usr/bin/luet repo update "${PT_repo}"
else
    /usr/bin/luet repo update
fi
