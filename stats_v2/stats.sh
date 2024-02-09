
readHtmlLines=0
readCssLines=0
readJsLines=0

function get_changes() {
    ignoreBranch="main"
    [[ $1 != "" ]] && ignoreBranch="$1"
    
    branches=$( git branch | tr '*' ' ')
    for branch in $branches; do 
        if [ $branch != "$ignoreBranch" ]
        then
        tempFile=$(echo $branch | tr '/' 'k')
        git log $branch --author='nived.cv@vonnue.com' --since=yesterday.midnight --pretty=tformat: --numstat > ~/bin/$tempFile.txt
        readHtmlLines=$(awk -F'\t' -v prev=$readHtmlLines '{if($3 ~ /^.*\.(html)$/) prev += $1} END {print prev}' ~/bin/$tempFile.txt)
        readCssLines=$(awk -F'\t' -v prev=$readCssLines '{if($3 ~ /^.*\.(css)$/) prev += $1} END {print prev}' ~/bin/$tempFile.txt)
        readJsLines=$(awk -F'\t' -v prev=$readJsLines '{if($3 ~ /^.*\.(js|ts|tsx|jsx)$/) prev += $1} END {print prev}' ~/bin/$tempFile.txt)
        rm "/home/nived/bin/$tempFile.txt"
        fi
    done
}

function commitChanges() {
    git add .
    git commit -am "chore(stats): commiting to get lines of count"
}

function displayStats() {
    totalHtmlLines=$(awk -F, '{if($1 == "total") print($2)}' ~/bin/lookup.csv)
    totalCssLines=$(awk -F, '{if($1 == "total") print($3)}' ~/bin/lookup.csv)
    totalJsLines=$(awk -F, '{if($1 == "total") print($4)}' ~/bin/lookup.csv)

    echo -e "\nhtml:\t" $1  " $totalHtmlLines" "\ncss:\t" $2 " $totalCssLines" "\njs:\t" $3 " $totalJsLines" "\ntotal:\t" $4 "" $(($totalHtmlLines + $totalCssLines + $totalJsLines))
}

function updatecsv() {
    currentDir=$(pwd)
    lookup=$(awk -F, -v dir=$currentDir '{if($1 == dir) print("true")}' ~/bin/lookup.csv)
    if [[ $lookup != "true" ]]
    then
    echo $currentDir,0,0,0 >> ~/bin/lookup.csv 
    fi
    prevHtmlLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $2}' ~/bin/lookup.csv)
    prevCssLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $3}' ~/bin/lookup.csv)
    prevJsLines=$(awk -F, -v dir=$currentDir '{if($1 == dir) print $4}' ~/bin/lookup.csv)

    prevTotalHtmlLines=$(awk -F, '{if($1 == "total") print($2)}' ~/bin/lookup.csv)
    prevTotalCssLines=$(awk -F, '{if($1 == "total") print($3)}' ~/bin/lookup.csv)
    prevTotalJsLines=$(awk -F, '{if($1 == "total") print($4)}' ~/bin/lookup.csv)
    weeklyLines=$(awk -F, '{if($1 == "week") print($2)}' ~/bin/lookup.csv)

    newHtmlLines=$(echo $(($prevHtmlLines - $readHtmlLines)) | sed 's/-//')
    newCssLines=$(echo $(($prevCssLines - $readCssLines )) | sed 's/-//')
    newJsLines=$(echo $(($prevJsLines - $readJsLines )) | sed 's/-//')
    total=$(( $newHtmlLines + $newCssLines + $newJsLines ))

    sed -i "s|$currentDir,$prevHtmlLines,$prevCssLines,$prevJsLines|$currentDir,$(($prevHtmlLines + $newHtmlLines)),$(($prevCssLines + $newCssLines)),$(($prevJsLines + $newJsLines))|" ~/bin/lookup.csv
    sed -i "s|total,$prevTotalHtmlLines,$prevTotalCssLines,$prevTotalJsLines|total,$(($prevTotalHtmlLines + $newHtmlLines)),$(($prevTotalCssLines + $newCssLines)),$(($prevTotalJsLines + $newJsLines))|" ~/bin/lookup.csv

    displayStats $newHtmlLines $newCssLines $newJsLines $total
    day=$(date +%a)
    if [ $day == "Mon" ]
    then
    echo -e "\nweekly Lines : $weeklyLines"
    sed -i "s|week,$weeklyLines|week,0|" ~/bin/lookup.csv
    else
    sed -i "s|week,$weeklyLines|week,$(($total + $weeklyLines))|" ~/bin/lookup.csv
    fi 
}

function main() {

    isGitRepo=$(git rev-parse --is-inside-work-tree)
    includeMain=$1
    
    if [ $isGitRepo == true ]
    then
    commitChanges
    if [[ $includeMain == "include" ]]
    then 
    get_changes "include main"
    else
    get_changes
    fi
    
    updatecsv
    else 
    git init
    commitChanges
    get_changes "include main"
    updatecsv
    rm -rf .git
    fi
}

# program execution begins

if [[ $# == 0 ]]
then
    main "main"
    exit 1
fi

while getopts 'i' flag; do
    case $flag in 
        i) main "include" ;;
        /?) main ;;
    esac
done
