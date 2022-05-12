#!/bin/csh

set id = 2019
set inputdirectory = /dados/wrf/WRF-Chem/Opera_prepchem/48hforecast/2019/24to47/
set outputdirectory = mlevels/prepchem/2019/48h/
foreach mm (08 09)
foreach day (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
   foreach hr (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23)

      foreach dom (d01)
       set fin = {$inputdirectory}/wrfout_{$dom}_{$id}-{$mm}-{$day}_{$hr}:00:00
       set fon2 = {$outputdirectory}/mlevels_{$dom}_{$id}-{$mm}-{$day}-{$hr}Z.nc

processing:
        if (-e $fin) then
	  echo "processing ... $fin"
          ncks -O -v Times,XLONG,XLAT,P,PSFC,P_TOP,PB,HGT,PH,PHB,co,PM2_5_DRY,TAUAER1,TAUAER2,TAUAER3,TAUAER4 $fin $fon2
	else if (-e $fin.gz) then
		echo "gunzipping ... $fin"
		gunzip -c -f $fin.gz > $fin
                goto processing
        else
                echo "No $fin"
	endif
	        if (-e $fin.gz) rm -f $fin
      end
   end
end
end
echo "Successfully Done!"
