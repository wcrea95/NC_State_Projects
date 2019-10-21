# TCL File Generated by Component Editor 11.0
# Tue Jul 19 13:15:52 PDT 2011


# +-----------------------------------
# | 
# | sw_reset 
# | Altera OpenCL 2011.07.19.13:15:52
# | 
# | 
# |    ./sw_reset.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 10.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module sw_reset
# | 
set_module_property DESCRIPTION "Reset pulse triggered by Avalon write"
set_module_property NAME sw_reset
set_module_property VERSION 10.0
set_module_property GROUP "ACL Internal Components"
set_module_property AUTHOR "Altera OpenCL"
set_module_property DISPLAY_NAME "ACL SW Reset"
set_module_property TOP_LEVEL_HDL_FILE sw_reset.v
set_module_property TOP_LEVEL_HDL_MODULE sw_reset
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property VALIDATION_CALLBACK validate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file sw_reset.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter WIDTH INTEGER 64
set_parameter_property WIDTH DEFAULT_VALUE 64
set_parameter_property WIDTH DISPLAY_NAME "Slave Width"
set_parameter_property WIDTH UNITS "bits" 
set_parameter_property WIDTH AFFECTS_ELABORATION true
set_parameter_property WIDTH HDL_PARAMETER true

add_parameter LOG2_RESET_CYCLES INTEGER 8
set_parameter_property LOG2_RESET_CYCLES DEFAULT_VALUE 8
set_parameter_property LOG2_RESET_CYCLES DISPLAY_NAME "How many cycles reset is asserted (log2)"
set_parameter_property LOG2_RESET_CYCLES AFFECTS_ELABORATION true
set_parameter_property LOG2_RESET_CYCLES HDL_PARAMETER true

add_parameter WIDTH_BYTES INTEGER 8
set_parameter_property WIDTH_BYTES DEFAULT_VALUE 8
set_parameter_property WIDTH_BYTES AFFECTS_ELABORATION true
set_parameter_property WIDTH_BYTES DERIVED true
set_parameter_property WIDTH_BYTES VISIBLE false

# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk ENABLED true
add_interface_port clk clk clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk_reset
# | 
add_interface clk_reset reset end
set_interface_property clk_reset associatedClock clk
set_interface_property clk_reset synchronousEdges DEASSERT
set_interface_property clk_reset ENABLED true
add_interface_port clk_reset resetn reset_n Input 1
# | 
# +-----------------------------------


# +-----------------------------------
# | connection point s
# | 
add_interface s avalon end
set_interface_property s addressAlignment DYNAMIC
set_interface_property s addressUnits WORDS
set_interface_property s associatedClock clk
set_interface_property s associatedReset clk_reset
set_interface_property s burstOnBurstBoundariesOnly false
set_interface_property s explicitAddressSpan 0
set_interface_property s holdTime 0
set_interface_property s isMemoryDevice false
set_interface_property s isNonVolatileStorage false
set_interface_property s linewrapBursts false
set_interface_property s printableDevice false
set_interface_property s setupTime 0
set_interface_property s timingUnits Cycles
set_interface_property s writeWaitTime 0
set_interface_property s ENABLED true

add_interface_port s slave_write write Input 1
add_interface_port s slave_writedata writedata Input WIDTH
add_interface_port s slave_byteenable byteenable Input WIDTH_BYTES
add_interface_port s slave_read read Input 1
add_interface_port s slave_readdata readdata Output WIDTH
add_interface_port s slave_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point sw_reset
# | 
add_interface sw_reset reset start
set_interface_property sw_reset associatedClock clk
set_interface_property sw_reset synchronousEdges DEASSERT
set_interface_property sw_reset associatedDirectReset clk_reset
set_interface_property sw_reset associatedResetSinks clk_reset
set_interface_property sw_reset ENABLED true
add_interface_port sw_reset sw_reset_n_out reset_n Output 1
# | 
# +-----------------------------------

proc validate {} {
  set width [get_parameter_value WIDTH ]
  set_parameter_value WIDTH_BYTES [expr $width / 8 ]
}