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
  -sv_seed $sv_seed \
  -voptargs="+acc" \
  -coverage \
  -t 1ps \
  -warning 3009 \
  axis_tb_top

if {[batch_mode] == 0} {
    wm title . $uvm_testname
    view wave -title "wave $uvm_testname"
}
