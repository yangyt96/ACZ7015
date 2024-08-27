

#include <stdint.h>

#define DVPCTRL_CTRL 0x0
#define DVPCTRL_FIFO_STAT 0x4
#define DVPCTRL_FIFO_WR_CNT 0x8
#define DVPCTRL_FIFO_WR_CNT 0xc

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
    uint16_t DeviceId;
    uintptr_t BaseAddress;
} DvpCtrl_Config;

typedef struct
{
    DvpCtrl_Config Config;
    DvpCtrl_Ctrl ctrl;
    DvpCtrl_Stat stat;
    uint32_t fifo_wr_cnt;
    uint32_t fifo_rd_cnt;
} DvpCtrl;

DvpCtrl_Config *DvpCtrl_LookupConfig(uint16_t DeviceId);
int32_t DvpCtrl_CfgInitialize(DvpCtrl *InstancePtr, DvpCtrl_Config *CfgPtr, uintptr_t EffectiveAddr);
int32_t DvpCtrl_HwReset(DvpCtrl *InstancePtr);
int32_t DvpCtrl_Enable(DvpCtrl *InstancePtr);
int32_t DvpCtrl_SetEndian(DvpCtrl *InstancePtr);
int32_t DvpCtrl_SetDropVsync(DvpCtrl *InstancePtr, uint8_t Count);
int32_t DvpCtrl_GetFifoStat(DvpCtrl *InstancePtr);
int32_t DvpCtrl_GetFifoWrCnt(DvpCtrl *InstancePtr);
int32_t DvpCtrl_GetFifoRdCnt(DvpCtrl *InstancePtr);
