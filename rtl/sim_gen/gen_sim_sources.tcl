## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##                    ______          __            __
##                   / ____/___ ___  / /____  _____/ /_
##                  / __/ / __ `__ \/ __/ _ \/ ___/ __ \
##                 / /___/ / / / / / /_/  __/ /__/ / / /
##                /_____/_/ /_/ /_/\__/\___/\___/_/ /_/
##
## This file contains confidential and proprietary information of Emtech SA.
## Any unauthorized copying, alteration, distribution, transmission,
## performance, display or other use of this material is prohibited.
## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Version            : 1.0
## Application        : Generic
## Filename           : generate_sim_sources.tcl
## Date Last Modified : 2021 JUN 15
## Date Created       : 2021 MAY 27
## Device             : Generic
## Design Name        : Generic
## Purpose            : Vivado TCL script to generate simulation sources for
##                      the IP cores in a given project.
## Author(s)          : J. Quinteros del Castillo
## Email              : jquinterosdelcastillo@emtech.com.ar
##
## ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
##
## Detailed Description:
## Call this script from an open project to export all the simulation sources to
## a folder called sim_models at the same level as the project folder.

# get project name and paths
set prj_name [current_project]

# get ip list
set ip_list [get_ips]

# for each IP, generate simulation sources
# project
foreach ip $ip_list {
  # avoid IPs within block design
  if {[get_property IS_BD_CONTEXT [get_ips $ip]]} {
    continue
  }
  generate_target Simulation [get_ips $ip]
}

# generate simulation for block design
set bds_in_design [get_files -filter {FILE_TYPE == "Block Designs"}]
foreach bd $bds_in_design {
  generate_target Simulation [get_files $bd]
}
