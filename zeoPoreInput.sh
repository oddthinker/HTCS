#!/bin/bash
### Date: 2021-08
### Author: Junpeng Yuan
### Function: The pore structure (e.g. pore diameter, surface area, pore volume) is calculated by using Zeo++
### Usage: nohup sh zeoPoreInput.sh &>> mylogzeoPoreInput &

#-----UserDefined-----
# user
user=$(whoami)
# userCores
userCores=400
# zeoDataFile
zeoDataFile=zeodata
# inputStructureFile
inputStructureFile=inputstructure
# CCDCRadiusMass
ccdcInformation=ccdcRadiusMass
# zeopath
zeopath=/home/jpyuan/softwares/zeo++-0.3

#-----Function-----
materialsRadMass(){
cat > materials.rad <<!
H  1.20 
He 1.40
Li 1.82
Be 2.0
B  2.0
C  1.70
N  1.55
O  1.52
F  1.47
Ne 1.54
Na 2.27
Mg 1.73
Al 2.0
Si 2.10
P  1.80
S  1.80
Cl 1.75
Ar 1.88
K  2.75
Ca 2.0
Sc 2.0
Ti 2.0
V  2.0
Cr 2.0
Mn 2.0
Fe 2.0
Co 2.0
Ni 1.63
Cu 1.40
Zn 1.39
Ga 1.87
Ge 2.0
As 1.85
Se 1.90
Br 1.85
Kr 2.02
Rb 2.0
Sr 2.0
Y  2.0
Zr 2.0
Nb 2.0
Mo 2.0
Tc 2.0
Ru 2.0
Rh 2.0
Pd 1.63
Ag 2.0
Cd 1.58
In 1.93
Sn 2.17
Sb 2.0
Te 2.06
I  1.98
Xe 2.16
Cs 2.0
Ba 2.0
La 2.0
Ce 2.0
Pr 2.0
Nd 2.0
Pm 2.0
Sm 2.0
Eu 2.0
Gd 2.0
Tb 2.0
Dy 2.0
Ho 2.0
Er 2.0
Tm 2.0
Yb 2.0
Lu 2.0
Hf 2.0
Ta 2.0
W  2.0
Re 2.0
Os 2.0
Ir 2.0
Pt 1.72
Au 1.66
Hg 1.55
Tl 1.96
Pb 2.02
Bi 2.0
Po 2.0
At 2.0
Rn 2.0
Fr 2.0
Ra 2.0
Ac 2.0
Th 2.0
Pa 2.0
U  2.0
!

cat > materials.mass <<!
H  1.0079  
He 4.00260 
Li 6.941   
Be 9.01218 
B  10.81   
C  12.011  
N  14.0067 
O  15.9994 
F  18.99840
Ne 20.179  
Na 22.98977
Mg 24.305  
Al 26.98154
Si 28.0855 
P  30.97376
S  32.06   
Cl 35.453  
Ar 39.948  
K  39.098  
Ca 40.08   
Sc 44.9559 
Ti 47.90   
V  50.9415 
Cr 51.996  
Mn 54.9380 
Fe 55.847  
Co 58.9332 
Ni 58.70   
Cu 63.546  
Zn 65.38   
Ga 69.72   
Ge 72.59   
As 74.9216 
Se 78.96   
Br 79.904  
Kr 83.80   
Rb 85.4678 
Sr 87.62   
Y  88.9059 
Zr 91.22   
Nb 92.9064 
Mo 95.94   
Tc 98
Ru 101.07  
Rh 102.9055
Pd 106.4   
Ag 107.868 
Cd 112.41  
In 114.82  
Sn 118.69  
Sb 121.75  
Te 127.60  
I  126.9045
Xe 131.30  
Cs 132.9054
Ba 137.33  
La 138.9055
Ce 140.12  
Pr 140.9077
Nd 144.24  
Pm 145   
Sm 150.4   
Eu 151.96  
Gd 157.25  
Tb 158.9254
Dy 162.50  
Ho 164.9304
Er 167.26  
Tm 168.9342
Yb 173.04  
Lu 174.967 
Hf 178.49  
Ta 180.9479
W  183.85  
Re 186.207 
Os 190.2   
Ir 192.22  
Pt 195.09  
Au 196.9665
Hg 200.59  
Tl 204.37  
Pb 207.2   
Bi 208.9804
Po 208.9824
At 209.9871
Rn 222.0176
Fr 223
Ra 226
Ac 227     
Th 232.0   
Pa 231.0359
U  238.0
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
pbsnodes_rate=$(pbsnodes -l all |grep "free" |wc -l)
usercores_rate=$(qstat |grep "$(whoami)" |awk '{print $5}' |grep "R" |wc -l)
pbsNodesName=$(pbsnodes -l all |grep "free" |head -n 1 |awk '{print $1}')
}

PBSNodes_queueNumbers(){
time1=$(date +%s)
while [ 1 -eq 1 ]
do

pbsQueuenumbers=$(qstat |grep "$(whoami)" |awk '{print $5}' |grep "Q" |wc -l)

time2=$(date +%s)
difference21time=$(($time2-$time1))
if [ "$pbsQueuenumbers" -eq 0 ]
then
	break
###	
elif [ "$pbsQueuenumbers" -eq 1 -a "$difference21time" -gt 10 ]
then
	break	
elif [ "$pbsQueuenumbers" -eq 2 -a "$difference21time" -gt 10 ]
then
	break	
elif [ "$pbsQueuenumbers" -eq 3 -a "$difference21time" -gt 10 ]
then
	break						
###	
else
	sleep 1
fi
done
}

# myjobs
MyJobsZeoPD(){
cat > myjobsPD.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=$pbsNodesName:ppn=1
#PBS -N HTCS_zeo++
#PBS -o my.out
#PBS -e my.err
#PBS -V

cd \${PBS_O_WORKDIR}

export PATH=$zeopath:\$PATH

network -r $location/$ccdcInformation/materials.rad -mass $location/$ccdcInformation/materials.mass -ha -resex $cifName.cif &>> myout

!
}

MyJobsZeoHeSA(){
cat > myjobsHeSA.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=$pbsNodesName:ppn=1
#PBS -N HTCS_zeo++
#PBS -o my.out
#PBS -e my.err
#PBS -V

cd \${PBS_O_WORKDIR}

export PATH=$zeopath:\$PATH

network -r $location/$ccdcInformation/materials.rad -mass $location/$ccdcInformation/materials.mass -ha -sa 1.3 1.3 50000 $cifName.cif &>> myout 

!
}

MyJobsZeoN2SA(){
cat > myjobsN2SA.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=$pbsNodesName:ppn=1
#PBS -N HTCS_zeo++
#PBS -o my.out
#PBS -e my.err
#PBS -V

cd \${PBS_O_WORKDIR}

export PATH=$zeopath:\$PATH

network -r $location/$ccdcInformation/materials.rad -mass $location/$ccdcInformation/materials.mass -ha -sa 1.82 1.82 50000 $cifName.cif &>> myout

!
}

MyJobsZeoPV(){
cat > myjobsPV.sh <<!
#!/bin/bash
#PBS -S /bin/bash
#PBS -q batch
#PBS -l nodes=$pbsNodesName:ppn=1
#PBS -N HTCS_zeo++
#PBS -o my.out
#PBS -e my.err
#PBS -V

cd \${PBS_O_WORKDIR}

export PATH=$zeopath:\$PATH

network -r $location/$ccdcInformation/materials.rad -mass $location/$ccdcInformation/materials.mass -ha -volpo 0.0 0.0 50000 $cifName.cif &>> myout

!
}

#-----Main-----
location=$(pwd)
echo zeoPoreInput
# The folder to Create ccdcInformation
if [ ! -d "$ccdcInformation" ]
then
    echo "This folder is being created"
    mkdir "$location"/"$ccdcInformation"/
else
    echo "This folder is existed"
fi

cd "$location"/"$ccdcInformation"/
materialsRadMass

# The folder to Create zeoDataFile
mkdir "$location"/"$zeoDataFile"/

# Time to submit the first task
echo "submitStart   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/zeoPoreInput.log

# 
cifFile=$(find "$location"/"$inputStructureFile"/ -name "*.cif" |wc -l)

if [ "$cifFile" -gt 0 ]
then
	i=1
	while [ 1 -eq 1 ]
	do
		cifnumber=$(find  "$location"/"$inputStructureFile"/ -name "*.cif" |wc -l)
		if [ "$i" -le "$cifnumber" ]
		then
		
			#CPU_Utilization
			PBSNodes_userCores_Utilization
			#if      [ "$cpu_rate" -le 98 ]
			if [ "$pbsnodes_rate" -gt 0 -a "$usercores_rate" -le "$userCores" ]
			then
				cd "$location"/"$inputStructureFile"/
				cifName=$(find "$location"/"$inputStructureFile"/ -name "*cif" |sort -n |head -n $i |tail -n 1 |awk -F '/' '{print $NF}' |cut -d "." -f 1)
				cd "$location"/"$zeoDataFile"/
				mkdir "$cifName"
				cp "$location"/"$inputStructureFile"/"$cifName".cif "$cifName"
				cd "$cifName"
				
				PBSNodes_queueNumbers
				
##### Pore Diameter
				mkdir PoreDiameter
				cp "$cifName".cif PoreDiameter
				cd PoreDiameter
				
				MyJobsZeoPD	
				
				#nohup network -r "$location"/"$ccdcInformation"/materials.rad -mass "$location"/"$ccdcInformation"/materials.mass -ha -resex "$cifName".cif &>> myout &

				qsub myjobsPD.sh				
				cd ../
				
###### Specific SurfaceArea
				mkdir SurfaceAreaHe
				cp "$cifName".cif SurfaceAreaHe
				cd SurfaceAreaHe
				
				MyJobsZeoHeSA
				
				#nohup network -r "$location"/"$ccdcInformation"/materials.rad -mass "$location"/"$ccdcInformation"/materials.mass -ha -sa 1.3 1.3 50000 "$cifName".cif &>> myout &

				qsub myjobsHeSA.sh
				cd ../
				
				mkdir SurfaceAreaN2
				cp "$cifName".cif SurfaceAreaN2
				cd SurfaceAreaN2
				
				MyJobsZeoN2SA
				
				#nohup network -r "$location"/"$ccdcInformation"/materials.rad -mass "$location"/"$ccdcInformation"/materials.mass -ha -sa 1.82 1.82 50000 "$cifName".cif &>> myout &
				
				qsub myjobsN2SA.sh				
				cd ../
				
###### Probe-Occupiable Volume
				mkdir ProbeOccupiableVolume
				cp "$cifName".cif ProbeOccupiableVolume
				cd ProbeOccupiableVolume
				
				MyJobsZeoPV
				
				#nohup network -r "$location"/"$ccdcInformation"/materials.rad -mass "$location"/"$ccdcInformation"/materials.mass -ha -volpo 0.0 0.0 50000 "$cifName".cif &>> myout &
				
				qsub myjobsPV.sh								
				cd ../	
				
				echo "$i $cifName" &>> "$location"/zeoPoreInput.log
				((i++))
			else
				sleep 3
			fi
		else
		
# Time to submit the last task
			echo "submitFinish   Date: $(date '+%Y-%m-%d-%T')" &>> "$location"/zeoPoreInput.log
			break
		fi
	done
fi
