#-
#- File         : run.do
#- Company      : EmTech S.A.
#- Author       : 
#- Address      : 
#- Version      : 0.10
#- Description  : Simulation script for axi_Stream TB
###

set this_path       [file normalize [file dirname [info script]]]

# Set path variables#
set work work
set uvm_testname $1
set sv_seed $2

# # load simulation# #
vsim +UVM_TESTNAME=$uvm_testname \
  -f $this_path/libraries.conf \
  -voptargs="+acc" \
  -coverage \
  -t 1ps \
  -warning 3009 \
  axi_stream_tb_top xil_defaultlib.glbl

wm title . $uvm_testname
view wave -title "wave $uvm_testname"
