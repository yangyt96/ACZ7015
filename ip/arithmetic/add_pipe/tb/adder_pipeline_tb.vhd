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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

LIBRARY osvvm;
USE osvvm.RandomPkg.ALL;
USE osvvm.CoveragePkg.ALL;

ENTITY adder_pipeline_tb IS
    GENERIC (

        -- dut
        G_DATA_WIDTH : integer := 32;
        G_INPUT_REG  : boolean := true;
        G_OUTPUT_REG : boolean := true;
        G_NUM_PIPE   : integer := 10;

        -- random test itreation
        G_RANDOM_ITER : integer := 100;

        -- vunit
        runner_cfg : string
    );
END;

ARCHITECTURE bench OF adder_pipeline_tb IS
    -- Clock period
    CONSTANT C_CLK_PERIOD : time := 1 ns;

    -- Generics

    -- Ports
    SIGNAL i_clk : std_logic := '1';

    SIGNAL i_vld : std_logic;
    SIGNAL iv_a  : std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL iv_b  : std_logic_vector(G_DATA_WIDTH - 1 DOWNTO 0);

    SIGNAL i_c   : std_logic;
    SIGNAL o_vld : std_logic;
    SIGNAL ov_s  : std_logic_vector(G_DATA_WIDTH DOWNTO 0);

    -- OSVVM
    SHARED VARIABLE rv : RandomPType;

BEGIN

    adder_pipeline_inst : ENTITY work.adder_pipeline
        GENERIC MAP(
            G_DATA_WIDTH => G_DATA_WIDTH,
            G_INPUT_REG  => G_INPUT_REG,
            G_OUTPUT_REG => G_OUTPUT_REG,
            G_NUM_PIPE   => G_NUM_PIPE
        )
        PORT MAP(
            i_clk => i_clk,
            i_vld => i_vld,
            iv_a  => iv_a,
            iv_b  => iv_b,
            i_c   => i_c,
            o_vld => o_vld,
            ov_s  => ov_s
        );

    main : PROCESS
        VARIABLE var_a : signed(G_DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE var_b : signed(G_DATA_WIDTH - 1 DOWNTO 0);
        VARIABLE var_c : std_logic;
        VARIABLE var_s : std_logic_vector(G_DATA_WIDTH DOWNTO 0);

    BEGIN
        test_runner_setup(runner, runner_cfg);
        WHILE test_suite LOOP

            i_vld <= '0';
            iv_a  <= (OTHERS => '0');
            iv_b  <= (OTHERS => '0');
            i_c   <= '0';
            WAIT UNTIL rising_edge(i_clk);

            IF run("test_corner_case") THEN

                -- test 1
                i_vld <= '1';
                iv_a  <= std_logic_vector(to_signed(-1, iv_a'length));
                iv_b  <= std_logic_vector(to_signed(0, iv_b'length));
                i_c   <= '1';
                WAIT UNTIL rising_edge(i_clk);

                i_vld <= '0';
                -- iv_a  <= std_logic_vector(to_signed(0, iv_a'length));
                -- iv_b  <= std_logic_vector(to_signed(0, iv_b'length));
                -- i_c   <= '0';

                WAIT UNTIL rising_edge(o_vld);
                var_s := (others => '0');
                check_equal(ov_s, var_s);

                WAIT FOR 10 * C_CLK_PERIOD;

            ELSIF run("test_random") THEN

                FOR i IN 0 TO G_RANDOM_ITER LOOP

                    var_a := rv.RandSigned(G_DATA_WIDTH);
                    var_b := rv.RandSigned(G_DATA_WIDTH);

                    IF rv.RandInt(0, 1) = 0 THEN
                        var_c := '0';
                    ELSE
                        var_c := '1';
                    END IF;
                    -- var_c := rv.RandSl;

                    i_vld <= '1';
                    iv_a  <= std_logic_vector(var_a);
                    iv_b  <= std_logic_vector(var_b);
                    i_c   <= var_c;
                    WAIT UNTIL rising_edge(i_clk);

                    i_vld <= '0';
                    WAIT UNTIL rising_edge(o_vld);

                    var_s := std_logic_vector(
                             resize(signed(var_a), var_s'length) +
                             signed(var_b) +
                             ("0" & var_c)
                             );

                    check_equal(ov_s, var_s);

                    WAIT UNTIL rising_edge(i_clk);

                END LOOP;

            END IF;

            test_runner_cleanup(runner);

        END LOOP;
    END PROCESS main;

    i_clk <= NOT i_clk AFTER C_CLK_PERIOD/2;

END;