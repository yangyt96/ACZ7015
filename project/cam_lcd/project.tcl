set cur_dir [file dirname [info script]]
puts $cur_dir


set project_name "cam_lcd"
set project_dir "$cur_dir/../../workspace/$project_name"
puts $project_dir
create_project $project_name $project_dir -part xc7z015clg485-2


set lib_file "$cur_dir/../../lib/source_lib.tcl"
set bd_file "$cur_dir/bd/board_diagram.tcl"
set xdc_file "$cur_dir/constr/DDR_LCD.xdc"


# add library
source $lib_file

# add board diagram
source $bd_file


# add constraint
add_files $xdc_file

