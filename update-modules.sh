if [! -f .gitmodules]; then
    echo "No submodules where find"
    exit 1
fi

git submodule foreach --recursive '
    echo "⏳ Updating module on $(pwd)"
    git fetch origin
    BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || echo "main")
    git checkout $BRANCH
    git pull origin $BRANCH
'

echo "✅ All modules have been updated"
git add .
git commit -m "Update of all submodules in the last versions"
git push origin $(git rev-parse --abbrev-ref HEAD)

echo "Submodules updated and changes sent to the remote repository"