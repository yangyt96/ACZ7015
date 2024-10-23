-- -----------------------------------------------------------------------
-- Copyright [2024] [Tan Yee Yang]

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--    http:--www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
-- -----------------------------------------------------------------------
--! Environment: VHDL-2008

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY adder_pipeline IS
    GENERIC (
        G_DATA_WIDTH : integer := 64;
        G_INPUT_REG  : boolean := false;
        G_OUTPUT_REG : boolean := true;
        G_NUM_PIPE   : integer := 16 --! This decides the number of adder pipeline. If it is 1, then the adder is split into 2 parts. The range of this value is [0, G_DATA_WIDTH].
    );
    PORT (
        i_clk : IN std_logic := '0';

        i_vld : IN std_logic := '0';                            --! Input valid, which stays for 1 clock cycle and synchronize with iv_ci, iv_a, iv_b
        iv_a  : IN std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0); --! Data in a_in, signed type
        iv_b  : IN std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0); --! Data in b_in, signed type
        i_c   : IN std_logic := '0';                            --! Carry in

        o_vld : OUT std_logic;                              --! Output valid which stays for 1 clock cycle and synchronize with ov_s
        ov_s  : OUT std_logic_vector(G_DATA_WIDTH DOWNTO 0) --! Sum out, signed type
    );
END ENTITY;

ARCHITECTURE rtl OF adder_pipeline IS

    TYPE t_slv_vector IS ARRAY(integer RANGE <>) OF std_logic_vector;
    TYPE t_slv_matrix IS ARRAY(integer RANGE <>, integer RANGE <>) OF std_logic_vector;

    -- Partial Sum
    CONSTANT C_NUM_PART : integer := G_NUM_PIPE + 1;

    CONSTANT C_NUM_BIT_CEIL  : integer := integer(ceil(real(G_DATA_WIDTH) / real(C_NUM_PART)));
    CONSTANT C_NUM_BIT_FLOOR : integer := integer(floor(real(G_DATA_WIDTH) / real(C_NUM_PART)));

    CONSTANT C_NUM_FLOOR : integer := C_NUM_PART * C_NUM_BIT_CEIL - G_DATA_WIDTH;
    CONSTANT C_NUM_CEIL  : integer := C_NUM_PART - C_NUM_FLOOR;

    SIGNAL sum_ceil  : t_slv_vector(C_NUM_CEIL - 1 DOWNTO 0)(C_NUM_BIT_CEIL DOWNTO 0);
    SIGNAL sum_floor : t_slv_vector(maximum(0, C_NUM_FLOOR - 1) DOWNTO 0)(C_NUM_BIT_FLOOR DOWNTO 0);

    -- Delay
    SIGNAL a_d : t_slv_vector(C_NUM_PART - 1 DOWNTO 1)(G_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL b_d : t_slv_vector(C_NUM_PART - 1 DOWNTO 1)(G_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL sum_ceil_d  : t_slv_matrix(C_NUM_PART - 1 DOWNTO 1, C_NUM_CEIL - 1 DOWNTO 0)(C_NUM_BIT_CEIL DOWNTO 0);
    SIGNAL sum_floor_d : t_slv_matrix(C_NUM_PART - 1 DOWNTO 1, maximum(0, C_NUM_FLOOR - 1) DOWNTO 0)(C_NUM_BIT_FLOOR DOWNTO 0);

    SIGNAL vld_d : std_logic_vector(maximum(G_NUM_PIPE - 1, 0) DOWNTO 0);

    -- Input wire/reg
    SIGNAL a_in   : std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL b_in   : std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL c_in   : std_logic;
    SIGNAL vld_in : std_logic;

    -- Output wire/reg
    SIGNAL s_out   : std_logic_vector(G_DATA_WIDTH DOWNTO 0);
    SIGNAL vld_out : std_logic;

    -- DSP option
    ATTRIBUTE USE_DSP : string;

    ATTRIBUTE USE_DSP OF sum_ceil  : SIGNAL IS "YES";
    ATTRIBUTE USE_DSP OF sum_floor : SIGNAL IS "YES";
    ATTRIBUTE USE_DSP OF s_out     : SIGNAL IS "YES";

BEGIN

    PROCESS BEGIN
        REPORT "C_NUM_PART=" & integer'image(C_NUM_PART) & " G_DATA_WIDTH=" & integer'image(G_DATA_WIDTH);
        REPORT "C_NUM_CEIL=" & integer'image(C_NUM_CEIL) & " C_NUM_BIT_CEIL=" & integer'image(C_NUM_BIT_CEIL);
        REPORT "C_NUM_FLOOR=" & integer'image(C_NUM_FLOOR) & " C_NUM_BIT_FLOOR=" & integer'image(C_NUM_BIT_FLOOR);

        -- ASSERT false SEVERITY failure;
        WAIT;
    END PROCESS;

    -------------------------------------------
    -- reg/wire input
    -------------------------------------------
    gen_input_reg : IF G_INPUT_REG = true GENERATE
        PROCESS (i_clk) BEGIN
            IF rising_edge(i_clk) THEN
                a_in   <= iv_a;
                b_in   <= iv_b;
                c_in   <= i_c;
                vld_in <= i_vld;
            END IF;
        END PROCESS;
    END GENERATE gen_input_reg;

    gen_input_wire : IF G_INPUT_REG = false GENERATE
        a_in   <= iv_a;
        b_in   <= iv_b;
        c_in   <= i_c;
        vld_in <= i_vld;
    END GENERATE gen_input_wire;

    -------------------------------------------
    -- Main Logic
    -------------------------------------------

    gen_num_pipe_gt_zero : IF G_NUM_PIPE > 0 GENERATE
        -------------------------------------------
        -- Pipeline

        PROCESS (i_clk) BEGIN
            IF rising_edge(i_clk) THEN
                FOR i IN 1 TO (C_NUM_PART - 1) LOOP
                    IF i = 1 THEN
                        a_d(1) <= a_in;
                        b_d(1) <= b_in;
                    ELSE
                        a_d(i) <= a_d(i - 1);
                        b_d(i) <= b_d(i - 1);
                    END IF;
                END LOOP;
            END IF;
        END PROCESS;

        PROCESS (i_clk) BEGIN
            IF rising_edge(i_clk) THEN
                vld_d(0) <= vld_in;
                FOR i IN vld_d'low + 1 TO vld_d'high LOOP
                    vld_d(i) <= vld_d(i - 1);
                END LOOP;
            END IF;
        END PROCESS;

        -------------------------------------------
        -- partial sum Calculation
        PROCESS (i_clk)
            VARIABLE var_high : integer;
            VARIABLE var_low  : integer;
            VARIABLE var_base : integer;
        BEGIN
            IF rising_edge(i_clk) THEN
                FOR i IN 0 TO (C_NUM_PART - 2) LOOP -- loop until the last 2nd because the last one should be wire
                    IF i = 0 THEN

                        sum_ceil(0) <= std_logic_vector(
                                       resize(unsigned(a_in(C_NUM_BIT_CEIL - 1 DOWNTO 0)), C_NUM_BIT_CEIL + 1) +
                                       resize(unsigned(b_in(C_NUM_BIT_CEIL - 1 DOWNTO 0)), C_NUM_BIT_CEIL + 1) +
                                       ("" & c_in)
                                       );

                    ELSIF i < C_NUM_CEIL THEN

                        var_high := C_NUM_BIT_CEIL * (i + 1) - 1;
                        var_low  := C_NUM_BIT_CEIL * i;

                        sum_ceil(i) <= std_logic_vector(
                                       resize(unsigned(a_in(var_high DOWNTO var_low)), C_NUM_BIT_CEIL + 1) +
                                       resize(unsigned(b_in(var_high DOWNTO var_low)), C_NUM_BIT_CEIL + 1) +
                                       ("" & sum_ceil(i - 1)(C_NUM_BIT_CEIL))
                                       );

                    ELSIF i = C_NUM_CEIL THEN

                        var_base := (C_NUM_CEIL - 1) * C_NUM_BIT_CEIL;
                        var_high := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL + 1) - 1 + var_base;
                        var_low  := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL) + var_base;

                        sum_floor(i - C_NUM_CEIL) <= std_logic_vector(
                                                     resize(unsigned(a_in(var_high DOWNTO var_low)), C_NUM_BIT_FLOOR + 1) +
                                                     resize(unsigned(b_in(var_high DOWNTO var_low)), C_NUM_BIT_FLOOR + 1) +
                                                     ("" & sum_ceil(C_NUM_CEIL - 1)(C_NUM_BIT_CEIL))
                                                     );

                    ELSE

                        var_base := (C_NUM_CEIL - 1) * C_NUM_BIT_CEIL;
                        var_high := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL + 1) - 1 + var_base;
                        var_low  := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL) + var_base;

                        sum_floor(i - C_NUM_CEIL) <= std_logic_vector(
                                                     resize(unsigned(a_in(var_high DOWNTO var_low)), C_NUM_BIT_FLOOR + 1) +
                                                     resize(unsigned(b_in(var_high DOWNTO var_low)), C_NUM_BIT_FLOOR + 1) +
                                                     ("" & sum_floor(i - C_NUM_CEIL - 1)(C_NUM_BIT_FLOOR))
                                                     );
                    END IF;
                END LOOP;
            END IF;
        END PROCESS;

        -------------------------------------------
        -- last partial sum

        gen_last_sum_num_floor_eq_zero : IF C_NUM_FLOOR = 0 GENERATE
            PROCESS (a_d, b_d, sum_ceil, sum_floor) BEGIN
                sum_ceil(C_NUM_CEIL - 1) <= std_logic_vector(
                                            resize(signed(a_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_CEIL)), C_NUM_BIT_CEIL + 1) +
                                            resize(signed(b_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_CEIL)), C_NUM_BIT_CEIL + 1) +
                                            ("0" & sum_ceil(C_NUM_PART - 2)(C_NUM_BIT_CEIL))
                                            );
            END PROCESS;
        END GENERATE gen_last_sum_num_floor_eq_zero;
        gen_last_sum_num_floor_eq_one : IF C_NUM_FLOOR = 1 GENERATE
            PROCESS (a_d, b_d, sum_ceil, sum_floor) BEGIN
                sum_floor(0) <= std_logic_vector(
                                resize(signed(a_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR)), C_NUM_BIT_FLOOR + 1) +
                                resize(signed(b_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR)), C_NUM_BIT_FLOOR + 1) +
                                ("0" & sum_ceil(C_NUM_CEIL - 1)(C_NUM_BIT_CEIL))
                                );
            END PROCESS;
        END GENERATE gen_last_sum_num_floor_eq_one;
        gen_last_sum_num_floor_gt_one : IF C_NUM_FLOOR > 1 GENERATE
            PROCESS (a_d, b_d, sum_ceil, sum_floor) BEGIN
                sum_floor(C_NUM_FLOOR - 1) <= std_logic_vector(
                                              resize(signed(a_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR)), C_NUM_BIT_FLOOR + 1) +
                                              resize(signed(b_in(G_DATA_WIDTH - 1 DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR)), C_NUM_BIT_FLOOR + 1) +
                                              ("0" & sum_floor(C_NUM_FLOOR - 1)(C_NUM_BIT_FLOOR))
                                              );
            END PROCESS;
        END GENERATE gen_last_sum_num_floor_gt_one;

        -------------------------------------------
        -- Delay of partial sum
        -- PROCESS (i_clk) BEGIN
        --     IF rising_edge(i_clk) THEN

        --         FOR i IN 0 TO C_NUM_PART - 1 LOOP
        --             IF i < C_NUM_CEIL THEN

        --                 FOR j IN i + 1 TO sum_ceil_d'high LOOP
        --                     IF j = i + 1 THEN
        --                         sum_ceil_d(j, i) <= sum_ceil(i);
        --                     ELSE
        --                         sum_ceil_d(j, i) <= sum_ceil_d(j - 1, i);
        --                     END IF;
        --                 END LOOP;

        --             ELSE

        --                 FOR j IN i + 1 TO sum_floor_d'high LOOP
        --                     IF j = i + 1 THEN
        --                         sum_floor_d(j, i - C_NUM_CEIL) <= sum_floor(i - C_NUM_CEIL);
        --                     ELSE
        --                         sum_floor_d(j, i - C_NUM_CEIL) <= sum_floor_d(j - 1, i - C_NUM_CEIL);
        --                     END IF;
        --                 END LOOP;

        --             END IF;
        --         END LOOP;

        --     END IF;
        -- END PROCESS;

        -------------------------------------------
        -- Assign partial sum to final sum
        PROCESS (sum_ceil, sum_ceil_d, sum_floor, sum_floor_d)
            VARIABLE var_high : integer;
            VARIABLE var_low  : integer;
            VARIABLE var_base : integer;
        BEGIN
            FOR i IN (C_NUM_PART - 1) DOWNTO 0 LOOP

                IF C_NUM_FLOOR > 2 THEN

                    IF i = (C_NUM_PART - 1) THEN
                        s_out(G_DATA_WIDTH DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR) <= sum_floor(i - C_NUM_CEIL);
                    ELSIF i = (C_NUM_PART - 2) THEN
                        var_base := (C_NUM_CEIL - 1) * C_NUM_BIT_CEIL;
                        var_high := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL + 1) - 1 + var_base;
                        var_low  := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL) + var_base;

                        s_out(var_high DOWNTO var_low) <= sum_floor(i - C_NUM_CEIL)(C_NUM_BIT_FLOOR - 1 DOWNTO 0);

                    ELSIF i >= C_NUM_CEIL THEN
                        var_base := (C_NUM_CEIL - 1) * C_NUM_BIT_CEIL;
                        var_high := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL + 1) - 1 + var_base;
                        var_low  := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL) + var_base;

                        s_out(var_high DOWNTO var_low) <= sum_floor(i - C_NUM_CEIL)(C_NUM_BIT_FLOOR - 1 DOWNTO 0);

                        -- s_out(var_high DOWNTO var_low) <= sum_floor_d(i + 1, i - C_NUM_CEIL)(C_NUM_BIT_FLOOR - 1 DOWNTO 0);

                    ELSE
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);

                        -- s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil_d(i + 1, i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    END IF;

                ELSIF C_NUM_FLOOR = 2 THEN

                    IF i = (C_NUM_PART - 1) THEN
                        s_out(G_DATA_WIDTH DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR) <= sum_floor(i - C_NUM_CEIL);
                    ELSIF i = (C_NUM_PART - 2) THEN
                        var_base := (C_NUM_CEIL - 1) * C_NUM_BIT_CEIL;
                        var_high := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL + 1) - 1 + var_base;
                        var_low  := C_NUM_BIT_FLOOR * (i - C_NUM_CEIL) + var_base;

                        s_out(var_high DOWNTO var_low) <= sum_floor(i - C_NUM_CEIL)(C_NUM_BIT_FLOOR - 1 DOWNTO 0);
                    ELSE
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                        -- s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil_d(i + 1, i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    END IF;

                ELSIF C_NUM_FLOOR = 1 THEN

                    IF i = (C_NUM_PART - 1) THEN
                        s_out(G_DATA_WIDTH DOWNTO G_DATA_WIDTH - C_NUM_BIT_FLOOR) <= sum_floor(i - C_NUM_CEIL);
                    ELSIF i = (C_NUM_PART - 2) THEN
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    ELSE
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                        -- s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil_d(i + 1, i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    END IF;

                ELSIF C_NUM_FLOOR = 0 THEN

                    IF i = (C_NUM_PART - 1) THEN
                        s_out(G_DATA_WIDTH DOWNTO G_DATA_WIDTH - C_NUM_BIT_CEIL) <= sum_ceil(i);
                    ELSIF i = (C_NUM_PART - 2) THEN
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    ELSE
                        s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil(i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                        -- s_out(C_NUM_BIT_CEIL * (i + 1) - 1 DOWNTO C_NUM_BIT_CEIL * i) <= sum_ceil_d(i + 1, i)(C_NUM_BIT_CEIL - 1 DOWNTO 0);
                    END IF;

                END IF;

            END LOOP;
        END PROCESS;

    END GENERATE gen_num_pipe_gt_zero;

    gen_num_pipe_eq_zero : IF G_NUM_PIPE = 0 GENERATE

        s_out <= std_logic_vector(
                 resize(signed(a_in), s_out'length) +
                 resize(signed(b_in), s_out'length) +
                 ("0" & c_in)
                 );

        PROCESS (vld_in) BEGIN
            vld_d <= (OTHERS => vld_in);
        END PROCESS;

    END GENERATE gen_num_pipe_eq_zero;

    -------------------------------------------
    -- reg/wire output
    -------------------------------------------
    gen_output_reg : IF G_OUTPUT_REG = true GENERATE
        PROCESS (i_clk) BEGIN
            IF rising_edge(i_clk) THEN
                ov_s  <= s_out;
                o_vld <= vld_d(vld_d'high);
            END IF;
        END PROCESS;
    END GENERATE gen_output_reg;

    gen_output_wire : IF G_OUTPUT_REG = false GENERATE
        ov_s  <= s_out;
        o_vld <= vld_d(vld_d'high);
    END GENERATE gen_output_wire;

END ARCHITECTURE;