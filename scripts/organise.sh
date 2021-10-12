#!/usr/bin/env bash
#  ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
# ||o |||r |||g |||a |||n |||i |||s |||e |||. |||s |||h ||
# ||__|||__|||__|||__|||__|||__|||__|||__|||__|||__|||__||
# |/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
#
# Created by Jonathan Bartlett
#
# Dependencies: exiftool
#
# Description: Copies files from IN_DIR to OUT_DIR and organises
# by the DateTimeOriginal tag in the exif data. If this tag isn't
# present the file is moved to OUT_DIR/unknown for manual inspection

VERSION=0.0.1
VERBOSE=false
DRY_RUN=false
IN_DIR=./import
OUT_DIR=./organised
CREATE_DIRS=true

show_help() {
printf "%s" "\
usage: organise.sh [-h] [--dry-run] [--verbose] \
[--in-dir \"path/to/dir\"] \
[--out-dir \"path/to/dir\"] \
[--version] [--no-create-dirs]
 ____ ____ ____ ____ ____ ____ ____ ____ ____ ____ ____
||o |||r |||g |||a |||n |||i |||s |||e |||. |||s |||h ||
||__|||__|||__|||__|||__|||__|||__|||__|||__|||__|||__||
|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|/__\|
Organise photos into Year/Month structure

optional arguments:
    -h, --help       show this help message and exit
    --dry-run        output what would happen if you were to run foo real
                     Note: Nothing gets moved or copied here
    --verbose        output the commands being executed
    --in-dir         set the input directory. (Default: ./import)
    --out-dir        set the output directory. (Default: ./organised)
    --version        output current version and exit
    --no-create-dirs don't create any directories
"
}

# Parse the arguments
options=$(getopt -o h --long in-dir:,out-dir:,dry-run,no-create-dirs,verbose,help,version -- "$@")
eval set -- "$options"

while true; do
    case "$1" in
        --dry-run)
            DRY_RUN=true
            ;;
        --verbose)
            VERBOSE=true
            ;;
        --no-create-dirs)
            CREATE_DIRS=false
            ;;
        -h|--help)
            show_help
            exit
            ;;
        --out-dir)
            shift;
            OUT_DIR=$1
            ;;
        --in-dir)
            shift;
            IN_DIR=$1
            ;;
        --version)
            echo $VERSION
            exit
            ;;
        --)
            shift
            break
            ;;
    esac
    shift
done

# Create Directories
createdirs() {
    mkdir -pv "$OUT_DIR/unknown"
}

moveCommand() {
    datetime=$(exiftool -d '%Y/%m' -datetimeoriginal -S -s "$1")
    sum=$(md5sum "$1")
    newname=$(echo "${sum%% *}.${1##*.}")
    if [[ -z "$datetime" ]]; then
        [ "$VERBOSE" = true ] && echo "Failed to extract datetime from image, moving to OUT_DIR/unknown"
        [ "$VERBOSE" = true] && echo "cp '$1' '$OUT_DIR/unknown/$newname'"
        [ "$DRY_RUN" = false ] && cp "$1" "$OUT_DIR/unknown/$newname"
    else
        [ "$VERBOSE" = true ] && echo "cp '$1' '$OUT_DIR/$datetime/$newname'"
        [[ ! -d "$OUT_DIR/$datetime" ]] && {
                if [[ "$CREATE_DIRS" == true ]]; then
                    [ "$VERBOSE" = true ] && echo "Creating directory '$OUT_DIR/$datetime/'"
                    mkdir -pv "$OUT_DIR/$datetime/"
                else
                    echo "WARNING: Directory $OUT_DIR/$datetime"\
                          "doesn't exist"
                fi
            }
        [ "$DRY_RUN" = false ] && cp "$1" "$OUT_DIR/$datetime/$newname"
    fi
}

# Extract Date
moveAndRenamePictures() {
    # Gets the date formatted for files from current dir
    while read -d '' filename; do
        moveCommand "${filename}" </dev/null
    done < <(find $IN_DIR -type f -regextype posix-extended \
        -regex ".*\.(jpe?g|JPE?G|png|PNG|gif|GIF|heic|HEIC)" \
        -print0)
}

displaySettings() {
printf "%s" "\
=======================================================================
CURRENT SETTINGS
=======================================================================
VERSION=$VERSION

CREATE_DIRS=$CREATE_DIRS
IN_DIR=$IN_DIR
OUT_DIR=$OUT_DIR

DRY_RUN=$DRY_RUN

VERBOSE=$VERBOSE
=======================================================================
"
}


main() {
    dependencies=(exiftool)
    for dependency in "${dependencies[@]}"; do
        type -p "$dependency" &>/dev/null || {
            echo "error: Could not find '${dependency}', is it" \
                    "installed?" >&2
            exit 1
        }
    done

    [ ! -d "$IN_DIR" ] && echo "'$IN_DIR' does not exist!"  && exit 1

    [ "$CREATE_DIRS" ] && createdirs
    [ "$VERBOSE" ] && displaySettings
    moveAndRenamePictures
}

main
