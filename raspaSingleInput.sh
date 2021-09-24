#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Function: The SingleAdsorption is calculated by using raspa
### Usage: nohup sh raspaSingleInput.sh &>> mylograspaSingleInput &

#-----UserDefined-----
# user
user=$(whoami)
# userCores
userCores=400
# raspaDataFile
raspaDataFile=raspadata
# LJforcefieldFolder
LJforcefield=myDFFUFF
# moleculesFolder
moleculestructure=myTraPPE
# raspapath
raspapath=/home/jpyuan/softwares/RASPA2-master
# molecules is calculated
moleculename=CH4
# temperature is simulated
simulationtemperature=298
# pressure is simulated
simulationpressure=100000

#-----Function-----
MoleculeRosenbluthWeight(){
if [ "$moleculename" = CH4 ]
then
	rosenbluthWeight=1.00024
elif [ "$moleculename" = H2 ]
then
	rosenbluthWeight=1.00002
elif [ "$moleculename" = CO2 ]
then
	rosenbluthWeight=1.00029
elif [ "$moleculename" = N2 ]
then
	rosenbluthWeight=1.00012
else
    echo error
fi
}

# method 1: CPU_Utilization
CPU_Utilization(){
cpu1=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
sleep 3
cpu2=$(cat /proc/stat | grep 'cpu ' | awk '{print $2" "$3" "$4" "$5" "$6" "$7" "$8}')
idle1=$(echo $cpu1 | awk '{print $4}')
idle2=$(echo $cpu2 | awk '{print $4}')
cpu1_totle=$(echo $cpu1 | awk '{print $1+$2+$3+$4+$5+$6+$7}')
cpu2_totle=$(echo $cpu2 | awk '{print $1+$2+$3+$4+$5+$6+$7}')
idle=$(echo "$idle2-$idle1" | bc)
cpu_totle=$(echo "$cpu2_totle-$cpu1_totle" | bc)
rate=$(echo "scale=4;($cpu_totle-$idle)/$cpu_totle*100" | bc | awk '{printf "%.2f",$1}')
cpu_rate=$(echo $rate | cut -d. -f1)
}

# method 2: PBSNodes_userCores_Utilization
PBSNodes_userCores_Utilization(){
pbsnodes_rate=$(pbsnodes -l free |wc -l)
usercores_rate=$(qstat |grep "$(whoami)" |awk '{print $5}' |grep "R" |wc -l)
pbsNodesName=$(pbsnodes -l free |head -n 1 |awk '{print $1}')
}

PBSNodes_queueNumbers(){
time1=$(date +%s)
while [ 1 -eq 1 ]
do

pbsQueuenumbers=$(qstat |grep "$(whoami)" |awk '{print $5}' |grep "Q" |wc -l)

time2=$(date +%s)
difference21time=$(($time2-$time1))

###
if [ "$pbsQueuenumbers" -eq 0 ]
then
	break
###
elif [ "$pbsQueuenumbers" -eq 1 -a "$difference21time" -gt 10 ]
then
	break
###
elif [ "$pbsQueuenumbers" -eq 2 -a "$difference21time" -gt 10 ]
then
	break	
###
elif [ "$pbsQueuenumbers" -eq 3 -a "$difference21time" -gt 10 ]
then					
	break					
###	
else
	sleep 1
fi
done
}

SimulationInput(){
cat > simulation.input <<!	
SimulationType                MonteCarlo
NumberOfCycles                50000
NumberOfInitializationCycles  10000
PrintEvery                    1000
RestartFile                   no

ContinueAfterCrash            no
WriteBinaryRestartFileEvery   5000

ChargeMethod                  Ewald
EwaldPrecision                1e-6
Forcefield                    $LJforcefield
CutOffVDW                     12.0
RemoveAtomNumberCodeFromLabel yes

Framework 0
            FrameworkName         $cifName
            UseChargesFromCIFFile yes
            UnitCells             $numberA $numberB $numberC
            HeliumVoidFraction    $porosity

ExternalTemperature   $simulationtemperature
ExternalPressure      $simulationpressure

Component 0 MoleculeName              $moleculename
            StartingBead              0
            MoleculeDefinition        $moleculestructure
            IdealGasRosenbluthWeight  $rosenbluthWeight
            TranslationProbability    1.0
            RotationProbability       1.0
            ReinsertionProbability    1.0
            CBMCProbability           1.0
            IdentityChangeProbability 0.0
            SwapProbability           1.0
            CreateNumberOfMolecules   0			
!
}

MyJobsRaspaSingle(){
cat > myjobsSingle.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=$pbsNodesName:ppn=1
#PBS -N HTCS_raspa
#PBS -o my.out
#PBS -e my.err
#PBS -V

cd \${PBS_O_WORKDIR}

export RASPA_DIR=$raspapath
\$RASPA_DIR/bin/simulate \$1

!
}

#-----Main-----
location=$(pwd)
echo raspaSingleInput
# Time to submit the first task
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaInput.log

# whether the file of cif exists
cd "$location"/"$raspaDataFile"/
ciffile=$(ls |wc -l)

if [ "$ciffile" -gt 0 ]
then
	# how many files of cif are calculated
	i=1
	cifnumber=$(ls |wc -l)
	while [ 1 -eq 1 ]
	do
		if [ "$i" -le "$cifnumber" ]
		then
			# what is the cpu utilization
			PBSNodes_userCores_Utilization
			#if      [ $cpu_rate -le 98 ]
			if [ "$pbsnodes_rate" -gt 0 -a "$usercores_rate" -le "$userCores" ]
			then
				cd "$location"/"$raspaDataFile"/
				cifName=$(ls |sort -n |head -n $i |tail -n 1 )
				cd "$cifName"
				porosity=$( cat ./Porosity/Output/System_0/output*data |grep "Average Widom:" |awk '{print $4}' )
				numberA=$(cat ./Porosity/simulation.input |grep "UnitCells" |awk '{print $2}')
				numberB=$(cat ./Porosity/simulation.input |grep "UnitCells" |awk '{print $3}')
				numberC=$(cat ./Porosity/simulation.input |grep "UnitCells" |awk '{print $4}')
				
				# IdealGasRosenbluthWeight
				MoleculeRosenbluthWeight
				
				# Create "Single" folder
				if [ ! -d Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa ]
				then
					mkdir Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa
				fi					
				cd Single"$moleculename"_"$simulationtemperature"K"$simulationpressure"Pa
				
				PBSNodes_queueNumbers
				PBSNodes_userCores_Utilization				

				# Make a simulation
				#export RASPA_DIR=${HOME}/softs/RASPA2/
				#nohup simulate &>> myout &
				((usercores_rate++))
				
				if [ "$pbsnodes_rate" -gt 0 -a "$usercores_rate" -le "$userCores" ]
				then
					# Create simulation file
					SimulationInput	
					# Create MyJobs File	
					MyJobsRaspaSingle				
					# Make A Simulation
					qsub myjobsSingle.sh		
					echo "$i $cifName" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaInput.log
					((i++))
				fi
			else
				sleep 3
			fi
		else
			echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaSingle"$moleculename"_"$simulationtemperature"K"$simulationpressure"PaInput.log
			break
		fi
	done
fi
