
function get_changes() {
    branches=$( git branch | tr '*' ' ')
    for branch in $branches; do 
        git log $branch --author='nived' --pretty=tformat: --numstat > "$branch.txt"
        total=$(awk -F'\t' -v prev=$total '{prev += $1} END {print prev}' "$branch.txt")
        # rm "$branch.txt"
    done
    echo $total
}

function commitChanges() {
    git add .
    git commit -am "chore(stats): commiting to get lines of count"
}

function main() {

    isGitRepo=$(git rev-parse --is-inside-work-tree)
    
    if [ $isGitRepo == true ]
    then
    get_changes
    else 
    git init
    commitChanges
    fi
}

main