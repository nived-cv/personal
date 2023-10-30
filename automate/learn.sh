

#! usr/bin/bash
#  a=`wc -l *.json`
 
#  for x in $a
#  do
#  echo "$x \."
#  done
#cat *js | wc -l

#b=`echo"a.{html,css,js}"`

#rm a.{html,css,js} \

#cat "index.{html,css,js}" | wc -l  #working

#cat *.{html,css,js} | wc -l   #working but not printing individually
#awk -F, '{ print $1+10 $2}' values.csv
#awk -F, '{ print $0 }' lookup.csv

# variable="pottan"
# sed -i "s/1/3/" values.csv

#search=$(grep "das" values.csv | wc -l)
#echo $search

# variable=$(date +%a)
# echo $variable
# echo "$1"       #passed terminal arguements by position $1 $2 etc...


# function killMe () {
#     echo "hey"
# }

# killMe

# echo "hey there " > 'blank.csv'

# echo "totalHtml,totalCss,totalJs,totalLines" > 'trail.csv'
# echo "total,0,0,0"

# echo -e "\n1,nived,meow" >> 'values.csv'

# lookup=$(find '/home/nived/bin/looku.csv' | wc -l)
# echo $lookup

# day=$(date +%a)
# if [ $day == "Tue" ]
# then
# echo "yes"
# fi
a=10
b=20
sed -i "s|1,nived,meow,20|1,nived,meow,2|" 'values.csv'

