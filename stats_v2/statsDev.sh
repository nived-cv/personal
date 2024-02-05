
readHtmlLines=0
readCssLines=0
readJsLines=0

function get_changes() {
    branches=$( git branch | tr '*' ' ')
    for branch in $branches; do 
        git log $branch --author='nived' --pretty=tformat: --numstat > "$branch.txt"
        readHtmlLines=$(awk -F'\t' -v prev=$total '{if($3 ~ /^.*\.(html)$/) prev += $1} END {print prev}' "$branch.txt")
        readCssLines=$(awk -F'\t' -v prev=$total '{if($3 ~ /^.*\.(css)$/) prev += $1} END {print prev}' "$branch.txt")
        readJsLines=$(awk -F'\t' -v prev=$total '{if($3 ~ /^.*\.(js|ts|tsx|jsx)$/) prev += $1} END {print prev}' "$branch.txt")
        rm "$branch.txt"
    done
}

function commitChanges() {
    git add .
    git commit -am "chore(stats): commiting to get lines of count"
}

function updatecsv() {
    currentDir=$(pwd)
    lookup=$(awk -F, -v dir=$currentDir '{if($1 == dir) print("true")}') "./lookup.csv"
    if [ $lookup != true ]
    then
    echo "$currentDir,0,0,0" >> "./lookup.csv" 
    fi
    prevHtmlLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $2}') "./lookup.csv"
    prevCssLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $3}') "./lookup.csv"
    prevJsLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $4}') "./lookup.csv"

    newHtmlLines=$(( $prevHtmlLines - $readHtmlLines )) | sed 's/-//'
    newCssLines=$(( $prevCssLines - $readCssLines )) | sed 's/-//'
    newJsLines=$(( $prevJsLines - $readJsLines )) | sed 's/-//'


}

function main() {

    isGitRepo=$(git rev-parse --is-inside-work-tree)
    
    if [ $isGitRepo == true ]
    then
    get_changes
    else 
    git init
    commitChanges
    rm -rf .git
    fi
}

main
