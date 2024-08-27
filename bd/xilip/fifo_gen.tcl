# Create instance: fifo_generator_0, and set properties
set fifo_generator_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:fifo_generator:13.2 fifo_generator_0 ]
set_property -dict [ list \
    CONFIG.Almost_Empty_Flag {true} \
    CONFIG.Data_Count_Width {12} \
    CONFIG.Empty_Threshold_Assert_Value {4} \
    CONFIG.Empty_Threshold_Negate_Value {5} \
    CONFIG.Enable_Safety_Circuit {false} \
    CONFIG.Fifo_Implementation {Independent_Clocks_Block_RAM} \
    CONFIG.Full_Flags_Reset_Value {1} \
    CONFIG.Full_Threshold_Assert_Value {4095} \
    CONFIG.Full_Threshold_Negate_Value {4094} \
    CONFIG.Input_Data_Width {8} \
    CONFIG.Input_Depth {4096} \
    CONFIG.Output_Data_Width {64} \
    CONFIG.Output_Depth {512} \
    CONFIG.Performance_Options {First_Word_Fall_Through} \
    CONFIG.Read_Data_Count_Width {9} \
    CONFIG.Reset_Type {Asynchronous_Reset} \
    CONFIG.Write_Data_Count_Width {12} \
    ] $fifo_generator_0