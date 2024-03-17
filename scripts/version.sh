#! /bin/bash
get_version_lua_socket() {
    file=$1
    dir=$(dirname "$(realpath "$file")")
    line=$(grep -e "^## \[.*"  "$file" | head -1)
    ref=$(cd "$dir" && git rev-parse  --short HEAD )
    regex="##\s+\[\s*v([0-9\.]+)\s*\].*"
    name="luasocket"
    if [[ $line =~ $regex ]]; then
        version="${BASH_REMATCH[1]}"
        echo "    Project name: $name VERSION: $version REF: $ref"
        cat << EOF >> /tmp/versions.json
    "$name":
    {
        "version": "$version",
        "ref": "$ref"
    },
EOF
    else
        echo "Unable to find version on $file"
        exit 1
    fi
}

get_version_lua_sec() {
    file=$1
    dir=$(dirname "$(realpath "$file")")
    line=$(grep -e "^LuaSec"  $file | head -1)
    ref=$(cd "$dir" && git rev-parse  --short HEAD )
    regex="LuaSec\s+([0-9\.]+).*"
    name="luasec"
    if [[ $line =~ $regex ]]; then
        version="${BASH_REMATCH[1]}"
        echo "    Project name: $name VERSION: $version REF: $ref"
        cat << EOF >> /tmp/versions.json
    "$name":
    {
        "version": "$version",
        "ref": "$ref"
    },
EOF
    else
        echo "Unable to find version on $file"
        exit 1
    fi
}

get_version_rust() {
    file=$1
    dir=$(dirname "$(realpath "$file")")
    line=$(grep -e "^version\s*=.*" "$file")
    ref=$(cd "$dir" && git rev-parse  --short HEAD )
    regex="\s*version\s*=\s*\"([^\"]*)\".*"
    if [[ $line =~ $regex ]]; then
        version="${BASH_REMATCH[1]}"
    else
        echo "Unable to find version on $file"
        exit 1
    fi
    line=$(grep -e "^name\s*=.*" "$file")
    regex="\s*name\s*=\s*\"([^\"]*)\".*"
    if [[ $line =~ $regex ]]; then
        name="${BASH_REMATCH[1]}"
    else
        echo "Unable to find name on $file"
        exit 1
    fi
    echo "    Project name: $name VERSION: $version REF: $ref"
    cat << EOF >> /tmp/versions.json
    "$name":
    {
        "version": "$version",
        "ref": "$ref"
    },
EOF
}

get_version_autotool() {
    file=$1
    dir=$(dirname "$(realpath "$file")")
    line="$(grep "AC_INIT" "$file")"
    regex="\s*AC_INIT\s*\(\s*\[\s*([a-zA-Z0-9_\-]*)\s*\]\s*,\s*\[\s*([a-zA-Z0-9\._\-]*).*"
    if [[ $line =~ $regex ]]; then
        name="${BASH_REMATCH[1]}"
        version="${BASH_REMATCH[2]}"
        ref=$(cd "$dir" && git rev-parse  --short HEAD )
        echo "    Project name: $name VERSION: $version REF: $ref"
        cat << EOF >> /tmp/versions.json
    "$name":
    {
        "version": "$version",
        "ref": "$ref"
    },
EOF
    else
        echo "Unable to find version on $file"
        exit 1
    fi
}

get_version() {
    dir=$1
    echo "getting version in $dir/configure.ac"
    if [ -e "$dir/configure.ac" ]; then
        get_version_autotool "$dir/configure.ac"
        return 0
    fi
    if [ -e  "$dir/Cargo.toml" ]; then
        get_version_rust "$dir/Cargo.toml"
        return 0
    fi
    if [ "$dir" = "antd/luasec" ]; then
        get_version_lua_sec "$dir/CHANGELOG"
        return 0
    fi
    if [ "$dir" = "antd/luasocket" ]; then
        get_version_lua_socket "$dir/CHANGELOG.md"
        return 0
    fi
    echo "Unknown version for project $dir"
    exit 1
}

DESTDIR=$1

if [ -z "$DESTDIR" ]; then
    echo "Please specify DESTDIR as parameter"
    exit 1
fi
mkdir -p "$DESTDIR"

echo "{" > /tmp/versions.json

for prj in antd/* ; do
    get_version "$prj"
done
sed -i '$ s/.$//' /tmp/versions.json
echo "}" >> /tmp/versions.json
install -m 0644 /tmp/versions.json "$DESTDIR"
echo "DONE"