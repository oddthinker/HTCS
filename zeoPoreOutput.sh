#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Function: The pore structure (e.g. pore diameter, surface area, pore volume) is obtained
### Usage: nohup sh zeoPoreOutput.sh &>> mylogzeoPoreOutput &

#-----UserDefined-----
# zeoDataFile
zeoDataFile=zeodata
# resultDataFile
resultDataFile=outputdata

#-----Main-----
location=$(pwd)
echo zeoPoreOutput
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/zeoPoreOutput.log

if [ ! -d "$resultDataFile" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$resultDataFile"/
else
    echo "This folder is existed"
fi

cd "$location"/"$zeoDataFile"/

cifNumber=$( ls |wc -l )

echo "Material,GCD,PLD,LCD,Density,ASA_m2cm3_He,ASA_m2g_He,ASA_m2cm3_N2,ASA_m2g_N2,POAV_cm3g" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_PoreDiameter-SurfaceArea-OccupiableVolume.csv

for (( i=1; i<="$cifNumber"; i++ ))
do
	cifName=$(ls |sort -n |head -n $i |tail -n 1 )
	cd "$cifName"
		# Pore Diameter
		cd PoreDiameter
		filescount1=$(ls |wc -l)
		if [ "$filescount1" -eq 6 ]
		then
			zeocif="$cifName"
			zeoGCD=$(cat "$cifName".res |awk '{print $2}')
			zeoPLD=$(cat "$cifName".res |awk '{print $3}')
			zeoLCD=$(cat "$cifName".res |awk '{print $4}')
		else
			zeocif="$cifName"
			zeoGCD="-"
			zeoPLD="-"
			zeoLCD="-"
		fi
		cd ..
		# Specific SurfaceArea
		cd SurfaceAreaHe
		filescount2=$(ls |wc -l)
		if [ "$filescount2" -eq 6 ]
		then
			zeoDensity=$(cat "$cifName".sa |grep @ |awk '{print $6}')
			zeoASA_m2cm3He=$(cat "$cifName".sa |grep @ |awk '{print $10}')
			zeoASA_m2gHe=$(cat "$cifName".sa |grep @ |awk '{print $12}')
		else
			zeoDensity="-"
			zeoASA_m2cm3He="-"
			zeoASA_m2gHe="-"
		fi
		cd ../
		
		cd SurfaceAreaN2
		filescount2=$(ls |wc -l)
		if [ "$filescount2" -eq 6 ]
		then
		        zeoASA_m2cm3N2=$(cat "$cifName".sa |grep @ |awk '{print $10}')
		        zeoASA_m2gN2=$(cat "$cifName".sa |grep @ |awk '{print $12}')
		else
		        zeoASA_m2cm3N2="-"
		        zeoASA_m2gN2="-"
		fi
		cd ../
		
		# Probe-Occupiable Volume
		cd ProbeOccupiableVolume
		filescount3=$(ls |wc -l)
		if [ "$filescount3" -eq 6 ]
		then
			zeoPOAV_cm3g=$(cat "$cifName".volpo |grep @ |awk '{print $12}')
		else
			zeoPOAV_cm3g="-"
		fi
		cd ../
		echo "$zeocif,$zeoGCD,$zeoPLD,$zeoLCD,$zeoDensity,$zeoASA_m2cm3He,$zeoASA_m2gHe,$zeoASA_m2cm3N2,$zeoASA_m2gN2,$zeoPOAV_cm3g" &>> "$location"/"$resultDataFile"/"$cifNumber"Materials_PoreDiameter-SurfaceArea-OccupiableVolume.csv
	cd ../
	echo "$i $cifName success" &>> "$location"/zeoPoreOutput.log
done
echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/zeoPoreOutput.log
