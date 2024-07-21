


# Proc to create BD system
proc cr_bd_system { parentCell } {

    # CHANGE DESIGN NAME HERE
    set design_name system

    common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

    create_bd_design $design_name

    set bCheckIPsPassed 1
    ##################################################################
    # CHECK IPs
    ##################################################################
    set bCheckIPs 1
    if { $bCheckIPs == 1 } {
        set list_check_ips "\
            xilinx.com:user:DVP_Capture2DDR:1.0\
            digilentinc.com:ip:axi_dynclk:1.2\
            xilinx.com:ip:axi_iic:2.0\
            xilinx.com:ip:smartconnect:1.0\
            xilinx.com:ip:axi_vdma:6.3\
            xilinx.com:ip:clk_wiz:6.0\
            xilinx.com:ip:fifo_generator:13.2\
            xilinx.com:ip:processing_system7:5.5\
            www.xilinx.com:user:rgb2lcd:1.0\
            xilinx.com:user:rgb565to888:1.0\
            xilinx.com:ip:proc_sys_reset:5.0\
            xilinx.com:ip:v_axi4s_vid_out:4.0\
            xilinx.com:ip:v_tc:6.1\
        "

    set list_ips_missing ""
    common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

    foreach ip_vlnv $list_check_ips {
        set ip_obj [get_ipdefs -all $ip_vlnv]
        if { $ip_obj eq "" } {
            lappend list_ips_missing $ip_vlnv
        }
    }

    if { $list_ips_missing ne "" } {
        catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
        set bCheckIPsPassed 0
    }

}

if { $bCheckIPsPassed != 1 } {
    common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
}

variable script_folder

if { $parentCell eq "" } {
    set parentCell [get_bd_cells /]
}

# Get object for parentCell
set parentObj [get_bd_cells $parentCell]
if { $parentObj == "" } {
    catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
    return
}

# Make sure parentObj is hier blk
set parentType [get_property TYPE $parentObj]
if { $parentType ne "hier" } {
    catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
    return
}

# Save current instance; Restore later
set oldCurInst [current_bd_instance .]

# Set parent object as current
current_bd_instance $parentObj

##################################################################
# Create interface ports
##################################################################
set CAM_SCCB [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 CAM_SCCB ]
set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
set SII9022 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 SII9022 ]
set lcd_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:user:lcd_rtl:1.0 lcd_0 ]

##################################################################
# Create ports
##################################################################
set CAM_Data [ create_bd_port -dir I -from 7 -to 0 CAM_Data ]
set CAM_Href [ create_bd_port -dir I CAM_Href ]
set CAM_PCLK [ create_bd_port -dir I CAM_PCLK ]
set CAM_Vsync [ create_bd_port -dir I CAM_Vsync ]
set CAM_XCLK [ create_bd_port -dir O -type clk CAM_XCLK ]
set_property -dict [ list \
    CONFIG.FREQ_HZ {24000000} \
    ] $CAM_XCLK



##################################################################
# source related ip files
##################################################################

set cur_dir [file dirname [info script]]

set ip_files [glob "$cur_dir/xilip/*.tcl"]

foreach ip_file $ip_files {
    puts "Sourcing file: $ip_file"
    source $ip_file
}


##################################################################
# Create interface connections
##################################################################
connect_bd_intf_net -intf_net DVP_Capture2DDR_0_M_AXI [get_bd_intf_pins DVP_Capture2DDR_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
connect_bd_intf_net -intf_net axi_iic_0_IIC [get_bd_intf_ports CAM_SCCB] [get_bd_intf_pins axi_iic_0/IIC]
connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP1]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins rgb565to888_0/S_AXIS]
connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S]
connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports SII9022] [get_bd_intf_pins processing_system7_0/IIC_0]
connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins ps7_0_axi_periph/S00_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_iic_0/S_AXI] [get_bd_intf_pins ps7_0_axi_periph/M00_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M01_AXI [get_bd_intf_pins ps7_0_axi_periph/M01_AXI] [get_bd_intf_pins v_tc_0/ctrl]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M02_AXI [get_bd_intf_pins axi_vdma_0/S_AXI_LITE] [get_bd_intf_pins ps7_0_axi_periph/M02_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M03_AXI [get_bd_intf_pins DVP_Capture2DDR_0/S00_AXI] [get_bd_intf_pins ps7_0_axi_periph/M03_AXI]
connect_bd_intf_net -intf_net ps7_0_axi_periph_M04_AXI [get_bd_intf_pins axi_dynclk_0/s_axi_lite] [get_bd_intf_pins ps7_0_axi_periph/M04_AXI]
connect_bd_intf_net -intf_net rgb2lcd_0_lcd [get_bd_intf_ports lcd_0] [get_bd_intf_pins rgb2lcd_0/lcd]
connect_bd_intf_net -intf_net rgb565to888_0_M_AXIS [get_bd_intf_pins rgb565to888_0/M_AXIS] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
connect_bd_intf_net -intf_net v_axi4s_vid_out_0_vid_io_out [get_bd_intf_pins rgb2lcd_0/vid_rgb] [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out]
connect_bd_intf_net -intf_net v_tc_0_vtiming_out [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in] [get_bd_intf_pins v_tc_0/vtiming_out]

##################################################################
# Create port connections
##################################################################
connect_bd_net -net DVP_Capture2DDR_0_DataPixel [get_bd_pins DVP_Capture2DDR_0/DataPixel] [get_bd_pins fifo_generator_0/din]
connect_bd_net -net DVP_Capture2DDR_0_FIFO_RST [get_bd_pins DVP_Capture2DDR_0/FIFO_RST] [get_bd_pins fifo_generator_0/rst]
connect_bd_net -net DVP_Capture2DDR_0_Frame_Clk [get_bd_pins DVP_Capture2DDR_0/Frame_Clk] [get_bd_pins fifo_generator_0/wr_clk]
connect_bd_net -net DVP_Capture2DDR_0_Frame_FIFO_EN [get_bd_pins DVP_Capture2DDR_0/Frame_FIFO_EN] [get_bd_pins fifo_generator_0/wr_en]
connect_bd_net -net DVP_Capture2DDR_0_WR_FIFO_RE [get_bd_pins DVP_Capture2DDR_0/WR_FIFO_RE] [get_bd_pins fifo_generator_0/rd_en]
connect_bd_net -net Data_0_1 [get_bd_ports CAM_Data] [get_bd_pins DVP_Capture2DDR_0/Data]
connect_bd_net -net Href_0_1 [get_bd_ports CAM_Href] [get_bd_pins DVP_Capture2DDR_0/Href]
connect_bd_net -net PCLK_0_1 [get_bd_ports CAM_PCLK] [get_bd_pins DVP_Capture2DDR_0/PCLK]
connect_bd_net -net Vsync_0_1 [get_bd_ports CAM_Vsync] [get_bd_pins DVP_Capture2DDR_0/Vsync]
connect_bd_net -net axi_dynclk_0_LOCKED_O [get_bd_pins axi_dynclk_0/LOCKED_O] [get_bd_pins clk_wiz_0/resetn] [get_bd_pins rgb2lcd_0/vid_rst]
connect_bd_net -net axi_dynclk_0_PXL_CLK_O [get_bd_pins axi_dynclk_0/PXL_CLK_O] [get_bd_pins rgb2lcd_0/pixel_clk] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_clk] [get_bd_pins v_tc_0/clk]
connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_ports CAM_XCLK] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net -net fifo_generator_0_almost_empty [get_bd_pins DVP_Capture2DDR_0/WR_FIFO_AEMPTY] [get_bd_pins fifo_generator_0/almost_empty]
connect_bd_net -net fifo_generator_0_dout [get_bd_pins DVP_Capture2DDR_0/WR_FIFO_DATA] [get_bd_pins fifo_generator_0/dout]
connect_bd_net -net fifo_generator_0_empty [get_bd_pins DVP_Capture2DDR_0/WR_FIFO_EMPTY] [get_bd_pins fifo_generator_0/empty]
connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins DVP_Capture2DDR_0/s00_axi_aclk] [get_bd_pins axi_dynclk_0/REF_CLK_I] [get_bd_pins axi_dynclk_0/s_axi_lite_aclk] [get_bd_pins axi_iic_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_smc/aclk] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins fifo_generator_0/rd_clk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP1_ACLK] [get_bd_pins ps7_0_axi_periph/ACLK] [get_bd_pins ps7_0_axi_periph/M00_ACLK] [get_bd_pins ps7_0_axi_periph/M01_ACLK] [get_bd_pins ps7_0_axi_periph/M02_ACLK] [get_bd_pins ps7_0_axi_periph/M03_ACLK] [get_bd_pins ps7_0_axi_periph/M04_ACLK] [get_bd_pins ps7_0_axi_periph/S00_ACLK] [get_bd_pins rgb565to888_0/m_clk] [get_bd_pins rgb565to888_0/s_clk] [get_bd_pins rst_ps7_0_100M/slowest_sync_clk] [get_bd_pins v_axi4s_vid_out_0/aclk] [get_bd_pins v_tc_0/s_axi_aclk]
connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_ps7_0_100M/ext_reset_in]
connect_bd_net -net rst_ps7_0_100M_peripheral_aresetn [get_bd_pins DVP_Capture2DDR_0/s00_axi_aresetn] [get_bd_pins axi_dynclk_0/s_axi_lite_aresetn] [get_bd_pins axi_iic_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_smc/aresetn] [get_bd_pins axi_vdma_0/axi_resetn] [get_bd_pins ps7_0_axi_periph/ARESETN] [get_bd_pins ps7_0_axi_periph/M00_ARESETN] [get_bd_pins ps7_0_axi_periph/M01_ARESETN] [get_bd_pins ps7_0_axi_periph/M02_ARESETN] [get_bd_pins ps7_0_axi_periph/M03_ARESETN] [get_bd_pins ps7_0_axi_periph/M04_ARESETN] [get_bd_pins ps7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps7_0_100M/peripheral_aresetn] [get_bd_pins v_tc_0/s_axi_aresetn]
connect_bd_net -net v_axi4s_vid_out_0_vtg_ce [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/clken]

##################################################################
# Create address segments
##################################################################
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces DVP_Capture2DDR_0/M_AXI] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
create_bd_addr_seg -range 0x20000000 -offset 0x00000000 [get_bd_addr_spaces axi_vdma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP1/HP1_DDR_LOWOCM] SEG_processing_system7_0_HP1_DDR_LOWOCM
create_bd_addr_seg -range 0x00010000 -offset 0x43C10000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs DVP_Capture2DDR_0/S00_AXI/S00_AXI_reg] SEG_DVP_Capture2DDR_0_S00_AXI_reg
create_bd_addr_seg -range 0x00010000 -offset 0x43C20000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs {axi_dynclk_0/S_AXI_LITE/S_AXI_LITE_reg }] SEG_axi_dynclk_0_reg0
create_bd_addr_seg -range 0x00010000 -offset 0x41600000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_iic_0/S_AXI/Reg] SEG_axi_iic_0_Reg
create_bd_addr_seg -range 0x00010000 -offset 0x43000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_vdma_0/S_AXI_LITE/Reg] SEG_axi_vdma_0_Reg
create_bd_addr_seg -range 0x00010000 -offset 0x43C00000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs v_tc_0/ctrl/Reg] SEG_v_tc_0_Reg


##################################################################
# Perform GUI Layout
##################################################################
regenerate_bd_layout
regenerate_bd_layout -routing


##################################################################
# Restore current instance
##################################################################
current_bd_instance $oldCurInst

validate_bd_design
save_bd_design
close_bd_design $design_name
}


cr_bd_system ""
set_property EXCLUDE_DEBUG_LOGIC "0" [get_files system.bd ]
set_property GENERATE_SYNTH_CHECKPOINT "1" [get_files system.bd ]
set_property IS_ENABLED "1" [get_files system.bd ]
set_property IS_GLOBAL_INCLUDE "0" [get_files system.bd ]
set_property IS_LOCKED "0" [get_files system.bd ]
set_property LIBRARY "xil_defaultlib" [get_files system.bd ]
set_property PATH_MODE "RelativeFirst" [get_files system.bd ]
set_property PFM_NAME "" [get_files system.bd ]
set_property REGISTERED_WITH_MANAGER "1" [get_files system.bd ]
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files system.bd ]
set_property USED_IN "synthesis implementation simulation" [get_files system.bd ]
set_property USED_IN_IMPLEMENTATION "1" [get_files system.bd ]
set_property USED_IN_SIMULATION "1" [get_files system.bd ]
set_property USED_IN_SYNTHESIS "1" [get_files system.bd ]