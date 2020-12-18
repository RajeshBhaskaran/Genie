echo "Please change the BB version"
sleep 1
vim /vobs/gpon/sw/bcm963xx/targets/fs.src/etc/sw_version
STRINGS='/usr/bin/strings'
echo "Please enter any new prints , that could be searched in toolkit_ , followed by [ENTER]"
read STRING_TO_SEARCHED
COUNTEARLIER=`$STRINGS /vobs/gpon/sw/src03/apps/VoIP/mg_product/bin/2/BCM/toolkit_* | grep -c "$STRING_TO_SEARCHED"`
echo $STRING_TO_SEARCHED "was preset" $COUNTEARLIER "times earlier" >> ~/MGC_BCM.txt
STARTTIME=$(date +%s)
cd /vobs/gpon/sw/src01/mg_product/ppu/megaco/port/build/make/linux
export PATH=/vobs/gpon/sw/cpe/bin:$PATH;make BUILD=TARGET_GBCMA clean_all;make BUILD=TARGET_GBCMA
cd /vobs/gpon/sw/src01/mg_product/ppu/megaco/port/build/bin
/vobs/3rdparty/pkg005/uclibc-crosstools-gcc-4.2.3-3/usr/bin/mips-linux-uclibc-strip toolkit_*
cp toolkit_stack_exe toolkit_ppc_exe /vobs/gpon/sw/src03/apps/VoIP/mg_product/bin/2/BCM/
COUNTNOW=`$STRINGS /vobs/gpon/sw/src03/apps/VoIP/mg_product/bin/2/BCM/toolkit_* | grep -c "$STRING_TO_SEARCHED"`
if [ $COUNTEARLIER == $COUNTNOW ];
then
  echo "String to be searched was not added"
  echo "String to be searched was" $COUNTEARLIER "in toolkit and" $COUNTNOW "times now"
else
cd /vobs/gpon/sw/cpe/build;
NOW=$(date +"%Y%m%d_%H%M%S");SWVER=`cat /vobs/gpon/sw/bcm963xx/targets/fs.src/etc/sw_version`;make BUILD=TARGET_GBCMA | tee ~/BCMLogs/"$SWVER"_"$NOW"
fi
ENDTIME=$(date +%s)
echo "String ->" $STRING_TO_SEARCHED "<- to be searched was" $COUNTEARLIER "in toolkit_* and" $COUNTNOW "times now"
echo "The build took" $(($ENDTIME - $STARTTIME)) "seconds to complete"

