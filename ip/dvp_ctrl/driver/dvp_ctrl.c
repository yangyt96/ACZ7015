/*************************************************************************
    Copyright [2024] [Tan Yee Yang]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*************************************************************************/

#include "dvp_ctrl.h"

int32_t DvpCtrl_Initialize(DvpCtrl *inst, uintptr_t base_addr)
{
    if (inst == NULL)
        return EXIT_FAILURE;
    inst->base_addr = base_addr;
    return DvpCtrl_Reset_Hardware(inst);
}
int32_t DvpCtrl_Reset_Hardware(DvpCtrl *inst)
{
    int32_t status;
    DvpCtrl_Ctrl ctrl = DvpCtrl_Get_Control(inst);
    ctrl.dvp_pwdn = 1;
    ctrl.dvp_resetb = 0;
    status = DvpCtrl_Set_Control(inst, ctrl);
    if (status == EXIT_FAILURE)
        return status;
    usleep(5000); // 5 ms pwdn
    ctrl.dvp_pwdn = 0;
    status = DvpCtrl_Set_Control(inst, ctrl);
    if (status == EXIT_FAILURE)
        return status;
    usleep(1000); // 1 ms resetb
    ctrl.dvp_resetb = 1;
    return DvpCtrl_Set_Control(inst, ctrl);
}

DvpCtrl_Ctrl DvpCtrl_Get_Control(DvpCtrl *inst)
{
    uint32_t tmp = DvpCtrl_mReadReg(inst->base_addr, DVPCTRL_CTRL_OFFSET);
    DvpCtrl_Ctrl *ctrl = (void *)&tmp;
    return *ctrl;
}
DvpCtrl_Stat DvpCtrl_Get_Fifo_Status(DvpCtrl *inst)
{
    uint32_t tmp = DvpCtrl_mReadReg(inst->base_addr, DVPCTRL_FIFO_STAT_OFFSET);
    DvpCtrl_Stat *ret = (void *)&tmp;
    return *ret;
}
int32_t DvpCtrl_Get_Fifo_Wr_Count(DvpCtrl *inst)
{
    return DvpCtrl_mReadReg(inst->base_addr, DVPCTRL_FIFO_WR_CNT_OFFSET);
}
int32_t DvpCtrl_Get_Fifo_Rd_Count(DvpCtrl *inst)
{
    return DvpCtrl_mReadReg(inst->base_addr, DVPCTRL_FIFO_RD_CNT_OFFSET);
}
int32_t DvpCtrl_Set_Control(DvpCtrl *inst, DvpCtrl_Ctrl ctrl)
{
    uint32_t *tmp = (void *)&ctrl;
    DvpCtrl_mWriteReg(inst->base_addr, DVPCTRL_CTRL_OFFSET, *tmp);
    return EXIT_SUCCESS;
}
int32_t DvpCtrl_Set_Endian(DvpCtrl *inst, bool param)
{
    DvpCtrl_Ctrl ctrl = DvpCtrl_Get_Control(inst);
    ctrl.axis_endian = param;
    return DvpCtrl_Set_Control(inst, ctrl);
}
int32_t DvpCtrl_Set_Enable(DvpCtrl *inst)
{
    DvpCtrl_Ctrl ctrl = DvpCtrl_Get_Control(inst);
    ctrl.dvp_ena = 1;
    return DvpCtrl_Set_Control(inst, ctrl);
}
int32_t DvpCtrl_Set_Disable(DvpCtrl *inst)
{
    DvpCtrl_Ctrl ctrl = DvpCtrl_Get_Control(inst);
    ctrl.dvp_ena = 0;
    return DvpCtrl_Set_Control(inst, ctrl);
}
int32_t DvpCtrl_Set_Drop_Vsync(DvpCtrl *inst, uint8_t cnt)
{
    DvpCtrl_Ctrl ctrl = DvpCtrl_Get_Control(inst);
    ctrl.dvp_drop_vsync = cnt;
    return DvpCtrl_Set_Control(inst, ctrl);
}
