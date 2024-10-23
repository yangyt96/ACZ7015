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

module add_pipe #(
    parameter int P_DATA_SIZE = 16, //! Data size of input a & b
    parameter int P_NUM_PIPE = 3, //! range=[0,P_DATA_SIZE-1], change the pipeline to relax STA
    parameter int P_IN_REG = 0, //! range=[0,1] Use input register
    parameter int P_OUT_REG = 0 //! range=[0,1] Use output register
  ) (
    input logic i_clk, //! input clock

    input logic i_vld, //! input valid, sync to i_a, i_b & i_c
    input logic [P_DATA_SIZE - 1 : 0] i_a, //! sign type
    input logic [P_DATA_SIZE - 1 : 0] i_b, //! sign type
    input logic i_c, //! input carry

    output logic o_vld, //! output valid, sync to o_s
    output logic [P_DATA_SIZE : 0] o_s //! sign type
  );

  localparam int C_NUM_PART = P_NUM_PIPE + 1;
  localparam int C_FLOOR_SIZE = $floor($itor(P_DATA_SIZE) / $itor(C_NUM_PART));
  localparam int C_CEIL_SIZE = $ceil($itor(P_DATA_SIZE) / $itor(C_NUM_PART));
  localparam int C_NUM_FLOOR = C_NUM_PART * C_CEIL_SIZE - P_DATA_SIZE;
  localparam int C_NUM_CEIL = C_NUM_PART - C_NUM_FLOOR;
  localparam int C_NUM_PIPE = P_NUM_PIPE + P_IN_REG + P_OUT_REG;

  //-----------------------------------
  logic [C_CEIL_SIZE : 0] sum_ceil[C_NUM_CEIL-1:0];
  logic [C_FLOOR_SIZE : 0] sum_floor[C_NUM_FLOOR-1:0];

  logic [C_CEIL_SIZE : 0] sum_ceil_d[C_NUM_CEIL-1:0][C_NUM_PART-1:0];
  logic [C_FLOOR_SIZE : 0] sum_floor_d[C_NUM_FLOOR-1:0][C_NUM_PART-1:0];

  logic [C_NUM_PIPE - 1 : 0] vld_d;
  logic [P_DATA_SIZE-1 : 0] a_d[C_NUM_PART-1:1];
  logic [P_DATA_SIZE-1 : 0] b_d[C_NUM_PART-1:1];

  logic [P_DATA_SIZE-1 : 0] a_in;
  logic [P_DATA_SIZE-1 : 0] b_in;
  logic c_in;

  logic [P_DATA_SIZE : 0] s_out;
  //-----------------------------------

  ///////////////////////////////////////////
  // input wire/reg
  ///////////////////////////////////////////
  generate
    if (P_IN_REG == 1)
      always @(posedge i_clk)
      begin
        a_in <= i_a;
        b_in <= i_b;
        c_in <= i_c;
      end
    else
      always @(*)
      begin
        a_in = i_a;
        b_in = i_b;
        c_in = i_c;
      end

  endgenerate


  ///////////////////////////////////////////
  // valid delay
  ///////////////////////////////////////////
  always @(posedge i_clk)
  begin
    vld_d[0] <= i_vld;
    if (C_NUM_PIPE > 1)
      vld_d[C_NUM_PIPE-1:1] <= vld_d[C_NUM_PIPE-2:0];
  end

  generate
    if (C_NUM_PIPE == 0)
      assign o_vld = i_vld;
    else
      assign o_vld = vld_d[C_NUM_PIPE-1];
  endgenerate

  ///////////////////////////////////////////
  // valid delay
  ///////////////////////////////////////////
  always @(posedge i_clk)
  begin
    a_d[1] <= a_in;
    b_d[1] <= b_in;

    for(int i = 2; i < C_NUM_PART; i = i + 1)
    begin
      a_d[i] <= a_d[i-1];
      b_d[i] <= b_d[i-1];
    end

  end


  ///////////////////////////////////////////
  // partial sum
  ///////////////////////////////////////////
  generate
    for (genvar i = 0; i < (C_NUM_PART - 1); i = i + 1)
    begin

      always @(posedge i_clk)
      begin

        if (i == 0)
          sum_ceil[0] <=
                  a_in[C_CEIL_SIZE-1:0]
                  + b_in[C_CEIL_SIZE-1:0]
                  + c_in;

        else if (i < C_NUM_CEIL)
          sum_ceil[i] <=
                  a_d[i][C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i]
                  + b_d[i][C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i]
                  + sum_ceil[i-1][C_CEIL_SIZE];

        else if (i == C_NUM_CEIL)
          sum_floor[0] <=
                   a_d[i][C_FLOOR_SIZE*(i-C_NUM_CEIL+1)-1 + C_CEIL_SIZE*C_NUM_CEIL : C_FLOOR_SIZE*(i-C_NUM_CEIL) + C_CEIL_SIZE*C_NUM_CEIL]
                   + b_d[i][C_FLOOR_SIZE*(i-C_NUM_CEIL+1)-1 + C_CEIL_SIZE*C_NUM_CEIL : C_FLOOR_SIZE*(i-C_NUM_CEIL) + C_CEIL_SIZE*C_NUM_CEIL]
                   + sum_ceil[C_NUM_CEIL-1][C_CEIL_SIZE];

        else
          sum_floor[i-C_NUM_CEIL] <=
                   a_d[i][C_FLOOR_SIZE*(i-C_NUM_CEIL+1)-1 + C_CEIL_SIZE*C_NUM_CEIL : C_FLOOR_SIZE*(i-C_NUM_CEIL) + C_CEIL_SIZE*C_NUM_CEIL]
                   + b_d[i][C_FLOOR_SIZE*(i-C_NUM_CEIL+1)-1 + C_CEIL_SIZE*C_NUM_CEIL : C_FLOOR_SIZE*(i-C_NUM_CEIL) + C_CEIL_SIZE*C_NUM_CEIL]
                   + sum_floor[i-C_NUM_CEIL-1][C_FLOOR_SIZE];

      end
    end
  endgenerate

  always @(*)
  begin
    if (C_NUM_FLOOR == 0)
      sum_ceil[C_NUM_CEIL-1] =
              { {1{a_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, a_d[C_NUM_PART-1][C_CEIL_SIZE*(C_NUM_CEIL)-1:C_CEIL_SIZE*(C_NUM_CEIL-1)] }
              + { {1{b_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, b_d[C_NUM_PART-1][C_CEIL_SIZE*(C_NUM_CEIL)-1:C_CEIL_SIZE*(C_NUM_CEIL-1)] }
              + { {1'b0}, sum_ceil[C_NUM_CEIL-2][C_CEIL_SIZE] };

    else if (C_NUM_FLOOR == 1)
      sum_floor[0] =
               { {1{a_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, a_d[C_NUM_PART-1][P_DATA_SIZE-1: P_DATA_SIZE-C_FLOOR_SIZE] }
               + { {1{b_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, b_d[C_NUM_PART-1][P_DATA_SIZE-1: P_DATA_SIZE-C_FLOOR_SIZE] }
               + { {1'b0}, sum_ceil[C_NUM_CEIL-1][C_CEIL_SIZE] };

    else if (C_NUM_FLOOR > 1)
      sum_floor[C_NUM_FLOOR-1] =
               { {1{a_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, a_d[C_NUM_PART-1][P_DATA_SIZE-1: P_DATA_SIZE-C_FLOOR_SIZE] }
               + { {1{b_d[C_NUM_PART-1][P_DATA_SIZE-1]}}, b_d[C_NUM_PART-1][P_DATA_SIZE-1: P_DATA_SIZE-C_FLOOR_SIZE] }
               + { {1'b0}, sum_floor[C_NUM_FLOOR-2][C_FLOOR_SIZE] };
  end

  // delay of sum
  generate
    for(genvar i = 0; i < C_NUM_PART; i = i + 1)
    begin

      always @(*)
        if (i < C_NUM_CEIL)
          sum_ceil_d[i][i] = sum_ceil[i];
        else
          sum_floor_d[i-C_NUM_CEIL][i] = sum_floor[i-C_NUM_CEIL];

      for(genvar j = i + 1; j < C_NUM_PART; j = j + 1)
        always @(posedge i_clk)
          if (i < C_NUM_CEIL)
            sum_ceil_d[i][j] <= sum_ceil_d[i][j-1];
          else
            sum_floor_d[i-C_NUM_CEIL][j] <= sum_floor_d[i-C_NUM_CEIL][j-1];

    end

  endgenerate



  ///////////////////////////////////////////
  // assign sum
  ///////////////////////////////////////////
  generate
    if (P_NUM_PIPE == 0)
      assign s_out = {{a_in[P_DATA_SIZE-1]}, a_in} + {{b_in[P_DATA_SIZE-1]}, b_in} + c_in;
    else
      for(genvar i = 0; i < C_NUM_PART; i = i + 1)
      begin

        if (C_NUM_FLOOR == 0)
        begin
          if (i == C_NUM_PART-1)
            assign s_out[P_DATA_SIZE:P_DATA_SIZE-C_CEIL_SIZE] = sum_ceil[i][C_CEIL_SIZE:0];
          else if (i == C_NUM_PART-2)
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil[i][C_CEIL_SIZE-1:0];
          else
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil_d[i][C_NUM_PART-2][C_CEIL_SIZE-1:0];

        end

        else if (C_NUM_FLOOR == 1)
        begin
          if (i == C_NUM_PART-1)
            assign s_out[P_DATA_SIZE:P_DATA_SIZE-C_FLOOR_SIZE] = sum_floor[0][C_FLOOR_SIZE:0];
          else if (i == C_NUM_PART-2)
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil[i][C_CEIL_SIZE-1:0];
          else
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil_d[i][C_NUM_PART-2][C_CEIL_SIZE-1:0];

        end

        else if (C_NUM_FLOOR == 2)
        begin
          if (i == C_NUM_PART-1)
            assign s_out[P_DATA_SIZE : P_DATA_SIZE - C_FLOOR_SIZE] = sum_floor[i-C_NUM_CEIL][C_FLOOR_SIZE:0];
          else if (i == C_NUM_PART-2)
            assign s_out[ C_FLOOR_SIZE*(i-C_NUM_CEIL+1) - 1 + (C_CEIL_SIZE*C_NUM_CEIL): C_FLOOR_SIZE*(i-C_NUM_CEIL) + (C_CEIL_SIZE*C_NUM_CEIL)] = sum_floor[i-C_NUM_CEIL][C_FLOOR_SIZE-1:0];
          else
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil_d[i][C_NUM_PART-2][C_CEIL_SIZE-1:0];

        end

        else if (C_NUM_FLOOR > 2)
        begin
          if (i == C_NUM_PART-1)
            assign s_out[P_DATA_SIZE : P_DATA_SIZE - C_FLOOR_SIZE] = sum_floor[i-C_NUM_CEIL][C_FLOOR_SIZE:0];
          else if (i == C_NUM_PART-2)
            assign s_out[ C_FLOOR_SIZE*(i-C_NUM_CEIL+1) - 1 + (C_CEIL_SIZE*C_NUM_CEIL): C_FLOOR_SIZE*(i-C_NUM_CEIL) + (C_CEIL_SIZE*C_NUM_CEIL)] = sum_floor[i-C_NUM_CEIL][C_FLOOR_SIZE-1:0];
          else if (i >= C_NUM_CEIL && i < (C_NUM_PART-1))
            assign s_out[ C_FLOOR_SIZE*(i-C_NUM_CEIL+1) - 1 + (C_CEIL_SIZE*C_NUM_CEIL): C_FLOOR_SIZE*(i-C_NUM_CEIL) + (C_CEIL_SIZE*C_NUM_CEIL)] = sum_floor_d[i-C_NUM_CEIL][C_NUM_PART-2][C_FLOOR_SIZE-1:0];
          else
            assign s_out[C_CEIL_SIZE*(i+1)-1:C_CEIL_SIZE*i] = sum_ceil_d[i][C_NUM_PART-2][C_CEIL_SIZE-1:0];

        end;

      end;

  endgenerate


  generate
    if (P_OUT_REG == 1)
      always @(posedge i_clk)
      begin
        o_s <= s_out;
      end
    else
      always @(*)
      begin
        o_s = s_out;
      end

  endgenerate

endmodule
