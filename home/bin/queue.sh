#!/bin/bash
#
# This script encapsulates the functionality of a queue. It requires there to be
# an input file with the data in the queue being separated on different lines.
#

INPUT=queue.txt
OUTPUT=trash.txt
CMD=/usr/bin/vlc

if [ ! -f "$INPUT" ]; then
    touch "$INPUT"
fi

#
# poll() removes the top line from $INPUT and appends it to the $OUTPUT file
#
poll() {
    if [ ! -f "$CMD" ]; then
        echo "$CMD does not exist" 1>&2
        exit 1
    fi
    if [ ! -x "$CMD" ]; then
        echo "$CMD is not executable" 1>&2
        exit 1
    fi
    head -1 "$INPUT" >>"$OUTPUT" && sed -i '1d' "$INPUT"
    ENTRY="$(tail -1 "$OUTPUT")"
    $("$CMD" "$ENTRY")
}

#
# offer() appends the given arguments to the $INPUT file
#
offer() {
    for arg in ${@:2}; do
        if [ -f "$arg" ]; then
            echo "$arg"
            echo "$arg" >>"$INPUT"
        fi
    done
}

#
# peek() prints the next entry in the queue
#
peek() {
    head -1 "$INPUT"
}

#
# random() passes a random line from $INPUT to $CMD
#
random() {
    if [ ! -f "$CMD" ]; then
        echo "$CMD does not exist" 1>&2
        exit 1
    fi
    if [ ! -x "$CMD" ]; then
        echo "$CMD is not executable" 1>&2
        exit 1
    fi

    COUNT=$(cat "$INPUT" | wc -l)
    if [ "$COUNT" -lt 1 ]; then
        exit 0
    fi
    RANDOM_LINE_NO=$((($RANDOM % $COUNT) + 1))

    RANDOM_LINE=$(sed -n ''"$RANDOM_LINE_NO"'p' "$INPUT")
    $("$CMD" "$RANDOM_LINE")
}

print_help() {
    cat <<EOF
USAGE:
  queue COMMAND

COMMANDS:
  poll
    removes the top line from \$INPUT and appends it to the \$OUTPUT file
  offer
    appends the given arguments to the \$INPUT file
  peek
    prints the next entry in the queue
  random
    passes a random line from \$INPUT to \$CMD

EXAMPLES:
  To offer a list of files to the queue:

    find /path/to/files | xargs ./queue.sh offer
EOF
}

if [ "$1" == "poll" ]; then
    poll
elif [ "$1" == "offer" ]; then
    offer $*
elif [ "$1" == "peek" ]; then
    peek
elif [ "$1" == "random" ]; then
    random
else
    print_help
    exit 1
fi
