## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                    ______          __            __                      :
##                   / ____/___ ___  / /____  _____/ /_                     :
##                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                    :
##                 / /___/ / / / / / /_/  __/ /__/ / / /                    :
##                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                     :
##                                                                          :
## This file contains confidential and proprietary information of Emtech SA.:
## Any unauthorized copying, alteration, distribution, transmission,        :
## performance, display or other use of this material is prohibited.        :
## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                                                                          :
## Client             : Emtech                                              :
## Version            : 1.0                                                 :
## Application        : AXI TB                                              :
## Filename           : prepare.do                                          :
## Date Last Modified : 2025 JAN 27                                         :
## Date Created       : 2025 JAN 27                                         :
## Device             : Generic                                             :
## Design Name        : Generic                                             :
## Purpose            : QuestaSim compilation script for AXI TB             :
## Author(s)          : Fernando Gerbino :
## Email              : fgerbino@emtech.com.ar     :
##                                                                          :
## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
##
##
## -----------------------------------------------------------------------------
# set path variables
set top_path                      [file normalize ".."]
set sim_path                      "$top_path/tb_axis_custom_master_amd_slave"
set axis_vip_path                 "$top_path/Vip"

set main_vip_path                 [file normalize "../.."]
set utils_path                    "$main_vip_path/utils/src"
set axis_amd_path                 "$main_vip_path/amd_axi_stream_vip"

# remove work directory
catch {file delete -force $working_lib_path}
catch {file delete -force ./xil_defaultlib}
# Define paths to command modules

set uvm_testname $1

set working_lib work
set working_lib_path "./${working_lib}"

# Map library files to the work folder
vlib $working_lib_path

# Compile axi_stream vip (AMD)
source "$axis_amd_path/compile.do"
# Compile axi_stream vip (Custom)
source "$axis_vip_path/compile.do"

# Compile Verilog testbench files
vlog -timescale 1ps/1ps -cover bcesft \
"$utils_path/utils_pkg.sv"                \
"$sim_path/axis_tb_defn_pkg.sv"           \
"$sim_path/axis_tb_scoreboard_pkg.sv"     \
"$sim_path/axis_tb_env_pkg.sv"            \
"$sim_path/axis_tb_test_pkg.sv"           \
"$sim_path/axis_tb_top.sv"
