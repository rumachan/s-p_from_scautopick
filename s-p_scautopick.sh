#!/bin/bash

#s-p_scautopick.sh
#run seiscomp3 day length playback to pick P- and S-phases with scautopick

#fixed bits
sds="$HOME/SDS"
net=NZ
loc=10
cmp="HHZ HHN HHE"

#command line arguments
if [ $# -lt 4 ]
then
        echo "Usage: `basename $0` fdsnws[service|service-nrt] start_date[yyyymmdd] end_date[yyyymmdd] site_code"
        exit
fi
server=$1
start_date=$2
end_date=$3
code=$4

date=$start_date
until [ $date -gt $end_date ]
do
	echo $date
	start=`date -d"$date" +"%Y/%m/%d 00:00:00"`
	end=`date -d"$date 1 day" +"%Y/%m/%d 00:10:00"`

	#listfile for times and streams for scart
	if [ -f listfile ]
	then
        	\rm listfile
	fi
	touch listfile

	#SDS folder
	if [ -d $sds ]
	then
        	\rm -r $sds
	fi
	mkdir -p $sds

        for comp in ${cmp[@]}; do
        	jd=`date -d$date +%j`
        	yr=`date -d$date +%Y`
        	echo "$start;$end;$net.$code.$loc.$comp" >> listfile
        done

	#make miniseed
	mseed=$code'_'$date.mseed
	echo 'scart 1'
	seiscomp exec scart -I fdsnws://$server.geonet.org.nz --list listfile --stdout > tmp.mseed
	echo 'scart 2'
	seiscomp exec scart  -I file://tmp.mseed SDS
	echo 'scart 3'
	seiscomp exec scart -ds -l listfile $sds > $mseed

	#pick
	dump=$code'_'$date.scautopick_dump.xml
	seiscomp exec scautopick --playback -d mysql://sysop:sysop@localhost/seiscomp3 -I $mseed --ep > $dump

	#parse
	#sc3ml2sp.py
	#mv scautopick.sp $code'_'$date'_sc3_s-p.dat'

	#tidy
	\rm -r $sds tmp.mseed $mseed

	date=`date --date="$date 1 day" +%Y%m%d`
done
