set design_name "example"

# read in files
read_file -type sourcelist ./sim_common_files.f
# read_file -type gateslib ../../lib/ 
# read_file -type sgdc ../../src/sdc/${design_name}.sgdc

# setup
set_option top ${design_name}
# set_option sdc2sgdc yes
current_goal Design_Read -top ${design_name}
link_design -force

# run lint
current_goal lint/lint_rtl -top ${design_name}
run_goal

# save project
save_project -force
