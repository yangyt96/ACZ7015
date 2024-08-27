onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_pclk
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_vsync
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_href
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_data
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_ena
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_rst
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_dvp_drop_vsync
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/o_fifo_wr_stat
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/o_fifo_wr_cnt
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/o_fifo_rd_stat
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/o_fifo_rd_cnt
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_axis_clk
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/i_axis_endian
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/m_axis_tvalid
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/m_axis_tready
add wave -noupdate -expand -group IO /dvp_to_axis_tb/dvp_to_axis_inst/m_axis_tdata
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_vsync
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_href
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_data
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_vld
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_cnt
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/dvp_mask
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/wr_en
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/wr_din
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/wr_rst_busy
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/wr_full
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/rd_en
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/rd_dout
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/rd_rst_busy
add wave -noupdate -expand -group internal /dvp_to_axis_tb/dvp_to_axis_inst/rd_empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {780405405 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {1787162162 ps}
