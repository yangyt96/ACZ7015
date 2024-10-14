#ifndef ACZ7015_LIB_COMMON_H_
#define ACZ7015_LIB_COMMON_H_


//ϵͳͷ�ļ�
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <stdarg.h>
#include <stdint.h>

//Xilinxͷ�ļ�
#include "xil_types.h"
#include "xil_cache.h"
#include "sleep.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xscugic.h"
#include "xscutimer.h"


//ACZ7015ͷ�ļ�
#include "ISR.h"
#include "lcd.h"

#include "lcd.h"
#include "OV5640.h"
#include "PS_IIC.h"
#include "SCU_GIC.h"
#include "SCU_TIMER.h"
#include "SII9022.h"

//�û�ͷ�ļ�



//�û��궨��
#define	CPU_CLK_HZ	XPAR_PS7_CORTEXA9_0_CPU_CLK_FREQ_HZ	//CPUʱ��Ƶ��(��λHz)
#define INPUT		1
#define OUTPUT		0
#define	REG8		8
#define	REG16		16

//�û���������

#endif /* ACZ7015_LIB_COMMON_H_ */