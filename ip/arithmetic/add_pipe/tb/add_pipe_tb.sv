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

`timescale 1ns/1ps

`include "vunit_defines.svh"

module add_pipe_tb;

  // Parameters
  parameter int P_DATA_SIZE = 16;
  parameter int P_NUM_PIPE = 0;
  localparam int P_IN_REG = 0;
  localparam int P_OUT_REG = 0;

  //Ports
  reg  i_clk;
  reg  i_vld;
  reg [P_DATA_SIZE - 1 : 0] i_a;
  reg [P_DATA_SIZE - 1 : 0] i_b;
  reg  i_c;
  wire  o_vld;
  wire [P_DATA_SIZE : 0] o_s;

  // test
  logic [P_DATA_SIZE : 0] sum;
  logic [P_DATA_SIZE : 0] sum_queue [$];
  string msg;

  add_pipe # (
             .P_DATA_SIZE(P_DATA_SIZE),
             .P_NUM_PIPE(P_NUM_PIPE),
             .P_IN_REG(P_IN_REG),
             .P_OUT_REG(P_OUT_REG)
           )
           add_pipe_inst (
             .i_clk(i_clk),
             .i_vld(i_vld),
             .i_a(i_a),
             .i_b(i_b),
             .i_c(i_c),
             .o_vld(o_vld),
             .o_s(o_s)
           );

  //--------------------------------------------------------
  `TEST_SUITE
    begin


      `TEST_SUITE_SETUP
        begin
          i_vld = 0;
          i_a = 0;
          i_b = 0;
          i_c = 0;

          #1;

        end;


      `TEST_CASE("test_carry_a")
                begin
                  #0.001;
                  i_a = -1;
                  i_b = 0;
                  i_c = 1;

                  i_vld = 1;

                  #1;

                  if (P_NUM_PIPE + P_IN_REG + P_OUT_REG > 0)
                  begin
                    i_vld = 0;

                    #(P_NUM_PIPE + P_IN_REG + P_OUT_REG - 1);
                  end

                  $sformat(msg, "value=%d", o_s);

                  `CHECK_EQUAL(o_vld, 1);
                  `CHECK_EQUAL(o_s, 0, msg);


                end;

      `TEST_CASE("test_carry_b")
                begin
                  #0.001;
                  i_a = 0;
                  i_b = -1;
                  i_c = 1;

                  i_vld = 1;

                  #1;
                  if (P_NUM_PIPE + P_IN_REG + P_OUT_REG > 0)
                  begin
                    i_vld = 0;

                    #(P_NUM_PIPE + P_IN_REG + P_OUT_REG - 1);
                  end

                  `CHECK_EQUAL(o_vld, 1);
                  `CHECK_EQUAL(o_s, 0);


                end;

      `TEST_CASE("test_full")
                begin
                  #0.001;
                  i_a = -1;
                  i_b = -1;
                  i_c = 1;

                  i_vld = 1;

                  #1;
                  if (P_NUM_PIPE + P_IN_REG + P_OUT_REG > 0)
                  begin

                    i_vld = 0;

                    #(P_NUM_PIPE + P_IN_REG + P_OUT_REG - 1);
                  end

                  sum = -1;
                  `CHECK_EQUAL(o_vld, 1);
                  `CHECK_EQUAL(o_s, sum);


                end;

      `TEST_CASE("test_random")
                begin
                  #0.001;

                  for(int i = 0; i < 100; i=i+1)
                  begin
                    i_a = $random();
                    i_b = $random();
                    i_c = $random();

                    i_vld = 1;

                    sum = {{i_a[P_DATA_SIZE-1]}, i_a} + {{i_b[P_DATA_SIZE-1]}, i_b} + i_c;

                    #1;
                    if (P_NUM_PIPE + P_IN_REG + P_OUT_REG > 0)
                    begin
                      i_vld = 0;
                      #(P_NUM_PIPE + P_IN_REG + P_OUT_REG - 1);
                    end

                    `CHECK_EQUAL(o_vld, 1);
                    `CHECK_EQUAL(o_s, sum);


                    $display("itr:",i, i_c);
                    i_vld = 0;
                    #1;

                  end

                end;


      `TEST_CASE("test_pipeline")
                begin
                  #0.001;


                  fork

                    // thread 1: input
                    begin
                      for(int i = 0; i < 500; i=i+1)
                      begin
                        i_a = $random();
                        i_b = $random();
                        i_c = $random();
                        i_vld = 1;
                        sum = {{i_a[P_DATA_SIZE-1]}, i_a} + {{i_b[P_DATA_SIZE-1]}, i_b} + i_c;
                        sum_queue.push_front(sum);
                        #1;
                      end

                      i_a = 0;
                      i_b = 0;
                      i_c = 0;
                      i_vld = 0;
                      #1;

                    end

                    // thread 2: output
                    begin

                      #(P_NUM_PIPE + P_IN_REG + P_OUT_REG);
                      #0.001;

                      for(int i = 0; i < 500; i=i+1)
                      begin
                        $sformat(msg, "iter %d", i);

                        `CHECK_EQUAL(o_vld, 1, msg);
                        `CHECK_EQUAL(o_s, sum_queue.pop_back(), msg);
                        #1;
                      end

                      `CHECK_EQUAL(o_vld, 0);
                      `CHECK_EQUAL(o_s, 0);

                    end

                  join



                end;



    end;

  `WATCHDOG(1s);

  initial
    i_clk = 1;
  always #0.5  i_clk = !i_clk ;

endmodule:
add_pipe_tb
