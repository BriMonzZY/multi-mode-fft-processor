## export SPYGLASS_HOME=/home/tools/synopsys/spyglass/V-2023.12-SP1/SPYGLASS_HOME


#set METHODOLOGY_TYPE initial_rtl
set METHODOLOGY_TYPE rtl_handoff

#set GOAL_TYPE all
set GOAL_TYPE mandatory


if { $METHODOLOGY_TYPE == "initial_rtl" } {
  # current_methodology can change "Goal Setup" page
  current_methodology $env(SPYGLASS_HOME)/GuideWare/latest/block/initial_rtl
  set regression_mandatory_list {lint/lint_rtl lint/lint_rtl_enhanced adv_lint/adv_lint_struct}
  set regression_optional_list  {lint/lint_turbo_rtl lint/lint_functional_rtl}
} elseif { $METHODOLOGY_TYPE == "rtl_handoff" } {
  current_methodology $env(SPYGLASS_HOME)/GuideWare/latest/block/rtl_handoff
  set regression_mandatory_list {lint/lint_rtl lint/lint_rtl_enhanced adv_lint/adv_lint_verify}
  set regression_optional_list  {lint/lint_functional_rtl lint/abstract}
} else {
  current_methodology $env(SPYGLASS_HOME)/GuideWare/latest/block/netlist_handoff
  set regression_mandatory_list {lint/lint_netlist}
  set regression_optional_list  {lint/lint_abstract}
}
append regression_all_list {regression_mandatory_list} {regression_optional_list}


if { $GOAL_TYPE == "mandatory" } {
  current_goal Group_Run -goal ${regression_mandatory_list} -top $TOP_MODULE
} elseif { $GOAL_TYPE == "optional" } {
  current_goal Group_Run -goal ${regression_optional_list} -top $TOP_MODULE
} else {
  current_goal Group_Run -goal ${regression_all_list} -top $TOP_MODULE
}
unset regression_all_list
