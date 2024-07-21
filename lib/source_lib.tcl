##################################################################
# Set IP repository paths
##################################################################

set cur_dir [file dirname [info script]]

set obj [get_filesets sources_1]
set_property  ip_repo_paths  [list \
    "$cur_dir/Digilent/ip/axi_dynclk" \
    "$cur_dir/XiaoMeiGe" \
 ] $obj

##################################################################
# Rebuild user ip_repo's index before adding any source files
##################################################################
update_ip_catalog -rebuild

