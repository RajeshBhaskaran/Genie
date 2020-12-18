#!/bin/bash
clear
echo "Do you want to generate LABEL report for 1) AONT or 2) IPTK "
read CHOICE
if [[ "$CHOICE" =~ 1 ]];
then 
	echo "Please enter the latest AONT LABEL"
	read TILL
	from=17
	while [ $from -lt $TILL ];
	do
        	VER1=AONT_VOICE_MERGE_$from
      		VER2=AONT_VOICE_MERGE_$[$from-1]

        echo "AONT Label:" $VER1
        ctdesc="/usr/atria/bin/cleartool desc lbtype:$VER1"
        output=$(eval "$ctdesc")
        echo "$output"
        cmd="/usr/atria/bin/cleartool find /vobs/gpon/sw/src0* -version 'lbtype($VER1) && !lbtype($VER2)' -print"
        echo "Command used" $cmd
        echo "Files checked in"
        output=$(eval "$cmd")
        echo "$output"
        from=$[from+1]
	done
else
        echo "Please enter the latest IPTK LABEL"
        read TILL
        from=108
        while [ $from -lt $TILL ];
        do
                VER1=GSIP_IPTK_VER7.1.2.$from
                VER2=GSIP_IPTK_VER7.1.2.$[$from-1]

        echo "IPTK Label:" $VER1
        ctdesc="/usr/atria/bin/cleartool desc lbtype:$VER1"
        output=$(eval "$ctdesc")
        echo "$output"
        cmd="/usr/atria/bin/cleartool find /vobs/gpon/sw/src0* -version 'lbtype($VER1) && !lbtype($VER2)' -print"
        echo "Command used" $cmd
        echo "Files checked in"
        output=$(eval "$cmd")
        echo "$output"
        from=$[from+1]
	done
fi
