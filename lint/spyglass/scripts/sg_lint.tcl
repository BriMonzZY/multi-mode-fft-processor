## Spyglass Lint sctipt v1.0
## brimonzzy
## 2025-7-6

puts "#################################"
puts "######### SG_Lint Start #########"
puts "#################################"

# set path
set WORK_HOME .
set REPORT_PATH ${WORK_HOME}/reports
puts [clock format [clock second] -format "%Y-%m-%d %H:%M:%S"]


puts "######### set top module #########"
##############################
# set top module
set TOP_MODULE "fft_multimode"
##############################


# set top waiver file
puts "######### set waiver file #########"
set TOP_WAIVER_FILE ${WORK_HOME}/waiver/${TOP_MODULE}.awl
if { ![file exists $TOP_WAIVER_FILE] } {
  exec touch $TOP_WAIVER_FILE
}

# create new project
puts "######### create new project #########"
new_project sg_lint -force

# read design file
puts "######### read design file #########"
read_file -type sourcelist ./sim_common_files.f
#read_file -type verilog {lib_xxx}  # 读入 memory、std_cell 等库文件
read_file -type awl $TOP_WAIVER_FILE
#read_file -type sgdc ${TOP_MODULE}.sgdc
set_option incdir { ${WORK_HOME}/../../rtl/src/include }

# set common option and parameter
puts "######### set common option and parameter #########"
source ${WORK_HOME}/scripts/set_option_and_parameter.tcl

# link design
puts "######### Design Read #########"
current_goal Design_Read -top ${TOP_MODULE}
link_design -force

# setup methodlogy and goal
puts "######### setup methodlogy and goal #########"
source ${WORK_HOME}/scripts/set_goal.tcl

###############################################
# set rules
puts "######### set rules #########"
source ${WORK_HOME}/scripts/set_lint_rules.tcl
###############################################

# run goal
puts "######### run goal #########"
run_goal

# report
puts "######### Reports #########"
write_report goal_summary > $REPORT_PATH/${TOP_MODULE}_goal_summary.rpt
write_report goal_setup   > $REPORT_PATH/${TOP_MODULE}_goal_setup.rpt
write_report moresimple   > $REPORT_PATH/${TOP_MODULE}_moresimple.rpt
write_report summary      > $REPORT_PATH/${TOP_MODULE}_summary.rpt
write_report waiver       > $REPORT_PATH/${TOP_MODULE}_waiver.rpt

puts "$REPORT_PATH/${TOP_MODULE}_goal_summary.rpt"
puts "$REPORT_PATH/${TOP_MODULE}_goal_setup.rpt"
puts "$REPORT_PATH/${TOP_MODULE}_moresimple.rpt"
puts "$REPORT_PATH/${TOP_MODULE}_summary.rpt"
puts "$REPORT_PATH/${TOP_MODULE}_waiver.rpt"

# save & close project
puts "######### Save and Close Project #########"
save_project -force sg_lint/sg_lint.prj
close_project -force

puts "######### Using follow command to open SG_Lint project #########"
puts "spyglass -project sg_lint/sg_lint.prj &"
puts "################################################################"
