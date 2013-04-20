
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name bluetoothControl -dir "L:/bluetoothControl/bluetoothControl/planAhead_run_1" -part xc6slx16csg324-3
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "bluetoothControlTL.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {UART.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {bluetoothControlTL.vhd}]]
set_property file_type VHDL $hdlfile
set_property library work $hdlfile
set_property top bluetoothControlTL $srcset
add_files [list {bluetoothControlTL.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc6slx16csg324-3
