#stats v2.5

# this script only counts html,css and js [ts and tsx included] - in sub directories as well
# does not count lines of code in /node_modules/
# modification to lines or operations resulting in same number of lines will not be counted

current=$(pwd)
lookup=$(grep -l $current '/home/nived/bin/lookup.csv' | wc -l)
day=$(date +%a)

newHtmlLines=$(find . -name "*.html" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newCssLines=$(find . -name "*.css" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newJsLines=$(find . -name "*.js" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newTsLines=$(find . -name "*.ts*" -not -path '*/node_modules/*' -exec cat {} + | grep . | wc -l)
newJsLines=$(($newJsLines + $newTsLines))

oldTotalHtmlLines=$(awk -F, '{ if("total" == $1) print $2}' '/home/nived/bin/lookup.csv')
oldTotalCssLines=$(awk -F, '{ if("total" == $1) print $3}' '/home/nived/bin/lookup.csv')
oldTotalJsLines=$(awk -F, '{ if("total" == $1) print $4}' '/home/nived/bin/lookup.csv')
weeklyLines=$(awk -F, '{ if("week" == $1) print $2}' '/home/nived/bin/lookup.csv')

if (( $lookup == 0))
then
totalDaily=$(($newHtmlLines + $newJsLines + $newCssLines))
newTotalHtmlLines=$(($newHtmlLines + $oldTotalHtmlLines))
newTotalCssLines=$(($newCssLines + $oldTotalCssLines))
newTotalJsLines=$(($newJsLines + $oldTotalJsLines))

echo "$current,$newHtmlLines,$newCssLines,$newJsLines" >> '/home/nived/bin/lookup.csv'
else
oldHtmlLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $2}' '/home/nived/bin/lookup.csv')
oldCssLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $3}' '/home/nived/bin/lookup.csv')
oldJsLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $4}' '/home/nived/bin/lookup.csv')

newJsLines=$(($newJsLines - $oldJsLines))
newHtmlLines=$(($newHtmlLines - $oldHtmlLines))
newCssLines=$(($newCssLines - $oldCssLines))
totalDaily=$(($newHtmlLines + $newJsLines + $newCssLines))
if (( $newJsLines < 0))
then 
newJsLines=0
fi
if (( $newHtmlLines < 0))
then 
newHtmlLines=0
fi
if (( $newCssLines < 0))
then 
newCssLines=0
fi

newTotalHtmlLines=$(( $newHtmlLines + $oldTotalHtmlLines ))
newTotalCssLines=$(( $newCssLines + $oldTotalCssLines ))
newTotalJsLines=$(( $newJsLines + $oldTotalJsLines ))

# current working directory lines of code
cwdHtmlLines=$(( $newHtmlLines + $oldHtmlLines ))
cwdCssLines=$(( $newCssLines + $oldCssLines ))
cwdJsLines=$(( $newJsLines + $oldJsLines ))
fi

sed -i "s|$current,$oldHtmlLines,$oldCssLines,$oldJsLines|$current,$cwdHtmlLines,$cwdCssLines,$cwdJsLines|" '/home/nived/bin/lookup.csv'
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newTotalHtmlLines,$newTotalCssLines,$newTotalJsLines|" '/home/nived/bin/lookup.csv'
echo -e "\n html  :" $newHtmlLines " " $newTotalHtmlLines "\n css   :" $newCssLines " " $newTotalCssLines  "\n js    :" $newJsLines " " $newTotalJsLines "\n \t $totalDaily   $(($newTotalCssLines + $newTotalHtmlLines + $newTotalJsLines))"

if [ $day == "Mon" ]
then
echo -e "\nweekly Lines : $weeklyLines"
sed -i "s|week,$weeklyLines|week,0|" '/home/nived/bin/lookup.csv'
else
# possible refactor
totalDaily=$(($totalDaily + $weeklyLines))
sed -i "s|week,$weeklyLines|week,$totalDaily|" '/home/nived/bin/lookup.csv'
fi