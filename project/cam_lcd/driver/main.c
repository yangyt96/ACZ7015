#include "COMMON.h"
#include "DVP_Capture2DDR.h"
#include "dvp_ctrl.h"

#define	WRITE_CAMERA_REG	DVP_CAPTURE2DDR_mWriteReg
#define	REG_ONOFF			DVP_CAPTURE2DDR_S00_AXI_SLV_REG0_OFFSET
#define	CAMERA_REG_BASEADDR 0x43C10000
#define OPEN_CAMERA			WRITE_CAMERA_REG(CAMERA_REG_BASEADDR,REG_ONOFF,1)
#define	CLOSE_CAMERA		WRITE_CAMERA_REG(CAMERA_REG_BASEADDR,REG_ONOFF,0)
#define Image_Storage_Addr	0x01800000

int main()
{
	xil_printf("Hello World!\n");
	DvpCtrl inst_dvpctrl;
	DvpCtrl_Initialize(&inst_dvpctrl, 0x43C30000);
	LCD_Init();
	SII9022_Init();
	OV5640_Init();

	OPEN_CAMERA;
	DvpCtrl_Set_Drop_Vsync(&inst_dvpctrl, 10);
	DvpCtrl_Set_Endian(&inst_dvpctrl, 1);
	DvpCtrl_Set_Enable(&inst_dvpctrl);

	//锟斤拷始锟斤拷Display controller
	DisplayInitialize(&DispCtrl, DISP_VTC_ID, DYNCLK_ID);

	//锟斤拷锟斤拷VideoMode
	DisplaySetMode(&DispCtrl, &RGB_LCD);
	printf("Done init \n");

	//锟斤拷锟斤拷VDMA锟斤拷锟斤拷取图锟斤拷娲拷锟街凤拷锟酵硷拷锟斤拷锟斤拷锟�
	run_vdma_frame_buffer(&Vdma, VDMA_ID, RGB_LCD.width, RGB_LCD.height,
			Image_Storage_Addr,0, 0,ONLY_READ);

	xil_printf("start display");
	DisplayStart(&DispCtrl);
	xil_printf("start display done");

	printf("Done\n");//*/

	return 0;
}

