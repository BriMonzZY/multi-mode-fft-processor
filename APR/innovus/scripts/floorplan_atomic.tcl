source ../scripts/vars.tcl

# init_design
set site_width              $vars(site_width)       ; #Unit Tile Width
set row_height              $vars(row_height)       ; #Unit Tile Height

# Macro spacing
set xOffset                 [expr $site_width * 5]
set yOffset                 [expr $row_height * 8]

set ram_halo                [expr $site_width * 10]
set ramHalo                 $ram_halo               ;# Placement halo around memories
set ramSpace                $xOffset                ;# Spacing between memories
set ramSoftBlkg             [expr $ram_halo * 3.5]  ;# Soft blockage ring around memory

#-------------------------------------------------------------------------------
# Create floorplan
#-------------------------------------------------------------------------------
set coreBoxWidth             $vars(fp_width)       ;# Core box width (better if multiple of Unit Tile Width)
set coreBoxHeight            $vars(fp_height)     ;# Core box height (better if multiple of Unit Tile Height)
set coreBoxMargin            $row_height
# floorPlan -site $vars(fp_site) -flip s -s $coreBoxWidth $coreBoxHeight $coreBoxMargin $coreBoxMargin $coreBoxMargin $coreBoxMargin
floorPlan -flip s -s $coreBoxWidth $coreBoxHeight $coreBoxMargin $coreBoxMargin $coreBoxMargin $coreBoxMargin

# Fix port placment.
fixAllIos

# Check the floorplan
checkFPlan

# Cut rows under memories
cutRow -keepCell

# Write out memory placement and IO placement.
defOut -noStdCells -floorplan ../data/[dbgDesignName].floorplan_init.def.gz

globalNetConnect $vars(power_nets) -type pgpin -pin VDD* -verbose -all
globalNetConnect $vars(ground_nets) -type pgpin -pin VSS* -verbose -all
globalNetConnect $vars(power_nets) -type tiehi -verbose -all
globalNetConnect $vars(ground_nets) -type tielo -verbose -all
# globalNetConnect $vars(power_nets) -type pgpin -pin VNW -verbose -all
# globalNetConnect $vars(ground_nets) -type pgpin -pin VPW -verbose -all

deleteAllPowerPreroutes
setAddStripeMode -optimize_stripe_for_routing_track shift
setViaGenMode -optimize_cross_via true -optimize_via_on_routing_track true

# global M9/M8
addStripe -set_to_set_distance 15 -spacing 4 -start_offset 2.5 -layer M9 -width 3.5 -nets "$vars(ground_nets) $vars(power_nets)" -stacked_via_bottom_layer M8 -stacked_via_top_layer AP -direction vertical -extend_to design_boundary
addStripe -set_to_set_distance 15 -spacing 4 -start_offset 2.5 -layer M8 -width 3.5 -nets "$vars(ground_nets) $vars(power_nets)" -stacked_via_bottom_layer M7 -stacked_via_top_layer M9 -direction horizontal -extend_to design_boundary

# global M7
addStripe -set_to_set_distance 12.32 -spacing 5.93 -start_offset 0.165 -layer M7 -width 0.23 -nets "$vars(ground_nets) $vars(power_nets)" -stacked_via_bottom_layer M6 -stacked_via_top_layer M8 -direction vertical
# core M3
foreach b [dbShape -output rect [dbShape [dbShape [dbget top.fplan.boxes] ANDNOT [dbget top.fplan.rows.box]] SIZE -[expr $row_height/2]]] {
    createRouteBlk -box $b -layer all -spacing 0 -name tempBlk
}
addStripe -set_to_set_distance 12.32 -spacing 6.072 -start_offset 0.25 -layer M3 -width 0.088 -nets "$vars(ground_nets) $vars(power_nets)" -stacked_via_bottom_layer M3 -stacked_via_top_layer M3 -direction vertical
deleteRouteBlk -name tempBlk

## M1 sroute
sroute -nets "$vars(power_nets) $vars(ground_nets)" \
   -connect {corePin} \
   -layerChangeRange {1 1} \
   -targetViaLayerRange {1 1} \
   -crossoverViaLayerRange {1 1} \
   -corePinCheckStdcellGeoms \
   -allowJogging 1 \
   -allowLayerChange 1 \
   -corePinTarget none

colorizeGeometry -reset
colorizeGeometry


checkFPlan

defOut -noStdCells -floorplan ../data/[dbgDesignName].scan.floorplan_mesh.def.gz


set defOutLefNDR 1
set defOutLefVia 1
defOut -floorplan -noStdCells ../constraints/[dbgDesignName].floorplan.def.gz

saveDesign ../data/dbs/floorplan.enc

