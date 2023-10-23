
current=$(pwd)
lookup=$(grep -c $current lookup.csv)

newJsLines=$(cat *.js | wc -l)

if (( $lookup == 0))
then
echo "$current," >> lookup.csv

else
oldJsLines=$(awk -F, -v curr=$current '{ if(curr == $1) print curr ":"}' lookup.csv)
echo $oldJsLines | tr ":" "\n"
fi

# newHtmlLines=$(cat *.html | wc -l)
# newCssLines=$(cat *.css | wc -l)
# newJsLines=$(cat *.js | wc -l)

# linesofjs=`cat index.js | wc -l`
# linesofjson=`cat *json | wc -l`
# length= echo "$linesofjs-$linesofjson"|bc
# echo $length





