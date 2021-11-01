#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Address: Zhengzhou China
### Email: junpeng_yuan@163.com
### QQ: 1003390112
### Function: The AdsorptionHeat is obtained
### Usage: nohup sh raspaWidomOutput.sh &>> mylograspaWidomOutput &

#-----UserDefined-----
# raspaDataFile
raspaDataFile=raspadata
# resultDataFile
resultDataFile=outputdata
# molecules is calculated
moleculename=CH4

#-----Main-----
location=$(pwd)
echo raspaAdsorptionHeatOutput
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspa"$moleculename"AdsorptionHeatOutput.log

if [ ! -d "$resultDataFile" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$resultDataFile"/
else
    echo "This folder is existed"
fi

cd "$location"/"$raspaDataFile"/
cifNumber=$( ls |wc -l )
echo "Material,"$moleculename"HenrymolkgPa,"$moleculename"Ugh_hkJmol,"$moleculename"QstkJmol,"$moleculename"QstWarnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_"$moleculename"_Henry-Qst.csv
for (( i=1; i<="$cifNumber"; i++ ))
do
	cd "$location"/"$raspaDataFile"/
	cifName=$(ls |sort -n |head -n $i |tail -n 1 )
	Henry=$(cat $cifName/AdsorptionHeat"$moleculename"/Output/System_0/output*data |grep "Average Henry coefficient:" |grep "mol/kg/Pa" |awk '{print $5}')
	Ugh_h=$(cat $cifName/AdsorptionHeat"$moleculename"/Output/System_0/output*data |grep "<U_gh>_1-<U_h>_0:" |awk '{print $9}' |cut -d "-" -f 2)
	RT=2.47772398
	Qst=$(echo "$Ugh_h + $RT" |bc)
	warnings=$(cat $cifName/AdsorptionHeat"$moleculename"/Output/System_0/output*data |grep "warnings" |awk '{print $3}')
	echo "$cifName,$Henry,$Ugh_h,$Qst,$warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_"$moleculename"_Henry-Qst.csv
	echo "$i $cifName success" &>> "$location"/raspa"$moleculename"AdsorptionHeatOutput.log
done
echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspa"$moleculename"AdsorptionHeatOutput.log