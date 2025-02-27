## by BriMon
## Email: zzybr@qq.com
## DC synthesis flow
##
## make syn MODEL_NAME=<top_name> CLK=<clock_name> RST=<reset_name>
## make clean
##

## parameter
MODEL_NAME?=fft_multimode
CLK?=clk
RST?=rst_n


DC:=dc_shell

base_dir:=$(abspath .)
db_dir:=$(base_dir)/db
output_dir:=$(base_dir)/output
syn_reslut_dir:=$(base_dir)/syn
script_dir:=$(base_dir)/scripts
rtl_src_dir:=$(base_dir)/../../rtl/src

syn_files ?= $(syn_reslut_dir)/syn_files.f

help:
	@echo " - make syn MODEL_NAME=<top_name> RST=<reset_name> CLK=<clock_name>"
	@echo " - make clean"


.PHONY: syn clean

syn: $(syn_files) update_synflow
	cd output && $(DC) -f $(script_dir)/synflow.tcl -output_log_file ./syn/log/syn.log

update_synflow:
	sed -i 's/^set TOP_DESIGN .*/set TOP_DESIGN $(MODEL_NAME)/' $(script_dir)/synflow.tcl
	sed -i 's/^set RST_NAME .*/set RST_NAME $(RST)/' $(script_dir)/sdc.tcl
	sed -i 's/^set CLK_NAME .*/set CLK_NAME $(CLK)/' $(script_dir)/sdc.tcl

$(output_dir):
	mkdir -p $@

$(syn_reslut_dir):
	mkdir -p $@ && mkdir -p $(syn_reslut_dir)/mapped $(syn_reslut_dir)/report $(syn_reslut_dir)/unmapped $(syn_reslut_dir)/log

$(syn_files): | $(syn_reslut_dir) $(output_dir)
	touch $@ && find $(rtl_src_dir) -name "*.v" -o -name "*.h" -o -name "*.vh" -o -name "*.svh" >> $@

clean:
	rm -rf output syn
