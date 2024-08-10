cover() {
    t="/tmp/go-cover.$$.tmp"
    go test -coverprofile=$t $@ && go tool cover -html=$t && unlink $t
}

dedupe_path() {
    if [ -n "$PATH" ]; then
        old_PATH=$PATH:; PATH=
        while [ -n "$old_PATH" ]; do
            x=${old_PATH%%:*}
            case $PATH: in
                *:"$x":*) ;;
                *) PATH=$PATH:$x;;
            esac
            old_PATH=${old_PATH#*:}
        done
        PATH=${PATH#:}
        unset old_PATH x
    fi
}
