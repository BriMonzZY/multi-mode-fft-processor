
set design_name fft_multimode

set vars(netlist) "../fft_multimode.v"
# set vars(mmmc_tcl) "../scripts/view_definition.tcl"
set vars(mmmc_tcl) ""
set vars(lef_files) "/tools/PDK/tsmc28nm/tn28clpr002e1_1_5a/N28_PRTF_Cad_v1d5a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_10lm7X2ZRDL.tlef /tools/PDK/tsmc28nm/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/sramsp16x256_tsmc28hpc/LEF/sramsp16x256_tsmc28hpc.lef"
set vars(design) $design_name
set vars(rtl_design) ""
set vars(power_nets) "VDD"
set vars(ground_nets) "VSS"

set vars(site_width) "1"
set vars(row_height) "0.5"
set vars(fp_width) "350"
set vars(fp_height) "350"
set vars(fp_site)  "tsmcn28_10lm7X2ZRDL"

set vars(target_setup_slack_place) "0.005"
set vars(target_setup_slack_cts) "0.005"
set vars(target_setup_slack_postcts) "0.005"
set vars(target_hold_slack_postcts) "0.005"
set vars(target_setup_slack_route) "0.005"
set vars(target_setup_slack_postroute) "0.005"
set vars(target_hold_slack_postroute) "0.005"
