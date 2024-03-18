#!/usr/bin/env bash

declare PIDFILE="/tmp/.yank-listener.pid"

cleanup() {
    echo "removing pid file '${PIDFILE}'"
    [[ -f "${PIDFILE}" ]] && rm -f "${PIDFILE}"
}


main() {
    local -r port="$1"

    if [[ -f "${PIDFILE}" ]]; then
        exit 0
    fi

    echo $$ >${PIDFILE}
    if [[ $? -ne 0 ]]; then
        echo "failed creating pid file '${PIDFILE}'" >&2
        exit 1
    fi

    trap cleanup EXIT
    while true; do
        nc -l "${port:-19988}" | pbcopy
    done
}

main "$@"
