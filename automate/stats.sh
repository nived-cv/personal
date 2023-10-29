

current=$(pwd)
lookup=$(grep -l $current 'lookup.csv' | wc -l)

newHtmlLines=$(find . -name "*.html"  -exec cat {} + | grep . | wc -l)
newCssLines=$(find . -name "*.css"  -exec cat {} + | grep . | wc -l)
newJsLines=$(find . -name "*.js"  -exec cat {} + | grep . | wc -l)

if (( $lookup == 0))
then
echo "$current,$newHtmlLines,$newCssLines,$newJsLines" >> 'lookup.csv'
echo -e "\n html  :" $newHtmlLines "\n css   :" $newCssLines "\n js    :" $newJsLines 
else
oldHtmlLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $2}' 'lookup.csv')
oldCssLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $3}' 'lookup.csv')
oldJsLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $4}' 'lookup.csv')

oldTotalHtmlLines=$(awk -F, '{ if("total" == $1) print $2}' 'lookup.csv')
oldTotalCssLines=$(awk -F, '{ if("total" == $1) print $3}' 'lookup.csv')
oldTotalJsLines=$(awk -F, '{ if("total" == $1) print $4}' 'lookup.csv')

jsLines=$(($newJsLines - $oldJsLines))
htmlLines=$(($newHtmlLines - $oldHtmlLines))
cssLines=$(($newCssLines - $oldCssLines))

newTotalHtmlLines=$(($htmlLines + $oldTotalHtmlLines))
newTotalCssLines=$(($cssLines + $oldTotalCssLines))
newTotalJsLines=$(($jsLines + $oldTotalJsLines))

sed -i "s|$current,$oldHtmlLines,$oldCssLines,$oldJsLines|$current,$newHtmlLines,$newCssLines,$newJsLines|" 'lookup.csv'
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newTotalHtmlLines,$newTotalCssLines,$newTotalJsLines|" 'lookup.csv'

echo -e "\n html  :" $htmlLines " " $newTotalHtmlLines "\n css   :" $cssLines " " $newTotalCssLines  "\n js    :" $jsLines " " $newTotalJsLines "\n \t $(($jsLines + $htmlLines + $cssLines))   $(($newTotalCssLines + $newTotalHtmlLines + $newTotalJsLines))"
fi


# Needs to be fixed
## doesnt recursively counts in directories
## doesnt display total for week / month
## doesnt count modifications / completely redoing the same number of lines etc [contents arent checked]
