#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Function: The porosity is obtained
### Usage: nohup sh raspaPoreOutput.sh &>> mylograspaPoreOutput &

#-----UserDefined-----
# raspaDataFile
raspaDataFile=raspadata
# resultDataFile
resultDataFile=outputdata

#-----Main-----
location=$(pwd)
echo raspaPorosityOutput
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaPorosityOutput.log

if [ ! -d "$resultDataFile" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$resultDataFile"/
else
    echo "This folder is existed"
fi

cd "$location"/"$raspaDataFile"/
cifNumber=$( ls |wc -l )
echo "Material,Porosity,PorosityWarnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Porosity.csv
for (( i=1; i<="$cifNumber"; i++ ))
do
	cd "$location"/"$raspaDataFile"/
	cifName=$(ls |sort -n |head -n $i |tail -n 1 )
	porosity=$(cat $cifName/Porosity/Output/System_0/output*data |grep "Average Widom:" |awk '{print $4}')
	warnings=$(cat $cifName/Porosity/Output/System_0/output*data |grep "warnings" |awk '{print $3}')
	echo "$cifName,$porosity,$warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Porosity.csv
	echo "$i $cifName success" &>> "$location"/raspaPorosityOutput.log
done
echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaPorosityOutput.log