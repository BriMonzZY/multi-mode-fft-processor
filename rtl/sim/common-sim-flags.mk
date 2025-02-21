#----------------------------------------------------------------------------------------
# common gcc configuration/optimization
#----------------------------------------------------------------------------------------

SIM_OPT_CXXFLAGS := -O3
MAX_CPU := $(shell nproc)


MODEL_NAME ?= bsh_32_tb

TB = $(MODEL_NAME)
long_name = $(MODEL_NAME)


SIM_CXXFLAGS = \
	$(SIM_OPT_CXXFLAGS) \
	-std=c++17

CLOCK_PERIOD ?= 1.0
RESET_DELAY ?= 777.7

SIM_PREPROC_DEFINES = \
	+define+CLOCK_PERIOD=$(CLOCK_PERIOD) \
	+define+RESET_DELAY=$(RESET_DELAY)


# rtl
base_dir=$(abspath ../..)
# rtl/sim/vcs
sim_dir=$(abspath .)

generated_src_name ?= generated-src
gen_dir =$(sim_dir)/$(generated_src_name)
build_dir =$(gen_dir)/$(long_name)
output_dir=$(sim_dir)/output/$(long_name)

ALL_MODS_FILELIST ?= $(build_dir)/top.all.f
sim_files ?= $(build_dir)/sim_files.f
sim_common_files ?= $(build_dir)/sim_common_files.f



$(build_dir):
	mkdir -p $@

$(output_dir):
	mkdir -p $@

$(sim_files): | $(build_dir)
	touch $@ && find $(base_dir)/sim/tb_src -name "*.v" >> $@

$(ALL_MODS_FILELIST): | $(build_dir)
	touch $@ && find $(base_dir)/src -name "*.v" -o -name "*.h" -o -name "*.vh" -o -name "*.svh" >> $@

$(sim_common_files): $(sim_files) $(ALL_MODS_FILELIST)
	sort -u $(sim_files) $(ALL_MODS_FILELIST) | grep -v '.*\.\(svh\|h\)$$' >> $@
