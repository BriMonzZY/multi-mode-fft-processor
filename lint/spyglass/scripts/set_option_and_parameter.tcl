## refer to "SpyGlass_Explorer_UserGuide.pdf"

set_option top ${TOP_MODULE}

# Use this design-read option to specify macro definitions in your Verilog analysis run.
set_option define {RD = 0}

#Use this design-read option to specify a top-level module so that all design units instantiated directly 
#or indirectly under this module are included in the scope of SpyGlass analysis.
set_option top $TOP_MODULE

#Use this design-read option to enable or disable SystemVerilog
#compatibility mode. By default, this option is disabled.
set_option enableSV yes

#Use this command to enable parsing of SystemVerilog constructs.
#By default, SpyGlass reports SystemVerilog constructs as syntax errors.
set_option enableSV09 yes

#Use this command to specify the operating language for the current SpyGlass run.
set_option language_mode mixed

#Use this command to specify a default waiver file for saving interactive
#waiver commands. If you do not specify a default waiver file by using this command, SpyGlass
#Explorer considers the <project-wdir>/<project_name>.awl file as the default waiver file.
set_option default_waiver_file $TOP_WAIVER_FILE

#Disables flattening during the compile_design command in the sg_shell.
#Also disables flattening while opening a project, if the project was closed with a flattened view.
set_option designread_disable_flatten no

#The default value of the enable_save_restore option is yes.
#Use this design-read option to view built-in messages during the restore
#run that were reported during the save run.
set_option enable_save_restore no

#Use this design-read option to translate design attributes from SDC format
#to SGDC format. These attributes are then used during SpyGlass analysis.
set_option sdc2sgdc yes

#Use this command to print the waived messages in the waiver report when
#the -ip argument of the waive constraint is specified. By default, only
#the count of waived messages is reported in the waiver report.
set_option report_ip_waiver yes

#If you set the force_gateslib_autocompile command to yes to
#automatically compile gate libraries, any criteria for re-compilation of gate
#libraries is not evaluated. In such cases, the specified .lib files are always
#compiled and these files overwrite the existing .sglib file present in the
#cache directory.
set_option force_gateslib_autocompile yes


# ##################### set parameters #####################
#Specifies whether the related rules check the bit_width as per LRM.
#By default, the nocheckoverflow rule parameter is set to no, and the affected rules do not check the bit-width as per LRM.
#Lint: W116, W164a, W164b, W164c, W486, W110, W263, W362
set_parameter nocheckoverflow no

#(Optional) Causes the CombLoop rule to proceed from enable pin to Q (output) pin of a latch, while detecting the combinational loop.
#By default, the enableE2Q rule parameter is unset and the CombLoop rule does not traverse through latches for locating combination loops.
set_parameter enableE2Q yes

#The default value is no. Set this parameter toyes to use the automatically-generated clock information.
#NOTE: This is the parameter of SpyGlass CDC solution
set_parameter use_inferred_clocks yes

#Specifies whether the STARC02-2.10.3.7 rule reports a violation for hexal, octal, and decimal based 
#numbers if the width specified is greater than the actual bit-width of the based number.
#The STARC02-2.10.3.7 rule reports based numbers where the bit-width definition and specified value do not match.
#If the bit-width definition-part and the value part does not match like the examples below, it can easily lead to mistakes:
#a = 3'b11111111;
#a = 3'b11;
set_parameter ignore_based_width yes

#Specifies whether the STARC-2.11.3.1 rule reports a violation for sequential block infer counter logic.
#By default, the value of the ignore_fsm_counter parameter is set to no and the STARC-2.11.3.1 rule reports a violation for sequential block infer 
#counter logic.Set the value of this parameter to yes to ignore violations for such cases.This parameter is only applicable for Verilog.
#STARC-2.11.3.1 : Ensure that the sequential and combinational parts of an FSM description should be in separate always blocks. (Verilog)
#Use this rule to report detect the sequential and combinational parts of an FSM that are in the same always or sequential blocks.
set_parameter ignore_fsm_counter yes

#(Optional) Specifies the maximum number of logic levels beyond which the LogicDepth rule should flag an error message.
set_parameter delaymax 250

#Enables the W164a, W164b, W116, and W362 rules to report a violation for static expressions and non-static expressions that contain static 
#expressions.By default, this parameter is set to no. In this case, the specified rules do not report a violation for static expressions and non-static #expressions that contain static expressions.
set_parameter check_static_value yes
