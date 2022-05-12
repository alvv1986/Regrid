#!/bin/csh
set echo

foreach year (2019)
 foreach mon (08 09)
  foreach day (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
   foreach hour (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23)

        setenv FIN mlevels/prepchem/2019/48h/mlevels_d01_${year}-${mon}-${day}-${hour}Z.nc
        if (-e $FIN) then
        setenv FON column/prepchem/2019/48h/column_d01_${year}-${mon}-${day}-${hour}Z.nc

ncl << EOF

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"

begin

	fn      = getenv("FIN")
        fon     = getenv("FON")
        fi      = addfile(fn,"r")
        system("rm -f "+fon)
        fo      = addfile(fon,"c")
        filedimdef(fo,"Time",-1,True)

;================================= begin calculation ===========================

        aod600            = fi->TAUAER3
        pm25              = fi->PM2_5_DRY
        co                = fi->co
        psfc              = fi->PSFC
        ptop              = fi->P_TOP
        hgt               = fi->HGT
        ph                = fi->PH
        phb               = fi->PHB
        p                 = fi->P
        pb                = fi->PB
        Pabs              = p+pb
        Pabs!0            = "Time"
        Pabs!1            = "bottom_top"
        Pabs!2            = "south_north"
        Pabs!3            = "west_east"
        Tk                = wrf_user_getvar(fi,"tk",-1)
        Times             = fi->Times
        XLAT              = fi->XLAT
        XLONG             = fi->XLONG
        
        co_cc             = co*(Pabs/Tk)*(28.01/8.31441)         ; mass cc in ug m-3
        co_cc!0           = "Time"
        co_cc!1           = "bottom_top"
        co_cc!2           = "south_north"
        co_cc!3           = "west_east"
        co_int            = vibeta(Pabs(Time|:,south_north|:,west_east|:,bottom_top|:) \
                           ,co_cc(Time|:,south_north|:,west_east|:,bottom_top|:),2 \
                           ,psfc(Time|:,south_north|:,west_east|:),101325,ptop(0))
        co_int            = co_int*0.1913*10^12   ;  mol cm-2
        co_int!0          = "Time"
        co_int!1          = "south_north"
        co_int!2          = "west_east"
        pm25_int          = vibeta(Pabs(Time|:,south_north|:,west_east|:,bottom_top|:) \
                           ,pm25(Time|:,south_north|:,west_east|:,bottom_top|:),2 \
                           ,psfc(Time|:,south_north|:,west_east|:),101325,ptop(0))
        pm25_int          = pm25_int*0.1019*10^-3 ;  mg m-2
        pm25_int!0        = "Time"
        pm25_int!1        = "south_north"
        pm25_int!2        = "west_east"
        aod600!0          = "Time" 
        aod600!1          = "bottom_top"
        aod600!2          = "south_north"
        aod600!3          = "west_east"

        fo->aod600        = dim_sum_Wrap(aod600(Time|:,south_north|:,west_east|:,bottom_top|:))
        fo->co_int        = co_int
        fo->pm25_int      = pm25_int
        fo->Times         = Times
        fo->XLAT          = XLAT
        fo->XLONG         = XLONG

        fo@history        = "Angel V., Sept 2019"

end
EOF

	echo "$year - $mon - $day - $hour Z is ok"
        else  
        echo "No $FIN"
        endif
	end
    end
end

    echo "Successfully Done!"
end
