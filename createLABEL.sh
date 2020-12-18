#/bin/bash
#Author : Rajesh.Bhaskaran@altran.com
#Desc : This script is used for creating and applying a new LABEL for AONT files and also share the diff file.
#15-Aug-19 : Version 1 : Supports only LABEL creation and application.
#Pre-requsites : Files with changes should already be checked-in and the new versions should be added in the cspec. 

echo "May I know your name please ?"
read name
clear
printf "Hello $name, Genie wishes you a very "
CT=/usr/atria/bin/cleartool
TIME=$(date "+%H")
if [ $TIME -lt 12 ]; then
	echo "Good morning !!"
elif [ $TIME -lt 18 ]; then
     	echo "Good afternoon !!"
else
	echo "Good evening !!"
fi
echo "So which FR are you going to solve today ? Please enter in the format ALU01234567"
read FRNUMBER
echo "As per my calculations the present latest LABEL is " `tail -1 AONT_LABEL.txt | awk -F',' '{print $1}'`
LABEL=`tail -1 AONT_LABEL.txt | awk -F',' '{print $1}'`
LABEL_NUM=`echo $LABEL | awk -F'_' '{print $4}'`
NEW_LABEL_NUM=$(echo "$LABEL_NUM + 1" | bc)
NEW_LABEL="AONT_VOICE_MERGE_$NEW_LABEL_NUM"
echo "So $name, the new LABEL that is going to be applied is $NEW_LABEL"

echo "Creating LABELS using $CT mklbtype ..."
cd /vobs/gpon/sw/src01; $CT mklbtype -c "$FRNUMBER" $NEW_LABEL;cd /vobs/gpon/sw/src03; $CT mklbtype -c "$FRNUMBER" $NEW_LABEL;cd /vobs/gpon/sw/src04; $CT mklbtype -c "$FRNUMBER" $NEW_LABEL;

echo "Applying LABELS using $CT mklabel ..."
cd /vobs/gpon/sw/src01;$CT mklabel -r  $NEW_LABEL ./;
cd /vobs/gpon/sw/src03;$CT mklabel -r  $NEW_LABEL ./;
cd /vobs/gpon/sw/src04;$CT mklabel -r  $NEW_LABEL ./;
NOW=$(date +"%Y%m%d_%H%M%S")
echo $NEW_LABEL,$name,$NOW >> /home/aricent1/Rajesh/Genie/AONT_LABEL.txt
#v_file="/home/aricent1/Rajesh/Genie/ver_diff.txt"
#c_file="/home/aricent1/Rajesh/Genie/"$NEW_LABEL"_"$LABEL"_diff.txt"
#rm -rf "c_file"

#cd "/vobs/gpon/sw"
#cleartool find ./src0* -version "lbtype($NEW_LABEL) && !lbtype($LABEL)" -print | tee $v_file
#while read -r line
#do
#path="${line%/*}"
#ver="${line##*/}"
#((p_ver=$ver-1))
#diff -u $path"/"$p_ver $path"/"$ver >> $c_file
#done < $v_file
#scp $c_file "ddevaraj@172.21.128.24:/home/users1/ddevaraj/Rajesh"

