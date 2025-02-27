## Refer to Chipyard

## by BriMon
## Email: zzybr@qq.com
##
## make simx MODEL_NAME=<tb_name>
## make run MODEL_NAME=<tb_name>
## make debug MODEL_NAME=<tb_name>
## make rundebug MODEL_NAME=<tb_name>
## make wave
## make clean
##

help:
	@echo " - make simx MODEL_NAME=<tb_name>"
	@echo " - make debug MODEL_NAME=<tb_name>"
	@echo " - make indago MODEL_NAME=<tb_name>"
	@echo " - make vdebug MODEL_NAME=<tb_name>"


#########################################################################################
# xcelium makefile
#########################################################################################
# rtl
base_dir=$(abspath ../..)
# rtl/sim/vcs
sim_dir=$(abspath .)

sim_name = xrun

#########################################################################################
# xcelium simulator types and rules
#########################################################################################
sim_prefix = simx
sim_workdir = $(build_dir)/xcelium.d
sim_run_tcl = $(build_dir)/xcelium_run.tcl
sim_debug_run_tcl = $(build_dir)/xcelium_debug_run.tcl

sim = $(sim_dir)/$(sim_prefix)-$(long_name)
sim_debug = $(sim_dir)/$(sim_prefix)-$(long_name)-debug

include $(sim_dir)/xcelium.mk

.PHONY: simx debug
simx: $(sim)
debug: $(sim_debug)


#########################################################################################
# xcelium binary and arguments
#########################################################################################
XCELIUM = xrun
XCELIUM_OPTS = $(XCELIUM_CC_OPTS) $(XCELIUM_NONCC_OPTS) $(PREPROC_DEFINES)

#########################################################################################
# xcelium build paths
#########################################################################################
model_dir = $(build_dir)/$(long_name)
model_dir_debug = $(build_dir)/$(long_name).debug

#########################################################################################
# xcelium simulator rules
#########################################################################################

$(sim_workdir): $(sim_common_files) $(output_dir)
	rm -rf $(model_dir)
	$(XCELIUM) -elaborate $(XCELIUM_OPTS) $(XCELIUM_COMMON_ARGS)

$(sim_run_tcl): $(sim_workdir)
	echo "run" >> $@
	echo "exit" >> $@

$(sim): $(sim_workdir) $(sim_run_tcl)
	echo "#!/usr/bin/env bash" > $@
	echo "$(XCELIUM) +permissive -R -input $(sim_run_tcl) $(XCELIUM_COMMON_ARGS) +permissive-off \$$INPUT_ARGS" >> $@
	chmod +x $@
	cp $(sim_prefix)-$(long_name) $(output_dir) && rm -rf $(sim_prefix)-$(long_name)
	cd $(output_dir) && ./$(sim_prefix)-$(long_name)


$(sim_debug_run_tcl): $(sim_workdir)
	echo "ida_database -open -name=\"ida.db\"" >> $@
	echo "ida_probe -log -sv_flow -uvm_reg -log_objects -sv_modules -wave -wave_probe_args= \"tb -depth all -all -memories -variables -packed 10000000 -unpacked 10000000 -dynamic\" -wave_glitch_recording" >> $@
	echo "run" >> $@
	echo "exit" >> $@

$(sim_debug): $(sim_workdir) $(sim_debug_run_tcl)
	echo "#!/usr/bin/env bash" > $@
	echo "$(XCELIUM) +permissive -R -input $(sim_debug_run_tcl) $(XCELIUM_COMMON_ARGS) +permissive-off \$$INPUT_ARGS" >> $@
	chmod +x $@
	cp $(sim_prefix)-$(long_name)-debug $(output_dir) && rm -rf $(sim_prefix)-$(long_name)-debug
	cd $(output_dir) && ./$(sim_prefix)-$(long_name)-debug

indago:
	cd $(output_dir) && indago

vdebug:
	cd $(output_dir) && verisium_debug

#########################################################################################
# create vcd rules
#########################################################################################
.PRECIOUS: $(output_dir)/%.vcd %.vcd
$(output_dir)/%.vcd: $(output_dir)/% $(sim_debug)
	(set -o pipefail && $(sim_debug) $(PERMISSIVE_ON) $(SIM_FLAGS) $(EXTRA_SIM_FLAGS) $(SEED_FLAG) $(VERBOSE_FLAGS) +vcdplusfile=$@ $(PERMISSIVE_OFF) $< </dev/null 2> >(spike-dasm > $<.out) | tee $<.log)

#########################################################################################
# general cleanup rules
#########################################################################################
.PHONY: clean clean-sim clean-sim-debug
clean:
	rm -rf $(CLASSPATH_CACHE) output $(gen_dir) $(sim_prefix)-*

clean-sim:
	rm -rf $(model_dir) $(sim) $(sim_workdir) $(sim_run_tcl) ucli.key bpad_*.err sigusrdump.out dramsim*.log

clean-sim-debug:
	rm -rf $(model_dir_debug) $(sim_debug) $(sim_workdir) $(sim_debug_run_tcl) ucli.key bpad_*.err sigusrdump.out dramsim*.log
