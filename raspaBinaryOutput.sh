#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Address: Zhengzhou China
### Email: junpeng_yuan@163.com
### QQ: 1003390112
### Function: The BinaryAdsorption is obtained
### Usage: nohup sh raspaBinaryOutput.sh &>> mylograspaBinaryOutput &

#-----UserDefined-----
# raspaDataFile
raspaDataFile=raspadata
# resultDataFile
resultDataFile=outputdata
# molecule1 is calculated
moleculename1=CH4
moleculemolFraction1="0.5"
# molecule2 is calculated
moleculename2=H2
moleculemolFraction2="0.5"
# temperature is simulated
simulationtemperature=298
# pressure is simulated
simulationpressure=100000

#-----Main-----
location=$(pwd)
echo raspaBinaryOutput
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaBinary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"PaOutput.log

if [ ! -d "$resultDataFile" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$resultDataFile"/
else
    echo "This folder is existed"
fi

cd "$location"/"$raspaDataFile"/
cifNumber=$( ls |wc -l )
echo "Material,Binary"$moleculename1""$moleculename2"_"$moleculename1"AbsoluteUptakemmolg,Binary"$moleculename1""$moleculename2"_"$moleculename2"AbsoluteUptakemmolg,Binary"$moleculename1""$moleculename2"_"$moleculename1"AbsoluteUptakemgg,Binary"$moleculename1""$moleculename2"_"$moleculename2"AbsoluteUptakemgg,Binary"$moleculename1""$moleculename2"_"$moleculename1"AbsoluteUptakecm3STPg,Binary"$moleculename1""$moleculename2"_"$moleculename2"AbsoluteUptakecm3STPg,Binary"$moleculename1""$moleculename2"_"$moleculename1"AbsoluteUptakecm3STPcm3,Binary"$moleculename1""$moleculename2"_"$moleculename2"AbsoluteUptakecm3STPcm3,Binary"$moleculename1""$moleculename2"_Selectivity,Binary"$moleculename1""$moleculename2"_Warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa_AbsoluteUptake-Selectivity.csv
for (( i=1; i<="$cifNumber"; i++ ))
do
	cd "$location"/"$raspaDataFile"/
	cifName=$(ls |sort -n |head -n $i |tail -n 1 )
	AbsoluteUptakemmolg_1=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "mol/kg framework" |head -n 1 |awk '{print $6}')
	AbsoluteUptakemmolg_2=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "mol/kg framework" |tail -n 1 |awk '{print $6}')
	AbsoluteUptakemgg_1=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "milligram/gram framework" |head -n 1 |awk '{print $6}')
	AbsoluteUptakemgg_2=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "milligram/gram framework" |tail -n 1 |awk '{print $6}')
	AbsoluteUptakecm3STPg_1=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "cm^3 (STP)/gr framework" |head -n 1 |awk '{print $7}')
	AbsoluteUptakecm3STPg_2=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "cm^3 (STP)/gr framework" |tail -n 1 |awk '{print $7}')
	AbsoluteUptakecm3STPcm3_1=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "cm^3 (STP)/cm^3 framework" |head -n 1 |awk '{print $7}')
	AbsoluteUptakecm3STPcm3_2=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "Average loading absolute" |grep "cm^3 (STP)/cm^3 framework" |tail -n 1 |awk '{print $7}')
	Selectivity=$(echo $AbsoluteUptakemmolg_1 $AbsoluteUptakemmolg_2 | awk '{ printf "%0.10f\n" ,$1/$2}')
	warnings=$(cat $cifName/Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa/Output/System_0/output*data |grep "warnings" |awk '{print $3}')
	echo "$cifName,$AbsoluteUptakemmolg_1,$AbsoluteUptakemmolg_2,$AbsoluteUptakemgg_1,$AbsoluteUptakemgg_2,$AbsoluteUptakecm3STPg_1,$AbsoluteUptakecm3STPg_2,$AbsoluteUptakecm3STPcm3_1,$AbsoluteUptakecm3STPcm3_2,$Selectivity,$warnings" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_Binary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"Pa_AbsoluteUptake-Selectivity.csv
	echo "$i $cifName success" &>> "$location"/raspaBinary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"PaOutput.log
done
echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaBinary"$moleculemolFraction1""$moleculename1""$moleculemolFraction2""$moleculename2"_"$simulationtemperature"K"$simulationpressure"PaOutput.log
