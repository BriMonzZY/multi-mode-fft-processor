base_dir=$(abspath ../../rtl)
build_dir=$(abspath .)
ALL_MODS_FILELIST ?= $(build_dir)/top.all.f
sim_files ?= $(build_dir)/sim_files.f
sim_common_files ?= $(build_dir)/sim_common_files.f

$(sim_files):
	@touch $@ && find $(base_dir)/sim/tb_src -name "*.v" >> $@
$(ALL_MODS_FILELIST):
	@touch $@ && find $(base_dir)/src -name "*.v" -o -name "*.h" -o -name "*.vh" -o -name "*.svh" >> $@
$(sim_common_files): $(sim_files) $(ALL_MODS_FILELIST)
	@sort -u $(sim_files) $(ALL_MODS_FILELIST) | grep -v '.*\.\(svh\|h\)$$' >> $@

init: $(sim_common_files)
	@echo "generate file list"
	@rm -rf $(sim_files) $(ALL_MODS_FILELIST)


lint: init
	@mkdir -p waiver reports
	sg_shell -tcl scripts/sg_lint.tcl -shell_log_file sg_shell_command.log

open:
	spyglass -project sg_lint/sg_lint &

help:
	@echo "Usage:"
	@echo ""
	@echo "	<make init> to create file list"
	@echo "	<make lint> to lint"
	@echo "	<make open> to open saved project"
	@echo "	<make clean> to clean files"

clean:
	rm -rf $(sim_common_files) sg_shell_command.log gui_command.log waiver reports sg_lint
