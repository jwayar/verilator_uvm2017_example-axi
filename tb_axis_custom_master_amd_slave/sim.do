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
## Filename           : sim.do                                                 :
## Date Last Modified : 2025 SEP 1                                           :
## Date Created       : 2025 JUL 25                                            :
## Device             : Generic                                                :
## Design Name        : Generic                                                :
## Purpose            : QuestaSim simulation script for Stream Agent Testbench :
## Author(s)          : Fernando Gerbino                                        :
## Email              : fgerbino@emtech.com.ar                                 :
##                                                                             :
## :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
##
##
## -----------------------------------------------------------------------------
proc get_unique_transcript_name {path base_name seed} {
  # Get the current date in YYYYMMDD format
  set current_date [clock format [clock seconds] -format "%Y%m%d"]
  set current_time [clock format [clock seconds] -format "%H%M"]

  set i 0
  set file_name "${path}${current_date}_${current_time}_${base_name}_${seed}.log"
  while {[file exists $file_name]} {
    incr i
    set file_name "${path}${current_date}_${current_time}_${base_name}_${seed}_${i}.log"
  }
  return $file_name
}

# Check if the 'logs' directory exists, if not, create it
if {![file isdirectory "logs"]} {
  file mkdir logs
}
# set path variables

# Test names list
puts ""
puts [string repeat "-" 72]
puts "Available tests:"
set test_names {
  axis_tb_main_test
}
puts [string repeat "-" 72]

# If no test name is entered print test names and exit.
if {($argc == 0) || ($1 ni $test_names)} {
  puts "Usage: do sim.do \[test_name\]"
  puts "Please select one of the available tests."
  return
}

# use Visual Studio Code as external editor. COMMENT WHOLE SECTION if external_editor_path is not correct.
# set external_editor_path                "C:/Users/thebi/AppData/Local/Programs/Microsoft VS Code/Code.exe"
proc external_editor {filename linenumber} {
  exec "$::external_editor_path" -g "$filename:$linenumber"
}
set PrefSource(altEditor) external_editor
proc toggle_editor {} {
  if {$::PrefSource(altEditor) eq ""} {
    echo "Setting external editor."
    set ::PrefSource(altEditor) external_editor
  } else {
    echo "Setting internal editor."
    set ::PrefSource(altEditor) ""
  }
}

# Argumento 4: sv_seed (opcional)
if {$argc > 3} {
  set sv_seed $4
} else {
  set sv_seed [expr {int(rand() * 1000000)}]
}

# Asignar argumentos obligatorios
set uvm_testname $1

# Define the base name for the transcript file
set base_transcript_file "${uvm_testname}"
set log_path "logs/"

# Generate a unique transcript file name
set transcript_file [get_unique_transcript_name $log_path $base_transcript_file $sv_seed]

# Open the transcript file
transcript file $transcript_file

# quit previous simulation
quit -sim

# Clean up temporary files from previous simulations
foreach file [glob -nocomplain ./wlft*] {
  set objectFile [file tail [file rootname $file]]
  catch {file delete $objectFile}
}

set transcript_file "questa.log"

do prepare.do $uvm_testname
do run.do $uvm_testname $sv_seed

if {[batch_mode] == 0} {
    ## load waveform
    do wave.do
}

## run simulation
run -a

if {[batch_mode] == 0} {
    ## adjust the zoom
    wave zoom full 
}

# simulation time
simstats