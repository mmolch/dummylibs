#!/bin/bash

ScriptDir=$(readlink -f "${BASH_SOURCE%/*}")
LIB_DIR="${ScriptDir}/lib"

SONAME="${1##*/}"
SONAME="${SONAME%.c}"
C_FILE="src/${SONAME}.c"
SO_FILE="lib/dummy-${SONAME}"

echo "gcc -shared -O0 -s \"-Wl,--soname=${SONAME}\" -o \"${SO_FILE}\" \"${C_FILE}\""
gcc -shared -fPIC -O0 -s "-Wl,--soname=${SONAME}" -o "${SO_FILE}" "${C_FILE}"
