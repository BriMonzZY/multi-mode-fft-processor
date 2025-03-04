source ../scripts/vars.tcl

setDistributeHost -local
setMultiCpuUsage -localCpu 8
setDesignMode -process 28

source ../scripts/init.tcl
source ../scripts/floorplan_atomic.tcl

checkDesign -all
# check_timing

create_snapshot -name init -categories design
saveDesign ../data/dbs/init.enc -compress

exit
