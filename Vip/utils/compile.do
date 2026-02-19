set src_path $vip_path/utils/src
vlog -sv -work $work +incdir+$src_path \
    $src_path/utils_pkg.sv \
    $src_path/clock_gen_with_ref.sv \
    $src_path/clock_gen.sv \
    $src_path/reset_gen.sv 