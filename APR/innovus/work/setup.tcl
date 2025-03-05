# By BriMonzZY


set design_name fft_multimode
set vars(design) $design_name
set vars(rtl_design) $vars(design)
set init_verilog "../fft_multimode.v"
set vars(fp_file) "fft_multimode.fp"

set init_lef_file "/tools/PDK/tsmc28nm/tn28clpr002e1_1_5a/N28_PRTF_Cad_v1d5a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_10lm7X2ZRDL.tlef"
set vars(lef_files) "/tools/PDK/tsmc28nm/tn28clpr002e1_1_5a/N28_PRTF_Cad_v1d5a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_10lm7X2ZRDL.tlef \
   /tools/PDK/tsmc28nm/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp40p140_110a/lef/tcbn28hpcplusbwp40p140.lef"
set init_top_cell $vars(design)
set init_gnd_net VSS
set init_pwr_net VDD
set vars(cts_cells) clk

set vars(local_cpus) 8
set vars(process) 28;# e.g. 16, 28

set vars(rc_corners) "cworst_m40c cbest_125c ctyp_85c cworst_125c"
set vars(delay_corners) "dc_slow_corner_cworst_m40c dc_typ_corner_ctyp_85c dc_fast_corner_cbest_125c"
set vars(constraint_modes) "merged" ;# set vars(constraint_modes) "merged merged_1g"

set slow_corner			ssgnp_0p90v_m40c ;# e.g. ssgnp_0p72v_0c
set typ_corner			tt_1p00v_85c     ;# e.g. tt_0p80v_85c
set fast_corner			ffgnp_1p05v_125c ;# e.g. ffgnp_0p88v_125c

set vars(merged_slow_corner_cworst_m40c,delay_corner)     [lindex $vars(delay_corners) 0]
set vars(merged_fast_corner_cbest_125c,delay_corner)      [lindex $vars(delay_corners) 2]
set vars(merged_slow_corner_cworst_m40c,constraint_mode)	[lindex $vars(constraint_modes) 0]
set vars(merged_fast_corner_cbest_125c,constraint_mode)		[lindex $vars(constraint_modes) 0]
set vars(dc_fast_corner_cbest_125c,rc_corner)             [lindex $vars(rc_corners) 1]
set vars(dc_typ_corner_ctyp_85c,rc_corner)		            [lindex $vars(rc_corners) 2]
set vars(dc_fast_corner_cbest_125c,library_set)		        $fast_corner
set vars(dc_typ_corner_ctyp_85c,library_set)		          $typ_corner
set vars(dc_slow_corner_cworst_m40c,library_set)	        $slow_corner
set vars(dc_slow_corner_cworst_m40c,rc_corner)		        [lindex $vars(rc_corners) 0]

set vars(setup_analysis_views)  "merged_slow_corner_cworst_m40c"
set vars(hold_analysis_views)   "merged_fast_corner_cbest_125c"
set vars(setup_analysis_views)  "merged_slow_corner_cworst_m40c"
set vars(hold_analysis_views)   "merged_fast_corner_cbest_125c"

set vars(default_setup_view)    [lindex $vars(setup_analysis_views) 0]
set vars(default_hold_view)     [lindex $vars(hold_analysis_views) 0]
set vars(active_setup_views)		$vars(setup_analysis_views)
set vars(active_hold_views)     $vars(hold_analysis_views)

set qrc_file(cworst)   "/tools/PDK/tsmc28nm/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a/RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_cworst_T/qrcTechFile"
set qrc_file(cbest)    "/tools/PDK/tsmc28nm/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a/RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_cbest/qrcTechFile"
set qrc_file(rcworst)  "/tools/PDK/tsmc28nm/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a/RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_rcworst_T/qrcTechFile"
set qrc_file(rcbest)   "/tools/PDK/tsmc28nm/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a/RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_rcbest/qrcTechFile"
set qrc_file(typical)  "/tools/PDK/tsmc28nm/RC_QRC_cln28hpc+_1p10m_5x2y2z_ut-alrdl_9corners_1.3a/RC_QRC_cln28hpc+_1p10m+ut-alrdl_5x2y2z_typical/qrcTechFile"
set vars(cworst_m40c,qx_tech_file)	  $qrc_file(cworst)
set vars(cbest_125c,qx_tech_file)			$qrc_file(cbest)
set vars(ctyp_85c,qx_tech_file)				$qrc_file(typical)
set vars(cworst_125c,qx_tech_file)		$qrc_file(cworst)

set stdcell_library($fast_corner)   "/tools/PDK/tsmc28nm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a/tcbn28hpcplusbwp40p140ffg0p88v0c.lib"
set stdcell_library($slow_corner)   "/tools/PDK/tsmc28nm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a/tcbn28hpcplusbwp40p140ffg0p88v0c.lib"
set stdcell_library($typ_corner)    "/tools/PDK/tsmc28nm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a/tcbn28hpcplusbwp40p140ffg0p88v0c.lib"

set macro_ctl_list                [list ]
set macro(lef)                    [list ]
set macro_library($slow_corner)   [list ]
set macro_library($typ_corner)    [list ]
set macro_library($fast_corner)   [list ]
set vars(library_sets)        [list $slow_corner $typ_corner $fast_corner]
set vars($slow_corner,timing) [concat $stdcell_library($slow_corner) $macro_library($slow_corner)]
set vars($typ_corner,timing)  [concat $stdcell_library($typ_corner)  $macro_library($typ_corner)]
set vars($fast_corner,timing) [concat $stdcell_library($fast_corner) $macro_library($fast_corner)]

set vars(merged,pre_cts_sdc) "../fft_multimode.sdc"
