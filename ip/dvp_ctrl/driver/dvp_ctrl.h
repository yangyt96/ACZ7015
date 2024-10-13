/*
 * dvp_ctrl.h
 *
 *  Created on: Oct 11, 2024
 *      Author: yang
 */

#ifndef DVP_CTRL_H
#define DVP_CTRL_H

/****************** Include Files ********************/
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>

#define DVPCTRL_CTRL_OFFSET 0x0
#define DVPCTRL_FIFO_STAT_OFFSET 0x4
#define DVPCTRL_FIFO_WR_CNT_OFFSET 0x8
#define DVPCTRL_FIFO_RD_CNT_OFFSET 0xc


/**************************** Type Definitions *****************************/

/**
 *
 * Write a value to a DVPCTRL register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the DVPCTRLdevice.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void DvpCtrl_mWriteReg(uint32_t BaseAddress, unsigned RegOffset, uint32_t Data)
 *
 */
#define DvpCtrl_mWriteReg(BaseAddress, RegOffset, Data) \
  	Xil_Out32((BaseAddress) + (RegOffset), (uint32_t)(Data))

/**
 *
 * Read a value from a DVPCTRL register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the DVPCTRL device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	uint32_t DvpCtrl_mReadReg(uint32_t BaseAddress, unsigned RegOffset)
 *
 */
#define DvpCtrl_mReadReg(BaseAddress, RegOffset) \
    Xil_In32((BaseAddress) + (RegOffset))


typedef struct __attribute__((__packed__))
{
    uint8_t axis_endian : 1; // [0]
    uint8_t pad0 : 7;        // [7:1]
    uint8_t dvp_pwdn : 1;    // [8]
    uint8_t dvp_resetb : 1;  // [9]
    uint8_t pad1 : 6;        // [15:10]
    uint8_t dvp_ena : 1;     // [16]
    uint8_t pad2;            // [23:17]
    uint8_t dvp_drop_vsync;  // [31:24]
} DvpCtrl_Ctrl;

typedef struct __attribute__((__packed__))
{
    uint8_t wr_stat;
    uint8_t pad0;
    uint8_t rd_stat;
    uint8_t pad1;
} DvpCtrl_Stat;

typedef struct
{
    uintptr_t base_addr;
} DvpCtrl;


/************************** Function Prototypes ****************************/

int32_t DvpCtrl_Initialize(DvpCtrl *inst, uintptr_t base_addr);
int32_t DvpCtrl_Reset_Hardware(DvpCtrl *inst);
int32_t DvpCtrl_Set_Endian(DvpCtrl *inst, bool param);
int32_t DvpCtrl_Set_Enable(DvpCtrl *inst);
int32_t DvpCtrl_Set_Disable(DvpCtrl *inst);
int32_t DvpCtrl_Set_Drop_Vsync(DvpCtrl *inst, uint8_t cnt);

DvpCtrl_Stat DvpCtrl_Get_Fifo_Status(DvpCtrl *inst);
int32_t DvpCtrl_Get_Fifo_Wr_Count(DvpCtrl *inst);
int32_t DvpCtrl_Get_Fifo_Rd_Count(DvpCtrl *inst);

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the DVPCTRL instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
int32_t DvpCtrl_Reg_SelfTest(void * baseaddr_p);


#endif /* DVP_CTRL_H */
