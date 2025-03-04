create_workspace "fft_multimode" \
  -tech /tools/PDK/tsmc28nm/tn28clpr002s1_1_5a/N28_PRTF_Syn_v1d5a/PR_tech/Synopsys/TechFile/HVH/tsmcn28_10lm7X2ZRDL.tf

read_db /tools/PDK/tsmc28nm/TSMCHOME/digital/Front_End/timing_power_noise/NLDM/tcbn28hpcplusbwp40p140_180a/tcbn28hpcplusbwp40p140ffg0p88v0c.db
read_lef /tools/PDK/tsmc28nm/TSMCHOME/digital/Back_End/lef/tcbn28hpcplusbwp40p140_110a/lef/tcbn28hpcplusbwp40p140.lef
# read_lef /tools/PDK/tsmc28nm/tn28clpr002e1_1_5a/N28_PRTF_Cad_v1d5a/PR_tech/Cadence/LefHeader/HVH/tsmcn28_10lm7X2ZRDL.tlef

# read_db /tools/PDK/tsmc28nm/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/sramsp16x256_tsmc28hpc/NLDM/sramsp16x256_tsmc28hpc_ffg0p99v0c.db
# read_lef /tools/PDK/tsmc28nm/TSMCHOME/sram/Compiler/tsn28hpcpd127spsram_20120200_180a/sramsp16x256_tsmc28hpc/LEF/sramsp16x256_tsmc28hpc.lef

check_workspace
commit_workspace -output library/ndm/fft_multimode.ndm
