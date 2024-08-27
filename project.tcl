set project_name "project_test"
set project_dir "C:/project/ACZ7015/workspace/$project_name"


create_project $project_name $project_dir -part xc7z015clg485-2




set cur_dir [file dirname [info script]]


set lib_file "$cur_dir/lib/source_lib.tcl"
set bd_file "$cur_dir/bd/board_diagram.tcl"
set xdc_file "$cur_dir/xdc/DDR_LCD.xdc"


# add library
source $lib_file

# add board diagram
source $bd_file


# add constraint
add_files $xdc_file

