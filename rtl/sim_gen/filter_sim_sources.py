import sys
import csv
import os.path
import shutil
import pathlib


vlog_sv_cmd = "vlog -work xil_defaultlib -L xilinx_vip -64 -incr -mfcu -sv \"+incdir+$sim_models_dir/incl\" \"+incdir+$xilinx_vip_incl_path\"\\"
vlog_v_cmd = "vlog -work xil_defaultlib -L xilinx_vip -64 -incr -mfcu \"+incdir+$sim_models_dir/incl\" \"+incdir+$xilinx_vip_incl_path\"\\"
vcom_cmd = "vcom -work xil_defaultlib -64 -93 \\"

def flatten_directory(input_path, output_path):
  for root, _, files in os.walk(input_path):
    for file in files:
      source_file = os.path.join(root, file)
      destination_file = os.path.join(output_path, file)

      # Move the file to the output path
      shutil.move(source_file, destination_file)


def group_sim_sources_by_type(sim_sources: list) -> list:
  grouped_sim_sources = []

  first = 1
  for line in sim_sources:
    if first:
      first = 0
      group = []
      curr_file_type = line['FILE_TYPE']
      group.append(line)
    else:
      if(line['FILE_TYPE'] == curr_file_type):
        group.append(line)
      else:
        grouped_sim_sources.append(group)
        group = []
        curr_file_type = line['FILE_TYPE']
        group.append(line)

  grouped_sim_sources.append(group)

  return grouped_sim_sources


def filter_sim_sources(file_name: str) -> list:
  sim_sources = []

  if not os.path.exists(file_name):
    print('File {} not found'.format(file_name))
    return []

  with open(file_name,'r') as csvfile:
    headers = ['FILE_NAME','FILE_TYPE','LIBRARY','LOCATION','INCLUDE_DIR']
    reader = csv.DictReader(csvfile,fieldnames=headers, delimiter=',')
    for line in reader:
      print(line)
      if (
        (line['LIBRARY'] == 'xil_defaultlib' and line['LOCATION'].startswith('srcs/ip')) or
        (line['FILE_NAME'].endswith('_sim_wrapper.v')) or
        (line['FILE_NAME'] =='glbl.v')):
        sim_sources.append(line)

  sim_sources = group_sim_sources_by_type(sim_sources)
  return sim_sources


def copy_sim_sources(sim_sources: list,base_path:str,target_location:str):
  # create target dirs
  config_target_location = os.path.join(target_location,'config')
  if (not os.path.exists(config_target_location)):
    os.makedirs(config_target_location)
  src_target_location = os.path.join(target_location,'src')
  if (not os.path.exists(src_target_location)):
    os.makedirs(src_target_location)
  incl_target_location = os.path.join(target_location,'incl')
  if (not os.path.exists(incl_target_location)):
    os.makedirs(incl_target_location)

  # rtl files are not needed
  rtl_dir_path=os.path.join(base_path,'srcs','rtl')
  if pathlib.Path(rtl_dir_path).is_dir():
    shutil.rmtree(rtl_dir_path)

  # detect configuration files by file suffix
  config_files = os.listdir(base_path)
  for file in config_files:
    if pathlib.Path(file).suffix in ['.dat','.coe', '.mem', '.mif','.cdo']:
      shutil.move(os.path.join(base_path, file), config_target_location)

  # flatten hierarchy and find the rest of files that were filtered
  # this step is needed because file_info.txt provided location is not accurate
  flatten_directory(os.path.join(base_path),os.path.join(base_path))
  for group in sim_sources:
    for file in group:
      shutil.move(os.path.join(base_path,file['FILE_NAME']),os.path.join(src_target_location,file['FILE_NAME']))

  # find header files and move them to single incl dir
  for root, _, files in os.walk(base_path):
      for file in files:
        if pathlib.Path(file).suffix in ['.vh','.svh','.h']:
          shutil.move(os.path.join(root,file),os.path.join(target_location,'incl',file))

def get_library_list_from_elaborate_do(base_path: str) -> list:
  with open(os.path.join(base_path, 'elaborate.do'),'r') as file:
    line = file.readline()
  line = line.split()
  # extract library list
  library_list = []
  for i in range(len(line)):
      if(line[i]=='-L'):
        library_list.append(line[i+1])
  # add core libraries that must be always present
  library_list.append("unisims_ver")
  library_list.append("secureip")
  library_list.append("unimacro_ver")
  library_list = sorted(list(set(library_list)))
  # remove xil_defaultlib, since its contents are compiled together with
  # the simulation sources
  library_list = [x for x in library_list if x != "xil_defaultlib"]
  return library_list

def gen_questa_config_libraries(target_location:str,library_list:list) -> list:
  target_location = os.path.join(target_location,'config')
  if (not os.path.exists(target_location)):
    os.makedirs(target_location)
  # prepend xil_defaultlib, which is needed for questa
  library_list.insert(0,'xil_defaultlib')
  with open(os.path.join(target_location, 'libraries.conf'),'w') as file:
    for library in library_list:
      file.write('-L {} '.format(library))

def generate_questa_compile_file(sim_sources:list,target_location:str):
  with open(os.path.join(target_location,'compile.do'),'w') as file:
    file.write('# Please make sure of the following before simulating: \n\
    # * All libraries listed in $sim_models_dir/config/libraries.conf are added to vopt/vsim \n\
    # * All other files present in $sim_models_dir/config are linked/copied to the directoty where \n\
    # the simulation is being run from\n\
    # * The appropiate top module is used (the RTL top, or the sim_wrapper if compiled in this file\n')
    for group in sim_sources:
      if (group[0]['FILE_TYPE'] == 'systemverilog'):
        file.write(vlog_sv_cmd+'\n')
      if (group[0]['FILE_TYPE'] == 'verilog') or (group[0]['FILE_TYPE'] == 'Verilog'):
        file.write(vlog_v_cmd+'\n')
      if (group[0]['FILE_TYPE'] == 'vhdl'):
        file.write(vcom_cmd+'\n')
      for source in group:
        file.write('  \"$sim_models_dir/src/{}\" \\\n'.format(source['FILE_NAME']))
      file.write('\n')

if __name__=="__main__":
  if len(sys.argv) != 3:
    sys.exit('usage: {} FILE_INFO TARGET_LOCATION'.format(sys.argv[0]))

  file_name = sys.argv[1]
  target_location = sys.argv[2]
  base_path = os.path.dirname(file_name)
  sim_sources = filter_sim_sources(file_name)
  library_list = get_library_list_from_elaborate_do(base_path)
  gen_questa_config_libraries(target_location,library_list[:])
  copy_sim_sources(sim_sources,base_path,target_location)
  generate_questa_compile_file(sim_sources,target_location)
