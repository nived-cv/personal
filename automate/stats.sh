

current=$(pwd)
lookup=$(grep -l $current 'lookup.csv' | wc -l)
initialLook=$(find 'lookup.csv' | wc -l)
day=$(date +%a)

if (( $initialLook == 0))
then
echo "totalHtml,totalCss,totalJs,totalLines" > 'lookup.csv'
echo "total,0,0,0" >> 'lookup.csv'
echo -e "\nweekly" >> 'lookup.csv'
echo "week,0" >> 'lookup.csv'
echo -e "\ndir,html,css,js" >> 'lookup.csv'
fi

newHtmlLines=$(find . -name "*.html" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newCssLines=$(find . -name "*.css" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newJsLines=$(find . -name "*.js" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)

oldTotalHtmlLines=$(awk -F, '{ if("total" == $1) print $2}' 'lookup.csv')
oldTotalCssLines=$(awk -F, '{ if("total" == $1) print $3}' 'lookup.csv')
oldTotalJsLines=$(awk -F, '{ if("total" == $1) print $4}' 'lookup.csv')
weeklyLines=$(awk -F, '{ if("week" == $1) print $2}' 'lookup.csv')

if (( $lookup == 0))
then
totalDaily=$(($newJsLines + $newHtmlLines + $newCssLines))
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newHtmlLines,$newCssLines,$newJsLines|" 'lookup.csv'
echo "$current,$newHtmlLines,$newCssLines,$newJsLines" >> 'lookup.csv'
echo -e "\n html  :" $newHtmlLines "\n css   :" $newCssLines "\n js    :" $newJsLines "\n$totalDaily"
else
oldHtmlLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $2}' 'lookup.csv')
oldCssLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $3}' 'lookup.csv')
oldJsLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $4}' 'lookup.csv')

jsLines=$(($newJsLines - $oldJsLines))
htmlLines=$(($newHtmlLines - $oldHtmlLines))
cssLines=$(($newCssLines - $oldCssLines))
totalDaily=$(($jsLines + $htmlLines + $cssLines))

newTotalHtmlLines=$(($htmlLines + $oldTotalHtmlLines))
newTotalCssLines=$(($cssLines + $oldTotalCssLines))
newTotalJsLines=$(($jsLines + $oldTotalJsLines))

sed -i "s|$current,$oldHtmlLines,$oldCssLines,$oldJsLines|$current,$newHtmlLines,$newCssLines,$newJsLines|" 'lookup.csv'
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newTotalHtmlLines,$newTotalCssLines,$newTotalJsLines|" 'lookup.csv'
echo -e "\n html  :" $htmlLines " " $newTotalHtmlLines "\n css   :" $cssLines " " $newTotalCssLines  "\n js    :" $jsLines " " $newTotalJsLines "\n \t $totalDaily   $(($newTotalCssLines + $newTotalHtmlLines + $newTotalJsLines))"
fi

if [ $day == "Mon" ]
then
echo -e "\nweekly Lines : $weeklyLines"
sed -i "s|week,$weeklyLines|week,0|" 'lookup.csv'
else
sed -i "s|week,$weeklyLines|week,$totalDaily|" 'lookup.csv'
fi


# Needs to be fixed
## doesnt recursively counts in directories
## doesnt display total for week / month
## doesnt count modifications / completely redoing the same number of lines etc [contents arent checked]