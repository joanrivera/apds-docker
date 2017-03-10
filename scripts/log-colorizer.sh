#!/bin/bash

DEFAULT=$(echo -e '\e[39m')
BDEFAULT=$(echo -e '\e[49m')
RED=$(echo -e '\e[31m')
BRED=$(echo -e '\e[41m')
BLUE=$(echo -e '\e[34m')
BBLUE=$(echo -e '\e[44m')
CYAN=$(echo -e '\e[36m')
BCYAN=$(echo -e '\e[46m')
YELLOW=$(echo -e '\e[33m')
BYELLOW=$(echo -e '\e[43m')
BLACK=$(echo -e '\e[30m')
BBLACK=$(echo -e '\e[40m')
LIGHTGRAY=$(echo -e '\e[37m')
GRAY=$(echo -e '\e[90m')
BGRAY=$(echo -e '\e[100m')
BLIGHTGRAY=$(echo -e '\e[47m')
WHITE=$(echo -e '\e[97m')
BWHITE=$(echo -e '\e[107m')

REVERSED=$(echo -e '\e[7m')
DREVERSED=$(echo -e '\e[27m')
UNDERLINED=$(echo -e '\e[4m')
DUNDERLINED=$(echo -e '\e[24m')


while read line
do
    echo $line | \
        ssed -R "s/^\[.*?\]/${BLACK}${GRAY}&${DEFAULT}${BDEFAULT}/I" | \
        ssed -R "s/error|exception/${WHITE}${BRED}&${DEFAULT}${BDEFAULT}/Ig" | \
        ssed -R "s/warning/${BLACK}${BYELLOW}&${DEFAULT}${BDEFAULT}/Ig" | \
        ssed -R "s/notice/${YELLOW}&${DEFAULT}/Ig" | \
        ssed -R "s/\/[a-zA-Z0-9\/]+.php:[0-9]+$/${CYAN}&${DEFAULT}/"
done < "${1:-/dev/stdin}"

# [ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
# ssed -R "s/^\[.*?\]/${REVERSED}&${DREVERSED}/I" $input | \
#     ssed -R "s/error|exception/${WHITE}${BRED}&${DEFAULT}${BDEFAULT}/Ig" | \
#     ssed -R "s/warning/${BLACK}${BYELLOW}&${DEFAULT}${BDEFAULT}/Ig" | \
#     ssed -R "s/notice/${YELLOW}&${DEFAULT}/Ig"
