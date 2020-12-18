#!/bin/bash

print_usage() {
    cat <<eof
Usage: extract.sh <library file>
       e.g. extract.sh /lib/libgimp-2.0.so.0
eof
}

if [ -z "${1}" ]; then
    print_usage
    exit
fi

if [ ! -f "${1}" ]; then
    print_usage
    exit
fi

ScriptDir=$(readlink -f "${BASH_SOURCE%/*}")
SRC_DIR="${ScriptDir}/src"

[ -e "${SRC_DIR}" ] || mkdir "${SRC_DIR}"

C_FILE="${SRC_DIR}/${1##*/}.c"

[ -e "${C_FILE}" ]  && rm "${C_FILE}"

while IFS= read -r line; do
    #echo $line
    #num=$(  cut -d ' ' -f 1 <<<${line} )
    #value=$(cut -d ' ' -f 2 <<<${line} )
    #size=$( cut -d ' ' -f 3 <<<${line} )

    #bind=$( cut -d ' ' -f 5 <<<${line} )
    #vis=$(  cut -d ' ' -f 6 <<<${line} )
    ndx=$(  cut -d ' ' -f 7 <<<${line} )

    case "${ndx}" in
        'UND')
            continue
            ;;
    esac

    type=$( cut -d ' ' -f 4 <<<${line} )

    case "${type}" in
        "FUNC")
            name=$( cut -d ' ' -f 8 <<<${line} )
            case "${name}" in
                '_init'|'_fini')
                    continue
                    ;;
            esac

            echo "${name}"
            echo "void ${name}(void) {}" >> "${C_FILE}"
            ;;
    esac
done <<<$(readelf -Ws "${1}" | sed -e 's/^[[:space:]]*//g' -re 's/\ +/ /g')
