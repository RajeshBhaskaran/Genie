echo "Please change the BB version"
sleep 1
vim /vobs/gpon/sw/bcm963xx/targets/fs.src/etc/sw_version 
STRINGS='/usr/bin/strings'
#echo "Please enter any new prints , that could be searched in ipphone , followed by [ENTER]"
#read STRING_TO_SEARCHED
#COUNTEARLIER=`$STRINGS /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/BCM/ipphone | grep -c "$STRING_TO_SEARCHED"`
#echo $STRING_TO_SEARCHED "was preset" $COUNTEARLIER "times earlier" >> ~/Rajesh/IPTK_BCM.txt
STARTTIME=$(date +%s)
cd /vobs/gpon/sw/src04/IPTK/ICF/source/ifx_al/make/linux;
make BUILD=TARGET_GBCMAs; 
cd /vobs/gpon/sw/src04/IPTK/ICF/source/ifx_al/bin/intel;
/vobs/3rdparty/pkg005/uclibc-crosstools-gcc-4.2.3-3/usr/bin/mips-linux-uclibc-strip ipphone
cp ipphone /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/BCM/
#COUNTNOW=`$STRINGS /vobs/gpon/sw/src03/IPTK/ICF/source/ifx_al/bin/BCM/ipphone | grep -c "$STRING_TO_SEARCHED"`
#if [ $COUNTEARLIER == $COUNTNOW ];
#then 
#  echo "String to be searched was not added"
#  echo "String to be searched was" $COUNTEARLIER "in ipphone and" $COUNTNOW "times now"
#else
cd /vobs/gpon/sw/cpe/build;
NOW=$(date +"%Y%m%d_%H%M%S");SWVER=`cat /vobs/gpon/sw/bcm963xx/targets/fs.src/etc/sw_version`;make BUILD=TARGET_GBCMAs | tee ~/BCMLogs/"$SWVER"_"$NOW"
#fi
ENDTIME=$(date +%s)
echo "String ->" $STRING_TO_SEARCHED "<- to be searched was" $COUNTEARLIER "in ipphone and" $COUNTNOW "times now"
echo "The build took" $((($ENDTIME - $STARTTIME)/60)) "minutes to complete"
