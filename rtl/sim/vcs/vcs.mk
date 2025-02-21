
ifndef USE_VPD
get_waveform_flag=+fsdbfile=$(1).fsdb
else
get_waveform_flag=+vcdplusfile=$(1).vpd
endif

CLOCK_PERIOD ?= 1.0
RESET_DELAY ?= 777.7

PLATFORM := linux64
NOVAS_PATH := ${NOVAS_HOME}/share/PLI/VCS/$(PLATFORM)

#----------------------------------------------------------------------------------------
# gcc configuration/optimization
#----------------------------------------------------------------------------------------
include $(base_dir)/sim/common-sim-flags.mk

VCS_CXXFLAGS = $(SIM_CXXFLAGS)

VCS_CC_OPTS = \
	-CFLAGS "$(VCS_CXXFLAGS)"

VCS_NONCC_OPTS = \
	-notice \
	-line \
	+lint=all,noVCDE,noONGS,noUI \
	-error=PCWM-L \
	-error=noZMMCM \
	-timescale=1ns/10ps \
	-quiet \
	-q \
	+rad \
	+vcs+lic+wait \
	+vc+list \
	-f $(sim_common_files) \
	-sverilog +systemverilogext+.sv+.svi+.svh+.svt -assert svaext +libext+.sv \
	+v2k +verilog2001ext+.v95+.vt+.vp +libext+.v \
	-debug_pp \
	-top $(TB) \
	+incdir+$(base_dir)/src/include
# -P $(NOVAS_PATH)/novas.tab $(NOVAS_PATH)/pli.a \


VCS_PREPROC_DEFINES = \
	+define+VCS

ifndef USE_VPD
VCS_PREPROC_DEFINES += +define+FSDB
endif
