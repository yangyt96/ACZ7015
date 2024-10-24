#ifndef _OV5640_H_
#define _OV5640_H_

#include "COMMON.h"
#include "AXI_IIC.h"

#define	SCCB_ID    0x78>>1   //OV5640�豸��ַ
#define SCCB_Write(addr, data)	AXI_IIC_Write_Reg(&SCCB, SCCB_ID, REG16, addr, data)
#define SCCB_Read(addr)			AXI_IIC_Read_Reg(&SCCB, SCCB_ID, REG16, addr)
#define IIC_DEVICE_ID			XPAR_AXI_IIC_0_DEVICE_ID


void OV5640_Init();


#endif
