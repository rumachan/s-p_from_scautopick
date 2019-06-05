#!/bin/bash

#parse_xml.ah

#fixed bits
code="WIZ"

start_date=20190527
end_date=20190531

date=$start_date
until [ $date -gt $end_date ]
do
	echo $date
	start=`date -d"$date" +"%Y/%m/%d 00:00:00"`
	end=`date -d"$date 1 day" +"%Y/%m/%d 00:10:00"`

	xmlfile=$code'_'$date.scautopick_dump.xml
	cp $xmlfile scautopick_dump.xml
	sc3ml2sp.py
	mv scautopick.sp $code'_'$date'_sc3_s-p.dat'

	date=`date --date="$date 1 day" +%Y%m%d`
done
