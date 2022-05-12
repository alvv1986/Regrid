#!/bin/csh
set echo

foreach year (2019)
 foreach mon (08 09)
  foreach day (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31)
   foreach hour (00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23)

        setenv FIN 1520092019/mlevels_d01_${year}-${mon}-${day}-${hour}Z.nc
        if (-e $FIN) then
        setenv FON 1520092019/column_d01_${year}-${mon}-${day}-${hour}Z.nc

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

        tauaer1           = fi->TAUAER1
        tauaer2           = fi->TAUAER2
        tauaer3           = fi->TAUAER3
        tauaer4           = fi->TAUAER4
        Times             = fi->Times
        XLAT              = fi->XLAT
        XLONG             = fi->XLONG
        dimgeo            = dimsizes(tauaer1)
 
        aod550            = new((/1,dimgeo(1),dimgeo(2),dimgeo(3)/),"float")
        ae                = new((/1,dimgeo(1),dimgeo(2),dimgeo(3)/),"float")
        aod550@_FillValue = -999.
        ae@_FillValue     = -999.
        do i=0,dimgeo(3)-1
         do j=0,dimgeo(2)-1 
          do z=0,dimgeo(1)-2
           if(tauaer4(0,z,j,i).eq.0)then
            ae(0,z,j,i)   = -999.
            aod550(0,z,j,i) = -999.
           end if
           ae(0,z,j,i) = log(tauaer1(0,z,j,i)/tauaer4(0,z,j,i))/log(3.33)
           aod550(0,z,j,i) = tauaer2(0,z,j,i)*1.375^(-1*ae(0,z,j,i))
          end do
         end do
        end do        
        aod550!0          = "Time"
        aod550!1          = "bottom_top"
        aod550!2          = "south_north"
        aod550!3          = "west_east"

        fo->aod550        = dim_sum_Wrap(aod550(Time|:,south_north|:,west_east|:,bottom_top|:))
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
