set this_path       [file normalize [file dirname [info script]]]
set all_prj_path    [file normalize "$this_path/../.."]

set top_lvl  axi_stream_slave
set prj_path "$all_prj_path/vivado"
#open_project $prj_path/axi_stream_slave/$top_lvl.xpr
source $this_path/export_sim_sources.tcl