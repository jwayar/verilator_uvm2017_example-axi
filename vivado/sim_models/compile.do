# Please make sure of the following before simulating: 
    # * All libraries listed in $sim_models_dir/config/libraries.conf are added to vopt/vsim 
    # * All other files present in $sim_models_dir/config are linked/copied to the directoty where 
    # the simulation is being run from
    # * The appropiate top module is used (the RTL top, or the sim_wrapper if compiled in this file
vlog -work xil_defaultlib -L xilinx_vip -64 -incr -mfcu "+incdir+$sim_models_dir/incl" "+incdir+$xilinx_vip_incl_path"\
  "$sim_models_dir/src/axi_stream_receiver_256_axi_traffic_gen_0_0.v" \
  "$sim_models_dir/src/axi_stream_receiver_256.v" \

vlog -work xil_defaultlib -L xilinx_vip -64 -incr -mfcu "+incdir+$sim_models_dir/incl" "+incdir+$xilinx_vip_incl_path"\
  "$sim_models_dir/src/glbl.v" \

