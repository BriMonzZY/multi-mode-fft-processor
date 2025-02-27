#--------------------------Specify Libraries--------------------------
set search_path     "$search_path\
                     /tools/PDK/tsmc28nm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a\
                     /home/brimon/workspace/multi-mode-fft-processor/rtl/src/include"

## tsmc28
set target_library  "tcbn28hpcplusbwp40p140ffg0p88v0c.db\
                    /home/brimon/workspace/multi-mode-fft-processor/syn/syn_asic/sram/sramsp16x256_tsmc28hpc_ffg0p99v0c.db"
set link_library    "* tcbn28hpcplusbwp40p140ffg0p88v0c.db"
## tsmc90
# set target_library  "fast.db"
# set link_library    "* fast.db"
## smic40
# set target_library "scc40nll_hs_rvt_ff_v1p21_-40c_basic.db"
# set link_library    "* scc40nll_hs_rvt_ff_v1p21_-40c_basic.db"
## for DesignWare use
# set synthetic_library "dw_foundation.sldb"
# set link_library    "* fast.db $synthetic_library"

## tsmc90
# set symbol_library  "tsmc090.sdb"
## smic40
# set symbol_library  "SCC40NLL_HS_RVT_V0p1.sdb"



echo "\n\nSettings:"
echo "search_path: $search_path"
echo "link_library: $link_library"
echo "target_library: $target_library"
echo "\n\nI'm Ready!"
#--------------------------Prepare Filelist---------------------------
set FILE_LIST ""
set f [open "../syn/syn_files.f" r]
while {![eof $f]} {
    gets $f line
    append FILE_LIST "$line "
}
echo $FILE_LIST
close $f

#--------------------------Read Designs------------------------------

# Reset all constraints 
# reset_design
set TOP_DESIGN fft_multimode

analyze -format verilog $FILE_LIST
elaborate $TOP_DESIGN

#------------------------Set Current Design&&Link Designs--------------------------
current_design $TOP_DESIGN
link

#-------------------------------SDC----------------------------------
source ../scripts/sdc.tcl

#--------------------Map and Optimize the Design---------------------
compile_ultra -no_autoungroup -incremental -no_boundary_optimization
# compile_ultra
#----------------------Save Design Database--------------------------
change_names -rules verilog -hierarchy
set_fix_multiple_port_nets -all -buffer_constants
#---------------Check the Synthesized Design for Consistency---------
check_design -summary > ../syn/report/check_design.rpt
check_timing > ../syn/report/check_timing.rpt
#---------------------Report Timing and Area-------------------------
report_qor                  > ../syn/report/qor_$TOP_DESIGN.rpt
report_timing -max_paths 1000 > ../syn/report/timing_$TOP_DESIGN.rpt
report_timing -path full    > ../syn/report/full_timing_$TOP_DESIGN.rpt
report_timing -delay max    > ../syn/report/setup_timing_$TOP_DESIGN.rpt
report_timing -delay min    > ../syn/report/hold_timing_$TOP_DESIGN.rpt
report_reference            > ../syn/report/ref_$TOP_DESIGN.rpt
report_area                 > ../syn/report/area_$TOP_DESIGN.rpt
report_constraints          > ../syn/report/const_$TOP_DESIGN.rpt
report_constraint -all_violators > ../syn/report/violators_$TOP_DESIGN.rpt
report_power > ../syn/report/power_$TOP_DESIGN.rpt
check_timing > ../syn/log/last_check_timing.log

#---------------------Generate Files -------------------------
write -f verilog -hierarchy -output ../syn/mapped/$TOP_DESIGN.v
write_sdc ../syn/mapped/$TOP_DESIGN.sdc
write_sdf -context verilog ../syn/mapped/$TOP_DESIGN.sdf
write -hierarchy -format ddc -output ../syn/$TOP_DESIGN.ddc
