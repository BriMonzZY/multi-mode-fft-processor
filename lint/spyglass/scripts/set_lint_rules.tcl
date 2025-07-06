# ########################### add rules ###########################
# goal setup中在goal上右键"Edit Rules and Parameters"可以编辑目标的选项和参数
set_goal_option addrules {'W120'}


# ########################### ignore rules ###########################
#The W446 rule flags output ports that are read in the module where they are set.
#Such models could lead to an unintended feedback path from the instantiating module in the post-synthesis simulation while this issue is not apparent 
#in the pre-synthesis simulation. Such models are also not recommended for some test tools that need to handle inout ports specially (by attaching 
#bus-holders, for example).
set_goal_option ignorerules {'W446'}

#The W280 rule flags intra-assignment delays specified with nonblocking assignments.
#Such description is unlikely to correspond to the physical implementation. However, such description may be required to use a unit delay to avoid 
#race conditions in simulation.
set_goal_option ignorerules {'W280'}

set_goal_option ignorerules {'W111'}

#Use this rule to report unregistered output from a top module./ Use this rule to report output ports in a module that are not driven by a flip-flop.
set_goal_option ignorerules {'RegOutputs'}

#The CheckDelayTimescale-ML rule reports a violation if a delay is used in a module and no timescale units are specified using the 'timescale compiler directive.
set_goal_option ignorerules {'checkDelayTimescale-ML'}

#The LogNMux rule reports multiplexer constructs in which log of the number of select input pins is greater than the specified number, that is, the logmux_max value that is 3 by default. 
set_goal_option ignorerules {'LogNMux'}

#The FlopDataConstant rule reports flip-flop instances for which the data pin is tied to a constant value.
set_goal_option ignorerules {'FlopDataConstant'}

#The sim_race01 rule reports signals that are assigned and used within the same module in the same simulation cycle. 
#This rule detects signals that are in two always constructs in the same module or one always construct and one continuous 
#assignment statement in the same module.
set_goal_option ignorerules {'sim_race01'}

#The ArrayIndex rule reports violation for the bus signals that are declared with the low-order bit first, 
#that is, it reports those multi-bit signals that do not follow the specified bit-order specification convention.
set_goal_option ignorerules {'ArrayIndex'}

#The DisabledAnd rule reports AND or NAND gate instances for which at least one input is tied low. 
#Therefore, these gate instances are effectively disabled.
set_goal_option ignorerules {'DisabledAnd'}
#The DisabledOr rule reports OR or NOR type gate instances for which at least one input is tied high. 
#Therefore, these gate instances are effectively disabled.
set_goal_option ignorerules {'DisabledOr'}

#The MuxSelConst rule reports the MUX gate instances for which the select pin is tied to a constant value.
set_goal_option ignorerules {'MuxSelConst'}

#The DiffTimescaleUsed-ML rule flags different timescales used in the design.If different timescales are used in different modules of the design, 
#then in a single simulation, delay values in one module will be different from that of other module.
set_goal_option ignorerules {'DiffTimescaleUsed-ML'}

#The LogicDepth rule reports logic paths, which originate or terminate at flip-flops or primary pins, 
#where the number of delay levels exceeds the specified value. This rule performs a simplified version of the critical path analysis.
set_goal_option ignorerules {'LogicDepth'}


#Use this command to enable reporting of incremental messages so that you can compare results of a previously run goal with the current goal.
# if { ![file exists ${WORK_HOME}/out/${TOP_MODULE}.vdb] } {
#     set_goal_option report_incr_messages yes
# 	#Specifies path of previous Violation Database file for consideration in Incremental Mode
# 	set_goal_option old_vdbfile ${WORK_HOME}/out/${TOP_MODULE}.vdb
# } else {
#     set_goal_option report_incr_messages no
# }


# ########################### change the rules' level ###########################
#The W210 rule flags a violation for module or interface instances with unconnected ports.
#The W210 rule flags message only when number of terminals are less than the number of ports. 
#The W210 rule ignores ports that are intentionally kept open (by passing extra comma [Verilog] or by connecting them to open [VHDL]).
#If any of the unconnected ports are inputs or inouts, this is an error. It may or may not be an error if the unconnected ports are outputs.
set_option overloadrules W210+severity=Error

#The W287a rule flags module or gate instances where nets connected to input ports are not driven and the instance input which are not connected.
set_option overloadrules W287a+severity=Error

#The W480 rule reports violation for those for constructs in which the loop index variable evaluates to a non-integer.
set_option overloadrules W480+severity=Error

#The W213 rule reports PLI tasks and functions used in the design.
set_option overloadrules W213+severity=Error

#Reports constant assignments that are X-extended
set_option overloadrules W342+severity=Error

#The STARC05-1.3.1.3 rule reports violation for asynchronous reset/preset signals that are used as non-reset/preset signals or as synchronous reset/preset signals.
set_option overloadrules STARC05-1.3.1.3+severity=Error

#The STARC05-2.1.4.5 rule reports violation for logical operators that are used on vector operands.
#No violation is reported for logical negation on integer variables.
set_option overloadrules STARC05-2.1.4.5+severity=Error

#Bit-width of operands of a logical operator must match. (Verilog)
#The STARC05-2.10.3.2a rule flags bit-width mismatches between operand expressions of logical operations.
#Bit-width mismatch between operands of a logical operation may lead to incorrect results.
#The STARC05-2.10.3.2a rule does not flag a relational operation if an integer constant is used as one of the operands and the width of that constant is less than or equal to the width of the other operand.
set_option overloadrules STARC05-2.10.3.2a+severity=Error

#Do not mix descriptions of flip-flops with asynchronous reset and flip-flops without asynchronous reset in the same process/always block
#The STARC05-2.3.6.1 rule flags those always or process constructs that have a flip-flop description with a reset line and another flip-flop description without a reset line.
#The STARC05-2.3.6.1 rule does not report violation for hanging flip-flops.
#Mixing the descriptions of flip-flops with and without reset lines in the same always or process construct has the following issues:
#Such description may be confusing and difficult to debug
#Such description may also cause problems for synthesis tools.
set_option overloadrules STARC05-2.3.6.1+severity=Error

#The IntReset rule reports internally generated asynchronous resets in the design.
set_option overloadrules IntReset+severity=Error

#The DisallowCaseX-ML rule reports violation for casex constructs used in the design.
set_option overloadrules DisallowCaseX-ML+severity=Error


#The W443 rule flags based numbers that contain the unknown value character (X).
#The unknown value character (X) has no physical counterpart and may lead to a mismatch between pre- and post-synthesis simulation.
#By default, the W443 rule does not check the presence of X value in the default statement of the case construct in Verilog designs. 
#Use the strict rule parameter to check in the default statement also.
#For Verilog, no rule checking is done for unused macro definitions and unused parameters.
set_option overloadrules W443+severity=Error

#A signal is included in the sensitivity list of a combinational always block but none of its bits are read in that block (Verilog)
#The W456a rule flags signals that are in the sensitivity list of a combinational always construct but are never read in the construct.
set_option overloadrules W456a+severity=Error

#Do not connect buses in reverse order
#The W156 rule flags reverse connected buses.
#Making reversed connections (for example, 15:0 connected to 0:15) is legal but bad design practice and may represent an error.
#One exception (which can be handled with a waiver) is in making a big-endian/little-endian choice in connecting to a processor bus port.
set_option overloadrules W156+severity=Error

#Reports a case expression width that does not match case select expression width
#The W263 rule reports the case clause labels whose widths do not match the width of the corresponding case construct selector.
set_option overloadrules W263+severity=Error
