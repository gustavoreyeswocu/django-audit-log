if [ "$#" -ne 1 ]; then
    echo "Missing part argument (major, minor or patch)"; exit
fi

if [ "$1" != "major" ] && [ "$1" != "minor" ] && [ "$1" != "patch" ]
  then echo First arg must be major, minor or patch; exit
fi

current_version=$(bump2version --dry-run --list $1 | grep "current_version=" | sed -r s,"^.*=",,) || exit;
changes=$(git log $current_version..HEAD --pretty=format:'- %s')
git add Changelog.md

next_version=$(bump2version --list $1 | grep "new_version=" | sed -r s,"^.*=",,) || exit;
today=$(date +'%d-%m-%Y')

current_changelog=$(cat Changelog.md)
cat > Changelog.md <<EOF

## ${next_version} (${today})

### Note worthy changes
$changes

### Backwards incompatible changes
- ...

${current_changelog}
EOF

echo "\nUpdated to version ${next_version}. \nMake sure to double check the Changelog.\n"
