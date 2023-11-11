
#stats v2.1.0
# setting up : 
# - create a /bin in /home
# move this file [ie stats.sh] to the bin/ created now
# edit the file stats.sh  find and replace every '/home/nived/bin/lookup.csv' to 'home/your_username/bin/lookup.csv'
# edit the /home/.bashrc file, add line export PATH="$PATH:/home/username/bin"  and alias stats='stats.sh'

# this script only counts html,css and js [ts and tsx included] - in sub directories as well
# does not count lines of code in /node_modules/
# modification to lines or operations resulting in same number of lines will not be counted

current=$(pwd)
lookup=$(grep -l $current '/home/nived/bin/lookup.csv' | wc -l)
initialLook=$(find '/home/nived/bin/lookup.csv' | wc -l)
day=$(date +%a)

if (( $initialLook == 0))
then
echo "totalHtml,totalCss,totalJs,totalLines" > '/home/nived/bin/lookup.csv'
echo "total,0,0,0" >> '/home/nived/bin/lookup.csv'
echo -e "\nweekly" >> '/home/nived/bin/lookup.csv'
echo "week,0" >> '/home/nived/bin/lookup.csv'
echo -e "\ndir,html,css,js" >> '/home/nived/bin/lookup.csv'
fi

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
totalDaily=$(($newJsLines + $newHtmlLines + $newCssLines))
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newHtmlLines,$newCssLines,$newJsLines|" '/home/nived/bin/lookup.csv'
echo "$current,$newHtmlLines,$newCssLines,$newJsLines" >> '/home/nived/bin/lookup.csv'
echo -e "\n html  :" $newHtmlLines "\n css   :" $newCssLines "\n js    :" $newJsLines "\n$totalDaily"
else
oldHtmlLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $2}' '/home/nived/bin/lookup.csv')
oldCssLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $3}' '/home/nived/bin/lookup.csv')
oldJsLines=$(awk -F, -v curr=$current '{ if(curr == $1) print $4}' '/home/nived/bin/lookup.csv')

jsLines=$(($newJsLines - $oldJsLines))
htmlLines=$(($newHtmlLines - $oldHtmlLines))
cssLines=$(($newCssLines - $oldCssLines))
totalDaily=$(($jsLines + $htmlLines + $cssLines))

newTotalHtmlLines=$(($htmlLines + $oldTotalHtmlLines))
newTotalCssLines=$(($cssLines + $oldTotalCssLines))
newTotalJsLines=$(($jsLines + $oldTotalJsLines))

sed -i "s|$current,$oldHtmlLines,$oldCssLines,$oldJsLines|$current,$newHtmlLines,$newCssLines,$newJsLines|" '/home/nived/bin/lookup.csv'
sed -i "s|total,$oldTotalHtmlLines,$oldTotalCssLines,$oldTotalJsLines|total,$newTotalHtmlLines,$newTotalCssLines,$newTotalJsLines|" '/home/nived/bin/lookup.csv'
echo -e "\n html  :" $htmlLines " " $newTotalHtmlLines "\n css   :" $cssLines " " $newTotalCssLines  "\n js    :" $jsLines " " $newTotalJsLines "\n \t $totalDaily   $(($newTotalCssLines + $newTotalHtmlLines + $newTotalJsLines))"
fi

if [ $day == "Mon" ]
then
echo -e "\nweekly Lines : $weeklyLines"
sed -i "s|week,$weeklyLines|week,0|" '/home/nived/bin/lookup.csv'
else
totalDaily=$(($totalDaily + $weeklyLines))
sed -i "s|week,$weeklyLines|week,$totalDaily|" '/home/nived/bin/lookup.csv'
fi
