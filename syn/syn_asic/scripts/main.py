
import os

script1_file_dir = "/home/yian/workspace/seq_detector/syn/syn_asic/scripts/synflow.tcl"
script2_file_dir = "/home/yian/workspace/seq_detector/syn/syn_asic/scripts/sdc.tcl"
design_file_dir = "/home/yian/workspace/seq_detector/rtl/src"

def CopyScript():
	os.system('cp {} ../syn/script/'.format(script1_file_dir))
	os.system('cp {} ../syn/script/'.format(script2_file_dir))


def create_SynFlow(design):
	text = """
#--------------------------Specify Libraries--------------------------
set search_path    "$search_path /home/yian/workspace/seq_detector/syn/syn_asic/db/tsmc90"
set target_library "fast.db"
set link_library   "* fast.db"
set symbol_library "tsmc090.sdb"

echo "\n\nSettings:"
echo "search_path: $search_path"
echo "link_library: $link_library"
echo "target_library: $target_library"
echo "\n\nI'm Ready!"
#--------------------------Prepare Filelist---------------------------
set FILE_LIST ""
set f [open "../scripts/files_syn.fl" r]
while {![eof $f]} {
    gets $f line
    append FILE_LIST "$line "
}
echo $FILE_LIST
close $f

#--------------------------Read Designs------------------------------

# Reset all constraints 
# reset_design

set TOP_DESIGN seq_detector
analyze -format verilog $FILE_LIST
elaborate $TOP_DESIGN

#------------------------Set Current Design&&Link Designs--------------------------
#current_design $TOP_DESIGN(auto)
#link(auto)

#-------------------------------SDC----------------------------------
source ../syn/script/sdc.tcl

#--------------------Map and Optimize the Design---------------------
compile_ultra -no_autoungroup -incremental -no_boundary_optimization
#----------------------Save Design Database--------------------------
change_names -rules verilog -hierarchy
set_fix_multiple_port_nets -all -buffer_constants
#---------------Check the Synthesized Design for Consistency---------
check_design -summary > ../syn/report/check_design.rpt
check_timing > ../syn/report/check_timing.rpt
#---------------------Report Timing and Area-------------------------
report_qor                  > ../syn/report/$TOP_DESIGN.qor_rpt
report_timing -max_paths 1000 > ../syn/report/$TOP_DESIGN.timing_rpt
report_timing -path full    > ../syn/report/$TOP_DESIGN.full_timing_rpt
report_timing -delay max    > ../syn/report/$TOP_DESIGN.setup_timing_rpt
report_timing -delay min    > ../syn/report/$TOP_DESIGN.hold_timing_rpt
report_reference            > ../syn/report/$TOP_DESIGN.ref_rpt
report_area                 > ../syn/report/$TOP_DESIGN.area_rpt
report_constraints          > ../syn/report/$TOP_DESIGN.const_rpt
report_constraint -all_violators > ../syn/report/$TOP_DESIGN.violators_rpt
report_power > ../syn/report/$TOP_DESIGN.power_rpt
check_timing > ../syn/log/last_check_timing.log
#---------------------Generate Files -------------------------
write -f verilog -hierarchy -output ../syn/mapped/$TOP_DESIGN.v
write_sdc ../syn/mapped/$TOP_DESIGN.sdc
write_sdf -context verilog ../syn/mapped/$TOP_DESIGN.sdf

"""
	return text


def create_Sdc(design):
	text = """
#==================================Env Vars===================================
set RST_NAME				rst_n
set CLK_NAME				clk

set CLK_PERIOD_I		7
set CLK_PERIOD            	[expr $CLK_PERIOD_I*0.95]
set CLK_SKEW              	[expr $CLK_PERIOD*0.01]
set CLK_SOURCE_LATENCY   	[expr $CLK_PERIOD*0.1]    
set CLK_NETWORK_LATENCY   	[expr $CLK_PERIOD*0.1]  
set CLK_TRAN             	[expr $CLK_PERIOD*0.01]

set INPUT_DELAY_MAX         [expr $CLK_PERIOD*0.4]
set INPUT_DELAY_MIN           0
set OUTPUT_DELAY_MAX        [expr $CLK_PERIOD*0.4]
set OUTPUT_DELAY_MIN          0

set MAX_FANOUT             6
set MAX_TRAN               5
set MAX_CAP                1.5

set ALL_INPUT_EX_CLK [remove_from_collection [all_inputs] [get_ports $CLK_NAME]]
#==================================Define Design Environment=========================
#GUIDANCE: use the default
set_max_area 0
#set_max_transition  $MAX_TRAN     [current_design]
#set_max_fanout      $MAX_FANOUT   [current_design]
#set_max_capacitance $MAX_CAP      [current_design]

#============================= Set Design Constraints=========================
#--------------------------------Clock and Reset Definition----------------------------
set_drive 0 [get_ports $CLK_NAME]
create_clock -name $CLK_NAME -period $CLK_PERIOD [get_ports $CLK_NAME]
set_dont_touch_network [get_ports $CLK_NAME]

set_clock_uncertainty $CLK_SKEW [get_clocks $CLK_NAME]
set_clock_transition  $CLK_TRAN [all_clocks]
set_clock_latency -source $CLK_SOURCE_LATENCY [get_clocks $CLK_NAME]
set_clock_latency -max $CLK_NETWORK_LATENCY [get_clocks $CLK_NAME]
#rst_ports
set_drive 0            				[get_ports $RST_NAME]
set_dont_touch_network 				[get_ports $RST_NAME]
set_false_path -from   				[get_ports $RST_NAME] 
set_ideal_network -no_propagate     [get_ports $RST_NAME]
set_ideal_network -no_propagate     [get_ports $CLK_NAME]


#--------------------------------I/O Constraint-----------------------------
set_input_delay   -max $INPUT_DELAY_MAX   -clock $CLK_NAME   $ALL_INPUT_EX_CLK
set_input_delay   -min $INPUT_DELAY_MIN   -clock $CLK_NAME   $ALL_INPUT_EX_CLK -add
set_output_delay  -max $OUTPUT_DELAY_MAX  -clock $CLK_NAME   [all_outputs]
set_output_delay  -min $OUTPUT_DELAY_MIN  -clock $CLK_NAME   [all_outputs] -add
set_load  0.2 	[all_outputs]	

"""
	return text


def createFile():
	prjname = "seq_detector"
	with open(f"../syn/script/synflow.tcl", "w") as f:
		synflow = create_SynFlow(prjname)
		f.write(synflow)

	with open(f"../syn/script/sdc.tcl", "w") as f:
		sdc = create_Sdc(prjname)
		f.write(sdc)


if __name__ == "__main__":
	os.system('rm -rf ../syn ./files_syn.fl ../temp')
	os.system('mkdir -p ../syn/mapped ../syn/report ../syn/script ../syn/unmapped ../syn/log ../temp')
	createFile()
	os.system("find /home/yian/workspace/seq_detector/rtl/src/ -name \"*.v\" > files_syn.fl")
	# CopyScript()
	os.system("cp .synopsys_dc.setup ../temp") # copy dc setup file
	os.system('cd ../temp && dc_shell -f ../syn/script/synflow.tcl -output_log_file ../syn/log/syn.log')
	
