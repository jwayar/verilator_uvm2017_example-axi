set scripts_path [file dirname [file normalize [info script]]]

# check if a project is open. If not this will raise an error
set current_prj_name [current_project]
set current_prj_vivado_path [get_property DIRECTORY $current_prj_name]
# project is in vivado folder
set current_prj_path [file normalize $current_prj_vivado_path/..]
set sim_models_path $current_prj_path/sim_models

# generate simulation sources
source $scripts_path/gen_sim_sources.tcl

# create temp dir
set temp_dir [file normalize _temp]
if {[file exists $temp_dir]} {
  file delete -force $temp_dir
}
file mkdir $temp_dir

# export simulation to temp dir, copying sources
export_simulation -force -directory $temp_dir -export_source_files -simulator questa

if {[file exists $sim_models_path]} {
  catch {
    file delete -force $sim_models_path
  }
}
file mkdir $sim_models_path

proc run_py {script_path args} {
  # Save original environment variables
  set PYTHONPATH_bak $::env(PYTHONPATH)
  set PYTHONHOME_bak $::env(PYTHONHOME)
  set PATH_bak $::env(PATH)

  # Split PATH and PYTHONPATH into lists
  set path_list [split $PATH_bak ":"]
  set pythonpath_list [split $PYTHONPATH_bak ":"]

  # Remove each PYTHONPATH_bak path from PATH
  foreach path $pythonpath_list {
    set index [lsearch $path_list $path]
    if {$index != -1} {
      set path_list [lreplace $path_list $index $index]
    }
  }
  # Join the modified list back into a string and set it as the new PATH
  set new_PATH [join $path_list ":"]
  set ::env(PATH) $new_PATH

  # Unset PYTHONPATH and PYTHONHOME
  unset ::env(PYTHONPATH)
  unset ::env(PYTHONHOME)

  # Prepare the Python script command
  set cmd [concat $script_path {*}$args]

  # Run the Python script and catch any errors
  if {[catch {exec {*}py {*}$cmd} result]} {
    # Restore original environment variables
    set ::env(PYTHONPATH) $PYTHONPATH_bak
    set ::env(PYTHONHOME) $PYTHONHOME_bak
    set ::env(PATH) $PATH_bak
    # Rethrow the error
    return -code error $result
  }

  # Restore original environment variables
  set ::env(PYTHONPATH) $PYTHONPATH_bak
  set ::env(PYTHONHOME) $PYTHONHOME_bak
  set ::env(PATH) $PATH_bak
}

run_py $scripts_path/filter_sim_sources.py [list $temp_dir/questa/file_info.txt $sim_models_path]

file delete -force $temp_dir
