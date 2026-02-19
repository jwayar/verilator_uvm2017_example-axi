## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                    ______          __            __                         :
##                   / ____/___ ___  / /____  _____/ /_                        :
##                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \                       :
##                 / /___/ / / / / / /_/  __/ /__/ / / /                       :
##                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/                        :
##                                                                             :
## This file contains confidential and proprietary information of Emtech SA.   :
## Any unauthorized copying, alteration, distribution, transmission,           :
## performance, display or other use of this material is prohibited.           :
## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                                                                             :
## Client             :                                                        :
## Version            : 1.0                                                    :
## Application        : Generic                                                :
## Filename           : compile.do                                             :
## Date Last Modified : 2025 SEP 1                                           :
## Date Created       : 2025 JUL 25                                            :
## Device             : Generic                                                :
## Design Name        : Generic                                                :
## Purpose            : QuestaSim compilation script for Stream Agent          :
## Author(s)          : Fernando Gerbino                                        :
## Email              : fgerbino@emtech.com.ar                                 :
##                                                                             :
## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
##
##
## -----------------------------------------------------------------------------


set this_path [file normalize [file dirname [info script]]]

set axi4_xilinxs       "$this_path/xillinxs_vip/axi_vip"

# # Compile VIPs
vlog -sv -timescale 1ns/1ps +incdir+$axi4_xilinxs         \
    "$axi4_xilinxs/xilinxs_vip_pkg.sv"                    \
    "$axi4_xilinxs/axi4stream_vip_axi4streampc.sv"        \
    "$axi4_xilinxs/axi4stream_vip_if.sv"