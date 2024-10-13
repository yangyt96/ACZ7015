module dvp_to_axis #
  (
    parameter integer P_DVP_DATA_WIDTH = 8,
    parameter integer P_AXIS_DATA_WIDTH = 64, //! Multiply of P_DVP_DATA_WIDTH
    parameter integer P_FIFO_WRITE_DEPTH = 2**14, //! power of 2, min=2^4, max=2^22
    parameter integer C_FIFO_WR_CNT_WIDTH = $clog2(P_FIFO_WRITE_DEPTH)+1,
    parameter integer C_FIFO_RD_CNT_WIDTH = $clog2(P_FIFO_WRITE_DEPTH*P_DVP_DATA_WIDTH/P_AXIS_DATA_WIDTH)+1
  )
  (
    // DVP interface
    //! @virtualbus dvp_interface @dir in
    input logic i_dvp_pclk,  //! input from board/mmcm/pll, min=48MHz, max=96MHz
    input logic i_dvp_vsync, //! sync to i_dvp_pclk,
    input logic i_dvp_href,  //! sync to i_dvp_pclk,
    input logic [P_DVP_DATA_WIDTH-1:0] i_dvp_data, //! sync to i_dvp_pclk,
    //! @end

    input logic i_dvp_ena, //! sync to i_dvp_pclk, control to enable write from the i_dvp_data into the fifo
    input logic i_dvp_rst, //! sync to i_dvp_pclk, reset the registers running in this clock domain
    input logic [7:0] i_dvp_drop_vsync = 0,

    // FIFO status

    //! sync to i_dvp_pclk
    //! o_fifo_wr_stat[0] overflow
    //! o_fifo_wr_stat[1] prog_full
    //! o_fifo_wr_stat[2] pad
    //! o_fifo_wr_stat[3] almost_full
    //! o_fifo_wr_stat[4] wr_ack
    //! o_fifo_wr_stat[5] pad
    //! o_fifo_wr_stat[6] wr_rst_busy
    //! o_fifo_wr_stat[7] full
    output logic [7:0] o_fifo_wr_stat,
    output logic [C_FIFO_WR_CNT_WIDTH-1:0] o_fifo_wr_cnt,

    //! sync to i_axis_clk
    //! o_fifo_rd_stat[0] underflow
    //! o_fifo_rd_stat[1] prog_empty
    //! o_fifo_rd_stat[2] pad
    //! o_fifo_rd_stat[3] almost_empty
    //! o_fifo_rd_stat[4] data_valid
    //! o_fifo_rd_stat[5] pad
    //! o_fifo_rd_stat[6] rd_rst_busy
    //! o_fifo_rd_stat[7] empty
    output logic [7:0] o_fifo_rd_stat,
    output logic [C_FIFO_RD_CNT_WIDTH-1:0] o_fifo_rd_cnt,

    // AXI
    input logic i_axis_clk,
    input logic i_axis_endian = 1,

    //! @virtualbus m_axi_stream @dir out
    output logic m_axis_tvalid, //! sync to i_axis_clk
    input logic m_axis_tready, //! sync to i_axis_clk
    output logic [P_AXIS_DATA_WIDTH-1:0] m_axis_tdata //! sync to i_axis_clk
    //! @end
  );

  logic dvp_vsync[1:0];
  logic dvp_href[1:0];
  logic [P_DVP_DATA_WIDTH-1 : 0] dvp_data[1:0];

  logic dvp_vld;
  logic [$bits(i_dvp_drop_vsync)-1:0] dvp_cnt;
  logic dvp_mask;

  logic wr_en;
  logic [P_DVP_DATA_WIDTH-1:0] wr_din;
  logic wr_rst_busy;
  logic wr_full;

  logic rd_en;
  logic [P_AXIS_DATA_WIDTH-1:0] rd_dout;
  logic rd_rst_busy;
  logic rd_empty;

  // ----------------------------------------
  // input from DVP
  // ----------------------------------------

  always @(posedge i_dvp_pclk)
  begin
    dvp_vsync[0] <= i_dvp_vsync;
    dvp_href[0] <= i_dvp_href;
    dvp_data[0] <= i_dvp_data;

    dvp_vsync[1] <= dvp_vsync[0];
    dvp_href[1]  <= dvp_href[0] ;
    dvp_data[1]  <= dvp_data[0] ;
  end

  //! valid dvp data after negative edge of vsync
  always @ (posedge i_dvp_pclk)
    if (i_dvp_rst)
      dvp_vld <= 0;
    else
    begin
      if (dvp_vsync[1] & ~dvp_vsync[0]) // negedge vsync
        if (i_dvp_ena & ~wr_rst_busy)
          dvp_vld <= 1;

      if (~i_dvp_ena | wr_rst_busy)
        dvp_vld <= 0;

    end

  //! count the rising edge of vsync
  //! Note: We should not have a fix number of 10
  always @(posedge i_dvp_pclk)
    if (i_dvp_rst)
      dvp_cnt <= 0;
    else if (dvp_vsync[1] & ~dvp_vsync[0])
    begin
      if (dvp_cnt >= i_dvp_drop_vsync)
        dvp_cnt <= i_dvp_drop_vsync;
      else
        dvp_cnt <= dvp_cnt + 1;
    end


  // mask out 10 vsync/row
  assign dvp_mask = (dvp_cnt >= i_dvp_drop_vsync) ? 0 : 1;

  // ----------------------------------------
  // FIFO
  // ----------------------------------------

  assign wr_full = o_fifo_wr_stat[7];
  assign wr_rst_busy = o_fifo_wr_stat[6];
  assign wr_en = dvp_href[1] & dvp_vld & ~dvp_mask;
  assign wr_din = dvp_data[1];

  assign rd_empty = o_fifo_rd_stat[7];
  assign rd_rst_busy = o_fifo_rd_stat[6];
  assign m_axis_tvalid = ~rd_empty & ~rd_rst_busy;
  assign rd_en = ~rd_rst_busy & m_axis_tready;
  assign m_axis_tdata = i_axis_endian? {<<byte{rd_dout}} : rd_dout; // swap the endian

  assign  o_fifo_wr_stat[2] = 0;
  assign  o_fifo_wr_stat[5] = 0;
  assign  o_fifo_rd_stat[2] = 0;
  assign  o_fifo_rd_stat[5] = 0;

  xpm_fifo_async #
    (
      .CDC_SYNC_STAGES(2),
      .DOUT_RESET_VALUE("0"),
      .ECC_MODE("no_ecc"),
      .FIFO_MEMORY_TYPE("block"),
      .FIFO_READ_LATENCY(0),
      .FIFO_WRITE_DEPTH(P_FIFO_WRITE_DEPTH),
      .FULL_RESET_VALUE(1),
      .PROG_EMPTY_THRESH(4),
      .PROG_FULL_THRESH(P_FIFO_WRITE_DEPTH-1), // Note: maybe it is minus 1, need to check
      .RD_DATA_COUNT_WIDTH(C_FIFO_RD_CNT_WIDTH),
      .READ_DATA_WIDTH(P_AXIS_DATA_WIDTH),
      .READ_MODE("fwft"),
      .RELATED_CLOCKS(0),
      .USE_ADV_FEATURES("1d1d"),
      .WAKEUP_TIME(0),
      .WRITE_DATA_WIDTH(P_DVP_DATA_WIDTH),
      .WR_DATA_COUNT_WIDTH(C_FIFO_WR_CNT_WIDTH)
    )
    xpm_fifo_async_inst
    (
      //------------------------------
      // Write Channel
      //------------------------------

      .wr_clk(i_dvp_pclk),
      // 1-bit input: Write clock: Used for write operation. wr_clk must be a
      // free running clock.

      .wr_en(wr_en),
      // 1-bit input: Write Enable: If the FIFO is not full, asserting this
      // signal causes data (on din) to be written to the FIFO. Must be held
      // active-low when rst or wr_rst_busy is active high.

      .din(wr_din),
      // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when
      // writing the FIFO.

      .overflow(o_fifo_wr_stat[0]),
      // 1-bit output: Overflow: This signal indicates that a write request
      // (wren) during the prior clock cycle was rejected, because the FIFO is
      // full. Overflowing the FIFO is not destructive to the contents of the
      // FIFO.

      .prog_full(o_fifo_wr_stat[1]),
      // 1-bit output: Programmable Full: This signal is asserted when the
      // number of words in the FIFO is greater than or equal to the
      // programmable full threshold value. It is de-asserted when the number of
      // words in the FIFO is less than the programmable full threshold value.

      .wr_data_count(o_fifo_wr_cnt),
      // WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates
      // the number of words written into the FIFO.

      .almost_full(o_fifo_wr_stat[3]),
      // 1-bit output: Almost Full: When asserted, this signal indicates that
      // only one more write can be performed before the FIFO is full.

      .wr_ack(o_fifo_wr_stat[4]),
      // 1-bit output: Write Acknowledge: This signal indicates that a write
      // request (wr_en) during the prior clock cycle is succeeded.

      .wr_rst_busy(o_fifo_wr_stat[6]),
      // 1-bit output: Write Reset Busy: Active-High indicator that the FIFO
      // write domain is currently in a reset state.

      .full(o_fifo_wr_stat[7]),
      // 1-bit output: Full Flag: When asserted, this signal indicates that the
      // FIFO is full. Write requests are ignored when the FIFO is full,
      // initiating a write when the FIFO is full is not destructive to the
      // contents of the FIFO.

      .injectdbiterr(0),
      // 1-bit input: Double Bit Error Injection: Injects a double bit error if
      // the ECC feature is used on block RAMs or UltraRAM macros.

      .injectsbiterr(0),
      // 1-bit input: Single Bit Error Injection: Injects a single bit error if
      // the ECC feature is used on block RAMs or UltraRAM macros.

      //------------------------------
      // Read Channel
      //------------------------------

      .rd_clk(i_axis_clk),
      // 1-bit input: Read clock: Used for read operation. rd_clk must be a free
      // running clock.

      .rd_en(rd_en),
      // 1-bit input: Read Enable: If the FIFO is not empty, asserting this
      // signal causes data (on dout) to be read from the FIFO. Must be held
      // active-low when rd_rst_busy is active high.

      .dout(rd_dout),
      // READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven
      // when reading the FIFO.

      .underflow(o_fifo_rd_stat[0]),
      // 1-bit output: Underflow: Indicates that the read request (rd_en) during
      // the previous clock cycle was rejected because the FIFO is empty. Under
      // flowing the FIFO is not destructive to the FIFO.

      .prog_empty(o_fifo_rd_stat[1]),
      // 1-bit output: Programmable Empty: This signal is asserted when the
      // number of words in the FIFO is less than or equal to the programmable
      // empty threshold value. It is de-asserted when the number of words in
      // the FIFO exceeds the programmable empty threshold value.

      .rd_data_count(o_fifo_rd_cnt),
      // RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the
      // number of words read from the FIFO.

      .almost_empty(o_fifo_rd_stat[3]),
      // 1-bit output: Almost Empty : When asserted, this signal indicates that
      // only one more read can be performed before the FIFO goes to empty.

      .data_valid(o_fifo_rd_stat[4]),
      // 1-bit output: Read Data Valid: When asserted, this signal indicates
      // that valid data is available on the output bus (dout).

      .rd_rst_busy(o_fifo_rd_stat[6]),
      // 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read
      // domain is currently in a reset state.

      .empty(o_fifo_rd_stat[7]),
      // 1-bit output: Empty Flag: When asserted, this signal indicates that the
      // FIFO is empty. Read requests are ignored when the FIFO is empty,
      // initiating a read while empty is not destructive to the FIFO.

      .dbiterr(),
      // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected
      // a double-bit error and data in the FIFO core is corrupted.

      .sbiterr(),
      // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected
      // and fixed a single-bit error.

      //----------------------------
      // System Channel
      //----------------------------

      .rst(i_dvp_rst),
      // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be
      // unstable at the time of applying reset, but reset must be released only
      // after the clock(s) is/are stable.

      .sleep(0)
      // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo
      // block is in power saving mode.

    );

endmodule
