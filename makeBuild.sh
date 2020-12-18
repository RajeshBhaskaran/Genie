## Script for complete build for FSL & BCM Legacy boards
## @Rajesh.Bhaskaran@altran.com
SERVERIP=$(ping -c 1 `hostname` | awk '{ print $3}' | grep 135)
printf "Hope you know you are on the $SERVERIP server  -"
if [[ "$SERVERIP" == "(135.249.56.14)" ]];
then
	echo "FSL Server"
else
	echo "BCM Server"
fi	

echo "Please change the BB version"
sleep 1
vim /vobs/gpon/sw/cpe/filesys/root/etc/sw_version 
echo "Do you have a src04 (IPTK change to be built) ? (Y/y/yes | N/n/no)"
read IPTK_BUILD

echo "Do you need a clean build ? (Y/y/yes | N/n/no)"
read CLEAN_BUILD

if [[ "$IPTK_BUILD" =~ ^(Y|y|yes|Yes)$ ]]; 
then
	echo "Is there any string to search ? (Y/y/yes | N/n/no)"
	read SYN
	if [[ "$SYN" =~ ^(Y|y|yes|Yes)$ ]];
	then
		STRINGS='/usr/bin/strings'
		echo "Please enter any new prints , that could be searched in ipphone , followed by [ENTER]"
		read STRING_TO_SEARCHED
		COUNTEARLIER=`$STRINGS /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/FSL/ipphone | grep -c "$STRING_TO_SEARCHED"`
	fi

	STARTTIME=$(date +%s)
	cd /vobs/gpon/sw/src04/IPTK/ICF/source/ifx_al/make/linux;
	clearmake -C gnu BUILD=TARGET_GSFUBs -u
	cd /vobs/gpon/sw/src04/IPTK/ICF/source/ifx_al/bin/intel;
	/vobs/montavista/pro/devkit/ppc/82xx/bin/ppc_82xx-strip ipphone
	cp ipphone /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/FSL/

	if [[ "$SYN" =~ ^(Y|y|yes|Yes)$ ]];
	then
		COUNTNOW=`$STRINGS /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/FSL/ipphone | grep -c "$STRING_TO_SEARCHED"`
		if [ $COUNTEARLIER == $COUNTNOW ];
		then 
		  echo "String to be searched was not added"
		  echo "String to be searched was" $COUNTEARLIER "in ipphone and" $COUNTNOW "times now"
		  exit;
		fi
	fi
else
	STARTTIME=$(date +%s)
	cd /vobs/gpon/sw/cpe/build;
	if [[ "$CLEAN_BUILD" =~ ^(Y|y|yes|Yes)$ ]];
	then
		NOW=$(date +"%Y%m%d_%H%M%S");SWVER=`cat /vobs/gpon/sw/cpe/filesys/root/etc/sw_version`;clearmake -C gnu BUILD=TARGET_GSFUBs -u | tee ~/Rajesh/FSLLogs/"$SWVER"_"$NOW"
	else
		NOW=$(date +"%Y%m%d_%H%M%S");SWVER=`cat /vobs/gpon/sw/cpe/filesys/root/etc/sw_version`;clearmake -C gnu BUILD=TARGET_GSFUBs | tee ~/Rajesh/FSLLogs/"$SWVER"_"$NOW"
	fi
fi
ENDTIME=$(date +%s)
echo "The build took" $(($ENDTIME - $STARTTIME)) "seconds to complete"
