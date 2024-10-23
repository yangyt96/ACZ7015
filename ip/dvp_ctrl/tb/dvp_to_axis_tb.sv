// -----------------------------------------------------------------------
// Copyright [2024] [Tan Yee Yang]

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at

//    http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------

`timescale 10ns/1ps

`include "vunit_defines.svh"

module dvp_to_axis_tb;

  // Parameters
  parameter integer P_DVP_DATA_WIDTH = 8;
  parameter integer P_AXIS_DATA_WIDTH = 64;

  //Ports
  reg  i_dvp_pclk;
  reg  i_dvp_vsync;
  reg  i_dvp_href;
  reg [P_DVP_DATA_WIDTH-1:0] i_dvp_data;
  reg  i_axis_clk;
  reg  i_dvp_ena;
  reg  i_dvp_rst;
  wire  m_axis_tvalid;
  reg  m_axis_tready;
  wire [P_AXIS_DATA_WIDTH-1:0] m_axis_tdata;

  dvp_to_axis # (
                .P_DVP_DATA_WIDTH(P_DVP_DATA_WIDTH),
                .P_AXIS_DATA_WIDTH(P_AXIS_DATA_WIDTH)
              )
              dvp_to_axis_inst (
                .i_dvp_pclk(i_dvp_pclk),
                .i_dvp_vsync(i_dvp_vsync),
                .i_dvp_href(i_dvp_href),
                .i_dvp_data(i_dvp_data),
                .i_axis_clk(i_axis_clk),
                .i_dvp_ena(i_dvp_ena),
                .i_dvp_rst(i_dvp_rst),
                .o_fifo_wr_stat(),
                .o_fifo_rd_stat(),
                .m_axis_tvalid(m_axis_tvalid),
                .m_axis_tready(m_axis_tready),
                .m_axis_tdata(m_axis_tdata)
              );

  //--------------------------------------------------------
  `TEST_SUITE
    begin


      `TEST_SUITE_SETUP
        begin
          i_dvp_vsync=0;
          i_dvp_href=0;
          i_dvp_data=0;
          i_dvp_ena=0;
          i_dvp_rst=1;
          m_axis_tready=0;

          #10;

          i_dvp_rst=0;

          #1;
        end;

      `TEST_CASE("test_1")
                begin
                  #0.001;
                  i_dvp_ena = 1;
                  m_axis_tready = 1;

                  #1000;

                  for(int k = 0; k < 100; k=k+1)
                  begin

                    for(int i = 0; i < 100; i=i+1)
                    begin
                      i_dvp_vsync = 1;
                      i_dvp_data = i_dvp_data + 1;
                      #1.0416;
                    end

                    i_dvp_vsync = 0;
                    #10;

                    for (int j = 0; j < 10; j=j+1)
                    begin
                      i_dvp_href = 0;
                      #10;

                      for (int i = 0; i < 100; i=i+1)
                      begin
                        i_dvp_href = 1;
                        i_dvp_data = i_dvp_data + 1;
                        #1.0416;
                      end
                    end
                    i_dvp_href = 0;
                    #10;
                  end

                end;



    end;

  `WATCHDOG(0.2ms);

  initial
    i_dvp_pclk = 1;
  always #(1.0416/2)  i_dvp_pclk = ! i_dvp_pclk ;

  initial
    i_axis_clk = 1;
  always #(0.5) i_axis_clk = ! i_axis_clk;

endmodule :
dvp_to_axis_tb
