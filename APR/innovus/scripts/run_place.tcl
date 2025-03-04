source ../scripts/vars.tcl

setDistributeHost -local
setMultiCpuUsage -localCpu 8

restoreDesign ../data/dbs/init.enc.dat $vars(design)

place_opt_design -out_dir ../reports/synthesis -prefix place

# addTieHiLo

setPlaceMode -checkCellDRCFromPreRoute true
setOptMode  -setupTargetSlack $vars(target_setup_slack_place)

create_snapshot -name place -categories design
saveDesign ../data/dbs/place.enc -compress
