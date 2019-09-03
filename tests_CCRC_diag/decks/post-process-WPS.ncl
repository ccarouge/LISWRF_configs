load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
;
; To cut wrfbdy and wrflowinp files into monthly files.
; It will correctly take into account the 00am time
; of the next month (included in wrflowinp but excluded
; in wrfbdy)
; 


undef("cut_files")
function cut_files(filename:string,strict:logical)
; It will cut the input files into monthly files
; filename: root of the file (wrfbdy or wrflowinp)
; strict: If True does not include the extra 00am at the end
begin
  shift = 1
  if (strict) then
    shift = 0 
  end if

  file_list = systemfunc("ls "+filename+"_d??")

  ; Read times in netcdf file
  do nf=0,dimsizes(file_list)-1
    fi = addfile(file_list(nf)+".nc","r")
    
    ; Get Times variable
    times = wrf_user_getvar(fi, "times",-1)

    ; Get start/end month indexes 
    delim = "-"
    months = str_get_field(times,2,delim)
    years  = str_get_field(times,1,delim)

    ; Get the indexes of the different months
    ind0 = 0
    do while(ind0.ne.dimsizes(months)-shift)
      if (isvar("err")) then
	delete(err)
      end if
      month_ind = ind(months.eq.months(ind0))
      starting = month_ind(0)
      ending   = month_ind(dimsizes(month_ind)-1)+shift
      print("Create file for month: "+months(starting))
      cmd = "ncks -O -d Time,"+starting+","+ending+" "+file_list(nf)+" "+outdir+filename+"_d"+tostring_with_format(nf+1,"%0.2i")+"_"+years(starting)+"-"+months(starting)
      err = systemfunc(cmd)
      if (.not.ismissing(err)) then
        print(err)
        exit
      end if
      ind0 = toint(ending)+1-shift
      delete(month_ind)
    end do

    delete(fi)
    delete(times)
    delete(months)
    delete(years)

  end do

  return(err)
end

begin
  ; Get filename from arguments
  if (.not.isvar("inputdir").or..not.(isvar("outdir"))) then
    print("inputdir and outdir need to be set as command line arguments")
    print("Example: ncl 'inputdir="+tostring(34C)+"./"+tostring(34C)+"' 'outdir="+tostring(34C)+"./"+tostring(34C)+"' post-process-WPS.ncl")
    exit
  end if

  print("Input directory is: "+inputdir)
  
  ; Deal with wrfbdy.
  strict = True  ; Do not include 00 from next month
  err = cut_files(inputdir+"wrfbdy",strict)

  ; Deal with wrflowinp
  strict = False ; Include 00 from next month 
  err = cut_files(inputdir+"wrflowinp",strict)


end
