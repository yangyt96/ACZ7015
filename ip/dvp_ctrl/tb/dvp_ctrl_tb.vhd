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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;
context vunit_lib.vc_context;

entity dvp_ctrl_tb is
  generic (
    runner_cfg : string
  );
end;

architecture bench of dvp_ctrl_tb is
  -- Clock period
  constant clk_period : time := 10 ns;
  constant dvp_period : time := 1.0/96.0e6 * 1000 ms;
  -- Generics
  constant P_DVP_DATA_WIDTH  : integer := 8;
  constant P_AXIS_DATA_WIDTH : integer := 64;
  constant P_AXIL_DATA_WIDTH : integer := 32;
  constant P_AXIL_ADDR_WIDTH : integer := 4;
  -- Ports
  signal i_dvp_pclk     : std_logic := '1';
  signal i_dvp_vsync    : std_logic;
  signal i_dvp_href     : std_logic;
  signal i_dvp_data     : std_logic_vector (P_DVP_DATA_WIDTH - 1 downto 0);
  signal o_dvp_resetb   : std_logic;
  signal o_dvp_pwdn     : std_logic;
  signal o_dvp_xvclk    : std_logic;
  signal i_dvp_xvclk    : std_logic;
  signal i_axi_clk      : std_logic := '1';
  signal i_axi_rst      : std_logic;
  signal m_axis_tvalid  : std_logic;
  signal m_axis_tready  : std_logic;
  signal m_axis_tdata   : std_logic_vector (P_AXIS_DATA_WIDTH - 1 downto 0);
  signal s_axil_awaddr  : std_logic_vector (P_AXIL_ADDR_WIDTH - 1 downto 0);
  signal s_axil_awprot  : std_logic_vector (2 downto 0);
  signal s_axil_awvalid : std_logic;
  signal s_axil_awready : std_logic;
  signal s_axil_wdata   : std_logic_vector (P_AXIL_DATA_WIDTH - 1 downto 0);
  signal s_axil_wstrb   : std_logic_vector (P_AXIL_DATA_WIDTH/8 - 1 downto 0);
  signal s_axil_wvalid  : std_logic;
  signal s_axil_wready  : std_logic;
  signal s_axil_bresp   : std_logic_vector (1 downto 0);
  signal s_axil_bvalid  : std_logic;
  signal s_axil_bready  : std_logic;
  signal s_axil_araddr  : std_logic_vector (P_AXIL_ADDR_WIDTH - 1 downto 0);
  signal s_axil_arprot  : std_logic_vector (2 downto 0);
  signal s_axil_arvalid : std_logic;
  signal s_axil_arready : std_logic;
  signal s_axil_rdata   : std_logic_vector (P_AXIL_DATA_WIDTH - 1 downto 0);
  signal s_axil_rresp   : std_logic_vector (1 downto 0);
  signal s_axil_rvalid  : std_logic;
  signal s_axil_rready  : std_logic;

  constant axil_bus : bus_master_t := new_bus(
  data_length    => P_AXIL_DATA_WIDTH,
  address_length => P_AXIL_ADDR_WIDTH,
  logger         => get_logger("axil_bus")
  );

begin

  dvp_ctrl_inst : entity work.dvp_ctrl
    generic map(
      P_DVP_DATA_WIDTH  => P_DVP_DATA_WIDTH,
      P_AXIS_DATA_WIDTH => P_AXIS_DATA_WIDTH,
      P_AXIL_DATA_WIDTH => P_AXIL_DATA_WIDTH,
      P_AXIL_ADDR_WIDTH => P_AXIL_ADDR_WIDTH
    )
    port map
    (
      i_dvp_pclk   => i_dvp_pclk,
      i_dvp_vsync  => i_dvp_vsync,
      i_dvp_href   => i_dvp_href,
      i_dvp_data   => i_dvp_data,
      o_dvp_resetb => o_dvp_resetb,
      o_dvp_pwdn   => o_dvp_pwdn,
      o_dvp_xvclk  => o_dvp_xvclk,
      i_dvp_xvclk  => i_dvp_xvclk,

      i_axi_clk => i_axi_clk,
      i_axi_rst => i_axi_rst,

      m_axis_tvalid => m_axis_tvalid,
      m_axis_tready => m_axis_tready,
      m_axis_tdata  => m_axis_tdata,

      s_axil_awaddr  => s_axil_awaddr,
      s_axil_awprot  => s_axil_awprot,
      s_axil_awvalid => s_axil_awvalid,
      s_axil_awready => s_axil_awready,

      s_axil_wdata  => s_axil_wdata,
      s_axil_wstrb  => s_axil_wstrb,
      s_axil_wvalid => s_axil_wvalid,
      s_axil_wready => s_axil_wready,

      s_axil_bresp  => s_axil_bresp,
      s_axil_bvalid => s_axil_bvalid,
      s_axil_bready => s_axil_bready,

      s_axil_araddr  => s_axil_araddr,
      s_axil_arprot  => s_axil_arprot,
      s_axil_arvalid => s_axil_arvalid,
      s_axil_arready => s_axil_arready,

      s_axil_rdata  => s_axil_rdata,
      s_axil_rresp  => s_axil_rresp,
      s_axil_rvalid => s_axil_rvalid,
      s_axil_rready => s_axil_rready
    );

  axil_master_vcc : entity vunit_lib.axi_lite_master
    generic map(
      bus_handle => axil_bus
    )
    port map
    (
      aclk => i_axi_clk,

      arready => s_axil_arready,
      arvalid => s_axil_arvalid,
      araddr  => s_axil_araddr,

      rready => s_axil_rready,
      rvalid => s_axil_rvalid,
      rdata  => s_axil_rdata,
      rresp  => s_axil_rresp,

      awready => s_axil_awready,
      awvalid => s_axil_awvalid,
      awaddr  => s_axil_awaddr,

      wready => s_axil_wready,
      wvalid => s_axil_wvalid,
      wdata  => s_axil_wdata,
      wstrb  => s_axil_wstrb,

      bvalid => s_axil_bvalid,
      bready => s_axil_bready,
      bresp  => s_axil_bresp
    );

  main : process
    variable var_slv32 : std_logic_vector(31 downto 0);
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_alive") then

        i_axi_rst <= '1';
        wait for 1 * clk_period;
        i_axi_rst <= '0';
        wait for 10 * clk_period;

        for i in 0 to 15 loop
          read_bus(net, axil_bus, std_logic_vector(to_unsigned(i, P_AXIL_ADDR_WIDTH)), var_slv32);
          report to_hstring(var_slv32);
        end loop;

        write_bus(net, axil_bus, x"0", x"0000_0000");
        read_bus(net, axil_bus, x"0", var_slv32);
        report to_hstring(var_slv32);

        write_bus(net, axil_bus, x"0", x"ffff_ffff");

        for i in 0 to 15 loop
          read_bus(net, axil_bus, std_logic_vector(to_unsigned(i, P_AXIL_ADDR_WIDTH)), var_slv32);
          report to_hstring(var_slv32);
        end loop;

      end if;
      test_runner_cleanup(runner);
    end loop;
    wait;
  end process main;

  i_dvp_vsync   <= '0';
  i_dvp_href    <= '0';
  i_dvp_data    <= (others => '0');
  m_axis_tready <= '0';

  i_axi_clk <= not i_axi_clk after clk_period/2;

  i_dvp_pclk <= not i_dvp_pclk after dvp_period/2;
end;