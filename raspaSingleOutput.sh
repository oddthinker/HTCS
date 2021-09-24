#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Function: The SingleAdsorption is obtained
### Usage: nohup sh raspaSingleOutput.sh &>> mylograspaSingleOutput &

#-----UserDefined-----
# raspaDataFile
raspaDataFile=raspadata
# resultDataFile
resultDataFile=outputdata
# molecules is calculated
moleculename=CH4
# temperature is simulated
simulationtemperature=298
# pressure is simulated
simulationpressure=100000

#-----Main-----
location=$(pwd)
echo raspaSingleOutput
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaOutput.log

if [ ! -d "$resultDataFile" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$resultDataFile"/
else
    echo "This folder is existed"
fi

cd "$location"/"$raspaDataFile"/
cifNumber=$( ls |wc -l )
echo "Material,Single"$moleculename"QstTotalkJmol,Single"$moleculename"QstHostAdsorbatekJmol,Single"$moleculename"QstAdsorbateAdsorbatekJmol,Single"$moleculename"ExcessUptakemmolg,Single"$moleculename"ExcessUptakemgg,Single"$moleculename"ExcessUptakecm3STPg,Single"$moleculename"ExcessUptakecm3STPcm3,Single"$moleculename"Warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa_ExcessUptake.csv
for (( i=1; i<="$cifNumber"; i++ ))
do
	cd "$location"/"$raspaDataFile"/
	cifName=$(ls |sort -n |head -n $i |tail -n 1 )
	QstTotal=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "KJ/MOL" | head -n 1|awk '{print $1}')
	QHostAdsorbate=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "KJ/MOL" | head -n 2 |tail -n 1 |awk '{print $1}')
	QstAdsorbateAdsorbate=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "KJ/MOL" | head -n 3 |tail -n 1 |awk '{print $1}')
	ExcessUptakemmolg=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading excess" |grep "mol/kg framework" |awk '{print $6}')
	ExcessUptakemgg=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading excess" |grep "milligram/gram framework" |awk '{print $6}')
	ExcessUptakecm3STPg=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading excess" |grep "cm^3 (STP)/gr framework" |awk '{print $7}')
	ExcessUptakecm3STPcm3=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading excess" |grep "cm^3 (STP)/cm^3 framework" |awk '{print $7}')
	warnings=$(cat $cifName/Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "warnings" |awk '{print $3}')
	echo "$cifName,$QstTotal,$QHostAdsorbate,$QstAdsorbateAdsorbate,$ExcessUptakemmolg,$ExcessUptakemgg,$ExcessUptakecm3STPg,$ExcessUptakecm3STPcm3,$warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa_ExcessUptake.csv
	echo "$i $cifName success" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaOutput.log
done
echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaOutput.log
