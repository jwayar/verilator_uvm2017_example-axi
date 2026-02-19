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
## Author(s)          : Juan Doctorovich :
## Email              : jdoctorovich@emtech.com.ar     :
##                                                                          :
## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
##
##
## -----------------------------------------------------------------------------
# set path variables
set top_path                      [file normalize ".."]
set lib_path                      "$top_path"
set sim_path                      "$lib_path/TB"
set axi_strema_vip_path           "$top_path/Vip"
set sim_models_dir                "$top_path/TB/sim_models"
set xilinx_vip_incl_path          "$sim_path"
set rtl_wrapper_path              "$top_path/rtl"
set uvm_incl_path                 "C:/questasim64_2024.1/verilog_src/uvm-1.1d/src"

# remove work directory
catch {file delete -force $working_lib_path}
catch {file delete -force ./xil_defaultlib}
# Define paths to command modules

set uvm_testname $1

set working_lib work
set working_lib_path "./${working_lib}"

# Map library files to the work folder
vlib $working_lib_path
source "$sim_models_dir/compile.do"

# dut_path\axi_stream_receiver.vhd
#puts "$axi_stream_vip_path"
# compile components from lib
#vcom "$rtl_wrapper_path/axi_stream_master_wrapper.v"
vlog "$rtl_wrapper_path/axi_stream_master_wrapper.v"

vlog "$rtl_wrapper_path/axi_stream_receiver_wrapper.v"

# Compile axi_stream vip
source "$axi_strema_vip_path/compile.do"

# Compile VHDL testbench files

# Compile Verilog testbench files
vlog -timescale 1ps/1ps "+incdir+$uvm_incl_path" \
"$top_path/TB/axi_stream_tb_defn_pkg.sv"     \
"$top_path/TB/axi_stream_tb_env_pkg.sv"      \
"$top_path/TB/axi_stream_tb_seq_pkg.sv"      \
"$top_path/TB/axi_stream_tb_test_pkg.sv"     \
"$top_path/TB/axi_stream_tb_top.sv"
