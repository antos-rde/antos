#!/bin/bash
set -e

TARGET=$1

[[ -z "$TARGET" ]] && echo "No taget provided" && exit 1
[[ ! -d "$TARGET" ]] && echo "Target is not a directory" && exit 1

DIRS=$(ls "$TARGET")
EXIT_CODE=0

BLUE="\e[1;34m"
NC="\e[0m"
CERR="\e[1;31m"
COK="\e[1;32m"
GRAY="\e[90m"
YELLOW="\e[93m"

check_file() {
    FILE=$1
    LD=$2
    echo -n -e "${YELLOW}Checking $FILE:....................${NC}"
    if ! file "$(realpath "$FILE")" | grep "$LD" > /dev/null ; then
        echo -e "${CERR}FAILED${NC}"
        EXIT_CODE=1
        echo -e -n "${GRAY}"
        file "$(realpath "$FILE")"
        echo -e "${NC}"
    else
        echo -e  "${COK}OK${NC}"
        echo -e -n "${GRAY}"
        readelf -d "$FILE" | grep NEEDED || true
        echo -e "${NC}"
    fi
}

check() {
    ARCH=$1
    LD=$2
    ROOT=$TARGET/$ARCH/opt/www
    echo -e "${BLUE}Checking: $TARGET/$ARCH${NC}"
    # check bin directory
    for file in "$ROOT"/bin/*; do
        check_file "$file" "$LD"
    done
    # check for libraries
    libs=$(find "$ROOT"/lib/ -name "*.so*")
    for lib in $libs; do
        check_file "$lib" "$LD"
    done
}

for dir in $DIRS; do
    case $dir in
    arm64)
        check "$dir" "ARM aarch64"
        ;;
    arm)
        check "$dir" "ARM, EABI"
        ;;
    amd64)
        check "$dir" "x86-64"
        ;;
    *)
        echo "Unkown architecture: $dir, ignore it"
        ;;
esac
done
exit $EXIT_CODE