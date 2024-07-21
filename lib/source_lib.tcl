##################################################################
# Set IP repository paths
##################################################################
set obj [get_filesets sources_1]
set_property  ip_repo_paths  [list \
    "$currentDir/lib/Digilent/ip/axi_dynclk" \
    "$currentDir/lib/XiaoMeiGe" \
 ] $obj

##################################################################
# Rebuild user ip_repo's index before adding any source files
##################################################################
update_ip_catalog -rebuild

