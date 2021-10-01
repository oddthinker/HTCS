#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Address: Zhengzhou China
### QQ: 1931013132
### Function: The porosity is calculated by using raspa
### Usage: nohup sh raspaPoreInput.sh &>> mylograspaPoreInput &

#-----UserDefined-----
# user
user=$(whoami)
# userCores
userCores=200
# zeoDataFile
zeoDataFile=zeodata
# raspaDataFile
raspaDataFile=raspadata
# inputStructureFile
inputStructureFile=inputstructure
# LJforcefieldFolder
LJforcefield=myDFFUFF
# moleculesFolder
moleculestructure=myTraPPE
# raspapath
raspapath=/home/jpy2021/softwares/RASPA2-master

#-----Function-----
force_field_mixing_rulesdef(){
cat > force_field_mixing_rules.def <<!
# general rule for shifted vs truncated
truncated
# general rule tailcorrections
yes
# number of defined interactions
99
# type interaction, parameters.    IMPORTANT: define shortest matches first, so that more specific ones overwrites these
H             lennard-jones     7.64893  2.84642
He            lennard-jones    10.9      2.64
Li            lennard-jones    12.5805   2.18357
Be            lennard-jones    42.7736   2.44552
B             lennard-jones    47.8058   3.58141
C             lennard-jones    47.8562   3.47299
N             lennard-jones    38.9492   3.26256
O             lennard-jones    48.1581   3.03315
F             lennard-jones    36.4834   3.0932
Ne            lennard-jones    21.1352   2.88918
Na            lennard-jones    15.0966   2.65752
Mg            lennard-jones    55.8574   2.69141
Al            lennard-Jones   155.998    3.91105
Si            lennard-Jones   155.998    3.80414
P             lennard-jones   161.03     3.69723
S             lennard-jones   173.107    3.59032
Cl            lennard-jones   142.562    3.51932
Ar            lennard-jones   119.8      3.34
K             lennard-jones    17.6127   3.39607
Ca            lennard-jones   119.766    3.02814
Sc            lennard-jones     9.56117  2.93551
Ti            lennard-jones     8.55473  2.8286
V             lennard-jones     8.05151  2.80099
Cr            lennard-jones     7.54829  2.69319
Mn            lennard-jones     6.54185  2.63795
Fe            lennard-jones     6.54185  2.5943
Co            lennard-jones     7.04507  2.55866
Ni            lennard-jones     7.54829  2.52481
Cu            lennard-jones     2.5161   3.11369
Zn            lennard-jones    62.3992   2.46155
Ga            lennard-jones   201.288    3.91100
Ge            lennard-jones   201.288    3.8041
As            lennard-jones   206.32     3.69719
Se            lennard-jones   216.38     3.59029
Br            lennard-jones   186.191    3.51905
Kr            lennard-jones   166.4      3.636
Rb            lennard-jones    20.129    3.66512
Sr            lennard-jones   118.26     3.24373
Y             lennard-jones    36.2318   2.98003
Zr            lennard-jones    34.7221   2.78317
Nb            lennard-jones    29.69     2.820
Mo            lennard-jones    28.1803   2.719
Tc            lennard-jones    24.1545   2.67089
Ru            lennard-jones    28.1803   2.63971
Rh            lennard-jones    26.6706   2.60942
Pd            lennard-jones    24.1545   2.58269
Ag            lennard-jones    18.1159   2.80455
Cd            lennard-jones   114.734    2.53728
In            lennard-jones   276.77     4.08919
Sn            lennard-jones   276.77     3.98228
Sb            lennard-jones   276.77     3.87537
Te            lennard-jones   286.835    3.76846
I             lennard-jones   256.64     3.69719
Xe            lennard-jones   221.0      4.1
Cs            lennard-jones    22.6448   4.02415
Ba            lennard-jones   183.172    3.29897
La            lennard-jones     8.55472  3.13771
Ce            lennard-jones     6.54184  3.168
Pr            lennard-jones     5.03219  3.21255
Nd            lennard-jones     5.03219  3.18493
Pm            lennard-jones     4.52897  3.15999
Sm            lennard-jones     4.02575  3.13593
Eu            lennard-jones     4.02575  3.11188
Gd            lennard-jones     4.52897  3.00052
Tb            lennard-jones     3.52253  3.07446
Dy            lennard-jones     3.52253  3.05397
Ho            lennard-jones     3.52253  3.03704
Er            lennard-jones     3.52253  3.02101
Tm            lennard-jones     3.01931  3.00586
Yb            lennard-jones   114.73     2.98894
Lu            lennard-jones    20.632    3.24284
Hf            lennard-jones    36.2318   2.79829
Ta            lennard-jones    40.7607   2.82412
W             lennard-jones    33.7157   2.73414
Re            lennard-jones    33.2124   2.63169
Os            lennard-jones    18.6191   2.77958
Ir            lennard-jones    36.735    2.53013
Pt            lennard-jones    40.2575   2.45351
Au            lennard-jones    19.6255   2.9337
Hg            lennard-jones   193.74     2.40986
Tl            lennard-jones   342.19     3.8727
Pb            lennard-jones   333.63     3.82815
Bi            lennard-jones   260.67     3.89319
Po            lennard-jones   163.55     4.1952
At            lennard-jones   142.91     4.23173
Rn            lennard-jones   124.8      4.24509
Fr            lennard-jones    25.1609   4.36536
Ra            lennard-jones   203.3      3.2758
Ac            lennard-jones    16.6062   3.09852
Th            lennard-jones    13.0837   3.02546
Pa            lennard-jones    11.0708   3.05041
U             lennard-jones    11.0708   3.02457
CH4_sp3       lennard-jones   148.0      3.73
H_com         lennard-jones    36.7      2.958
H_h2          none
O_co2         lennard-jones    79.0      3.05
C_co2         lennard-jones    27.0      2.80
N_n2          lennard-jones    36.0      3.31
N_com         none
# general mixing rule for Lennard-Jones
Lorentz-Berthelot
!
}

pseudo_atomsdef(){
cat > pseudo_atoms.def <<!
#number of pseudo atoms
8
#type      print   as    chem  oxidation   mass        charge   polarization B-factor radii  connectivity anisotropic anisotropic-type   tinker-type
He        yes     He    He    0           4.002602    0.0      0.0          1.0      1.0    0            0           relative           0
CH4_sp3   yes     C     C     0           16.04246    0.0      0.0          1.0      1.00   0            0           relative           0
H_h2      yes     H     H     0           1.00794     0.468    0.0          1.0      0.7    0            0           relative           0
H_com     no      H     H     0           0.0        -0.936    0.0          1.0      0.7    0            0           relative           0
C_co2     yes     C     C     0           12.0        0.70     0.0          1.0      0.720  0            0           relative           0
O_co2     yes     O     O     0           15.9994    -0.35     0.0          1.0      0.68   0            0           relative           0
N_n2      yes     N     N     0           14.00674   -0.482    0.0          1.0      0.7    0            0           relative           0
N_com     no      N     -     0           0.0         0.964    0.0          1.0      0.7    0            0           relative           0
!
}

Hedef(){
cat > He.def <<!
# critical constants: Temperature [T], Pressure [Pa], and Acentric factor [-]
5.2
228000.0
-0.39
# Number Of Atoms
1
# Number Of Groups
1
# Alkane-group
flexible
# number of atoms
1
# atomic positions
0 He
# Chiral centers Bond  BondDipoles Bend  UrayBradley InvBend  Torsion Imp. Torsion Bond/Bond Stretch/Bend Bend/Bend Stretch/Torsion Bend/Torsion IntraVDW IntraCoulomb
               0    0            0    0            0       0        0            0         0            0         0               0            0        0            0
# Number of config moves
0
!
}

CH4def(){
cat > CH4.def <<!
# critical constants: Temperature [T], Pressure [Pa], and Acentric factor [-]
190.564
4599200.0
0.01142
# Number Of Atoms
1
# Number Of Groups
1
# Alkane-group
flexible
# number of atoms
1
# atomic positions
0 CH4_sp3
# Chiral centers Bond  BondDipoles Bend  UrayBradley InvBend  Torsion Imp. Torsion Bond/Bond Bond/Bend Bend/Bend Bond/Torsion Bend/Torsion IntraVDW Intra ch-ch Intra ch-bd Intra bd-bd
               0    0            0    0            0       0        0            0         0         0         0            0            0        0           0           0           0
# Number of config moves
0
!
}

H2def(){
cat > H2.def <<!
# critical constants: Temperature [T], Pressure [Pa], and Acentric factor [-]
33.19
1315000.0
-0.214
#Number Of Atoms
3
# Number of groups
1
# H2-group
rigid
# number of atoms
3
# atomic positions
0 H_h2    0.0           0.0           0.37
1 H_com   0.0           0.0           0.0
2 H_h2    0.0           0.0          -0.37
# Chiral centers Bond  BondDipoles Bend  UrayBradley InvBend  Torsion Imp. Torsion Bond/Bond Stretch/Bend Bend/Bend Stretch/Torsion Bend/Torsion IntraVDW IntraCoulomb
               0    2            0    0            0       0        0            0         0            0         0               0            0        0            0
# Bond stretch: atom n1-n2, type, parameters
0 1 RIGID_BOND
1 2 RIGID_BOND
# Number of config moves
0
!
}

CO2def(){
cat > CO2.def <<!
# critical constants: Temperature [T], Pressure [Pa], and Acentric factor [-]
304.1282
7377300.0
0.22394
#Number Of Atoms
 3
# Number of groups
1
# CO2-group
rigid
# number of atoms
3
# atomic positions
0 O_co2     0.0           0.0           1.16
1 C_co2     0.0           0.0           0.0
2 O_co2     0.0           0.0          -1.16
# Chiral centers Bond  BondDipoles Bend  UrayBradley InvBend  Torsion Imp. Torsion Bond/Bond Stretch/Bend Bend/Bend Stretch/Torsion Bend/Torsion IntraVDW IntraCoulomb
               0    2            0    0            0       0        0            0         0            0         0               0            0        0            0
# Bond stretch: atom n1-n2, type, parameters
0 1 RIGID_BOND
1 2 RIGID_BOND
# Number of config moves
0
!
}

N2def(){
cat > N2.def <<!
# critical constants: Temperature [T], Pressure [Pa], and Acentric factor [-]
126.192
3395800.0
0.0372
#Number Of Atoms
3
# Number of groups
1
# N2-group
rigid
# number of atoms
3
# atomic positions
0 N_n2    0.0           0.0           0.55
1 N_com   0.0           0.0           0.0
2 N_n2    0.0           0.0          -0.55
# Chiral centers Bond  BondDipoles Bend  UrayBradley InvBend  Torsion Imp. Torsion Bond/Bond Stretch/Bend Bend/Bend Stretch/Torsion Bend/Torsion IntraVDW IntraCoulomb
               0    2            0    0            0       0        0            0         0            0         0               0            0        0            0
# Bond stretch: atom n1-n2, type, parameters
0 1 RIGID_BOND
1 2 RIGID_BOND
# Number of config moves
0
!
}

UnitCell_ABCABG(){
volume=$( cat "$location"/"$zeoDataFile"/"$cifName"/ProbeOccupiableVolume/"$cifName".volpo |head -n 1 |awk '{print $4}' )
lengthA0cif=$( cat ./"$cifName".cif  |grep "length_a" |awk '{print $2}' |cut -d "(" -f 1 )
lengthB0cif=$( cat ./"$cifName".cif  |grep "length_b" |awk '{print $2}' |cut -d "(" -f 1 )
lengthC0cif=$( cat ./"$cifName".cif  |grep "length_c" |awk '{print $2}' |cut -d "(" -f 1 )
angleAlphacif=$( cat ./"$cifName".cif  |grep "angle_alpha" |awk '{print $2}' |cut -d "(" -f 1 )
angleBetacif=$( cat ./"$cifName".cif  |grep "angle_beta" |awk '{print $2}' |cut -d "(" -f 1 )
angleGammacif=$( cat ./"$cifName".cif  |grep "angle_gamma" |awk '{print $2}' |cut -d "(" -f 1 )
}

newUnitCell_ABC(){
cat > "$cifName".py <<!
import numpy as np
volume = $volume
lenAcif = $lengthA0cif
lenBcif = $lengthB0cif
lenccif = $lengthC0cif
angAcif = $angleAlphacif
angBcif = $angleBetacif
angGcif = $angleGammacif
# lacif
newlacif = volume / (lenBcif * lenccif * (np.sin(angAcif * np.pi / 180)))
print "lacif:",newlacif
# lbcif
newlbcif = volume / (lenAcif * lenccif * (np.sin(angBcif * np.pi / 180)))
print "lbcif:",newlbcif
# lccif
newlccif = volume / (lenAcif * lenBcif * (np.sin(angGcif * np.pi / 180)))
print "lccif:",newlccif
!
}

superCellNumber_ABC(){
if [ "$1" -ge 24 ]
then
numberABC=1
elif [ "$1" -ge 12 -a "$1" -lt 24 ]
then
numberABC=2
elif [ "$1" -ge 8 -a "$1" -lt 12 ]
then
numberABC=3
elif [ "$1" -ge 6 -a "$1" -lt 8 ]
then
numberABC=4
elif [ "$1" -ge 5 -a "$1" -lt 6 ]
then
numberABC=5
elif [ "$1" -ge 4 -a "$1" -lt 5 ]
then
numberABC=6
else
numberABC=7
fi
}

simulationInput(){
cat > simulation.input <<!
SimulationType        MonteCarlo
NumberOfCycles        50000
PrintEvery            1000
PrintPropertiesEvery  1000

Forcefield            $LJforcefield

Framework 0
            FrameworkName  $cifName
            RemoveAtomNumberCodeFromLabel  yes
            UnitCells      $numberA $numberB $numberC

ExternalTemperature   298.0

Component 0 MoleculeName             He
            MoleculeDefinition       $moleculestructure
            WidomProbability         1.0
            CreateNumberOfMolecules  0
!
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

MyJobsRaspaPorosity(){
cat > myjobsPorosity.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=1:ppn=1
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
echo raspaPorosityInput

# The folder to Create forcefield
cd "$raspapath"/share/raspa/forcefield/
if [ ! -d "$LJforcefield" ]
then
    echo "This folder is being created"
    mkdir "$LJforcefield"
	cd "$LJforcefield"
	force_field_mixing_rulesdef
	pseudo_atomsdef
else
    echo "This folder is existed"
fi

cd "$raspapath"/share/raspa/molecules/
if [ ! -d "$moleculestructure" ]
then
    echo "This folder is being created"
    mkdir "$moleculestructure"
    cd "$moleculestructure"
    Hedef
    CH4def
    H2def
	CO2def
    N2def
else
    echo "This folder is existed"
fi

# The folder to Create raspaDataFile
mkdir "$location"/"$raspaDataFile"/

# Time to submit the first task
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaPorosityInput.log

# Whether File Of Cif Exists 
ciffile=$(find "$location"/"$inputStructureFile"/ -name "*.cif" |wc -l)

if [ "$ciffile" -gt 0 ]
then
	# How Many Files Of Cif Are Calculated
	i=1
	cifnumber=$(find  "$location"/"$inputStructureFile"/ -name "*.cif" |wc -l)
	while [ 1 -eq 1 ]
	do
		# Whether File Of Cif Exists 
		if [ "$i" -le "$cifnumber" ]
		then
		
			# What Is Cpu Utilization 
			#PBSNodes_userCores_Utilization
			#if      [ $cpu_rate -le 98 ]
			#if [ "$pbsnodes_rate" -gt 0 -a "$usercores_rate" -le "$userCores" ]
			#then
				cd "$location"/"$inputStructureFile"/
				cifName=$(find "$location"/"$inputStructureFile"/ -name "*cif" |sort -n |head -n $i |tail -n 1 |awk -F '/' '{print $NF}' |cut -d . -f 1)
				cd "$location"/"$raspaDataFile"/
				
				if [ ! -d "$cifName" ]
				then
					mkdir "$cifName"
				fi	
				cd "$cifName"
				
				# Create Porosity Folder 
				if [ ! -d Porosity ]
				then
					mkdir Porosity
				fi	
				cd Porosity
				
				cp "$location"/"$inputStructureFile"/"$cifName".cif ./
				
				# Read A/B/C Length Of Cif 
				zeoFilenumber=$(ls "$location"/"$zeoDataFile"/"$cifName"/ProbeOccupiableVolume/ |wc -l)
				if [ "$zeoFilenumber" -eq 3 ]
				then
					UnitCell_ABCABG
					newUnitCell_ABC
					# Python 
					#nohup python "$cifName".py >> "$cifName".out
					python "$cifName".py > "$cifName".out
					sleep 1
					
					# A/B/C 
					lengthAcif=$(cat "$cifName".out |grep "lacif" |awk '{print $2}' |cut -d "." -f 1)
					lengthBcif=$(cat "$cifName".out |grep "lbcif" |awk '{print $2}' |cut -d "." -f 1)
					lengthCcif=$(cat "$cifName".out |grep "lccif" |awk '{print $2}' |cut -d "." -f 1)
				else
					# A/B/C 			
					lengthAcif=$( cat "$cifName".cif  |grep "length_a" |awk '{print $2}' |cut -d "." -f 1 )
					lengthBcif=$( cat "$cifName".cif  |grep "length_b" |awk '{print $2}' |cut -d "." -f 1 )
					lengthCcif=$( cat "$cifName".cif  |grep "length_c" |awk '{print $2}' |cut -d "." -f 1 )		        	
				fi
				
				# The Number Of Unit Cells Along "A" Axis 
				superCellNumber_ABC "$lengthAcif"				
				numberA="$numberABC"
				
				# The Number Of Unit Cells Along "B" Axis 
				superCellNumber_ABC "$lengthBcif"			
				numberB="$numberABC"
				
				# The numberBer Of Unit Cells Along "C" Axis 
				superCellNumber_ABC "$lengthCcif"				
				numberC="$numberABC"
				
				cp "$cifName".cif "$raspapath"/share/raspa/structures/cif/

				#PBSNodes_queueNumbers				
				#PBSNodes_userCores_Utilization				
				
				# Make A Simulation 
				#export RASPA_DIR=${HOME}/softs/RASPA2/
				#nohup simulate &>> myout &
				#((usercores_rate++))
				
				#if [ "$pbsnodes_rate" -gt 0 -a "$usercores_rate" -le "$userCores" ]
				#then
					# Create Simulation File
					simulationInput
					# Create MyJobs File				
					MyJobsRaspaPorosity	
					# Make A Simulation 
					qsub myjobsPorosity.sh				
					echo "$i $cifName" &>> "$location"/raspaPorosityInput.log
					((i++))
				#fi
			#else
			#	sleep 3
			#fi
		else
			echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/raspaPorosityInput.log
			break
		fi
	done
fi
