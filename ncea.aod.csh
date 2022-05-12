#!/bin/csh
#--------------------------------------------------------------------
foreach year (2019)
foreach mon (09)
foreach day (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
foreach species (column)
set fin = column_d01_${year}-{$mon}-{$day}-00Z.nc
if (-e $fin) then
### Adjust times for Brazil..
#ncea $cwd/column_d01_${year}-{$mon}-{$day}-15Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-16Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-17Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-18Z.nc avg.$species.$year.$mon.$day.1518.nc
ncea $cwd/column_d01_${year}-{$mon}-{$day}-12Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-13Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-14Z.nc $cwd/column_d01_${year}-{$mon}-{$day}-15Z.nc avg.$species.$year.$mon.$day.1215.nc
else
echo "No $fin"
endif
end
end
end
end
#ncrcat avg.column.2019.0* avg.daily.column.2019.1518.nc
