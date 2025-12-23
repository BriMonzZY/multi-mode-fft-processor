## by BriMon
## Email: zzybr@qq.com
##
## make simv MODEL_NAME=<tb_name>
## make run MODEL_NAME=<tb_name>
## make debug MODEL_NAME=<tb_name>
## make rundebug MODEL_NAME=<tb_name>
## make wave
## make clean
##

help:
	@echo " - make simv MODEL_NAME=<tb_name>"
	@echo " - make run MODEL_NAME=<tb_name>"
	@echo " - make debug MODEL_NAME=<tb_name>"
	@echo " - make rundebug MODEL_NAME=<tb_name>"
	@echo " - make wave MODEL_NAME=<tb_name>"

#########################################################################################
# vcs makefile
#########################################################################################
# rtl
base_dir=$(abspath ../..)
# rtl/sim/vcs
sim_dir=$(abspath .)

#########################################################################################
# name of simulator (used to generate *.f arguments file)
#########################################################################################
sim_name = vcs

#########################################################################################
# vcs simulator types and rules
#########################################################################################
sim_prefix = simv

sim = $(sim_dir)/$(sim_prefix)-$(long_name)
sim_debug = $(sim_dir)/$(sim_prefix)-$(long_name)-debug

include $(sim_dir)/vcs.mk

.PHONY: simv debug
simv: $(sim)
debug: $(sim_debug)

#########################################################################################
# vcs binary and arguments
#########################################################################################
VCS := vcs -full64

VCS_OPTS = $(VCS_CC_OPTS) $(VCS_NONCC_OPTS) $(SIM_PREPROC_DEFINES) $(VCS_PREPROC_DEFINES)

#########################################################################################
# vcs build paths
#########################################################################################
model_dir = $(build_dir)/$(long_name)
model_dir_debug = $(build_dir)/$(long_name).debug

#########################################################################################
# vcs simulator rules
#########################################################################################

$(sim): $(sim_common_files) $(output_dir)
	rm -rf $(model_dir)
	$(VCS) $(VCS_OPTS) -o $@ -Mdir=$(model_dir)
	cp $(sim_prefix)-$(long_name) $(output_dir) && rm -rf $(sim_prefix)-$(long_name)
	cp -r $(sim_prefix)-$(long_name).daidir $(output_dir) && rm -rf $(sim_prefix)-$(long_name).daidir

$(sim_debug): $(sim_common_files) $(output_dir)
	rm -rf $(model_dir_debug)
	$(VCS) $(VCS_OPTS) -o $@ -Mdir=$(model_dir_debug)  \
	+define+DEBUG -debug_access+all -kdb -lca
	cp $(sim_prefix)-$(long_name)-debug $(output_dir) && rm -rf $(sim_prefix)-$(long_name)-debug
	cp -r $(sim_prefix)-$(long_name)-debug.daidir $(output_dir) && rm -rf $(sim_prefix)-$(long_name)-debug.daidir

run: $(sim)
	cd $(output_dir) && ./$(sim_prefix)-$(long_name)

rundebug: $(sim_debug)
	cd $(output_dir) && ./$(sim_prefix)-$(long_name)-debug

wave:
	cd $(output_dir) && ./$(sim_prefix)-$(long_name)-debug && verdi +v2k -sv -nologo -ssf $(TB).fsdb -dbdir $(sim_prefix)-$(long_name)-debug.daidir

#########################################################################################
# general cleanup rules
#########################################################################################
.PHONY: clean clean-sim clean-sim-debug

clean:
	rm -rf $(gen_dir) $(sim_prefix)-* output ucli.key verdi_config_file

clean-sim:
	rm -rf $(model_dir) $(build_dir)/vc_hdrs.h $(sim) $(sim).daidir output ucli.key

clean-sim-debug:
	rm -rf $(model_dir_debug) $(build_dir)/vc_hdrs.h $(sim_debug) $(sim_debug).daidir output ucli.key
