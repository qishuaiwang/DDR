#include <dram.h>
#include "dram-reg.h"
#include <asm/io.h>

//#define DQS_ADDR    0x7FFFE000
//#define DQS_ADDR    0x44FFE000
#define DQS_ADDR    0x40000000
#define CRC_MAGIC   0x5a6a7a99

/*1: means 32bit, 2 means 16bit*/
#define MEMC_FREQ_RATIO    2

#define MEMC_DRAM_DATA_WIDTH 16

/*
 * author:tsico
 * aim:for ddr3 2T Timing mode
 * *****************************/
#define MEMC_2T_MODE 0
/*******************************/

/*apollo IRAM test (8*3K*64bit+8KB=200KB), only test critical data*/
#define IRAM_TEST 1
static volatile int dramc_wake_up_flag = 0;
#define MARGIN_OFF 0
#if 1
#define DDR_TEST_BYTE
#endif
#define DDR_ASSERT() { \
    ddr_test_fail(); \
	while(1); \
} 

enum rtl_stage {
	RTL_NOINIT = 0,   /* RTL is not running */
	RTL_STARTING = 0x85, /* RTL test is beginning to start */
	RTL_PASS = 0x50, /* RTL test is finished, and result OK */
	RTL_DONE = 0x26, /* RTL test is finished, but you need to manually check the result */
	RTL_FAIL = 0x46, /* RTL test is finished, and result FAILED */
	RTL_ERROR = 0xee, /* RTL test program error */
	RTL_MEMSET = 0x70, /* RTL host memset action */
	RTL_MEMCPY = 0x77, /* RTL host memcpy action */
};

unsigned int lds_indicate = 0x42000000;
void rtl_host_set(int value)
{
    writel(value, lds_indicate);
}

void ddr_test_start(void)
{
    rtl_host_set(RTL_STARTING);
}

void ddr_test_pass(void)
{
    rtl_host_set(RTL_PASS);
}

void ddr_test_fail(void)
{
    rtl_host_set(RTL_FAIL);
}

void testchar(void)
{
	unsigned int i;
	volatile unsigned char value0;
	volatile unsigned char value1;
	volatile unsigned char value2;
	volatile unsigned char value3;
		
	for (i = 0; i < 0xffffff; i++)
	{
		*(unsigned char *)(0x44000000+i*4) = i&0xff;
		*(unsigned char *)(0x44000000+i*4+1) = i&0xff;
		*(unsigned char *)(0x44000000+i*4+2) = i&0xff;
		*(unsigned char *)(0x44000000+i*4+3) = i&0xff;
		value0 = *(unsigned char *)(0x44000000+i*4);
		value1 = *(unsigned char *)(0x44000000+i*4+1);
		value2 = *(unsigned char *)(0x44000000+i*4+2);
		value3 = *(unsigned char *)(0x44000000+i*4+3);
		if (value0 != (i&0xff))
		{
		    DDR_ASSERT();
		}
		if (value1 != (i&0xff))
		{
     		DDR_ASSERT();
		}
		if (value2 != (i&0xff))
		{
		    DDR_ASSERT();
		}
		if (value3 != (i&0xff))
		{
		    DDR_ASSERT();
		}
	}
}
void test_zero(void)
{
	unsigned int i;
	unsigned int value;
	unsigned int* addr;
	unsigned int len = 0x400;
	addr = (unsigned int *)(0x44000000 );
	memset(addr, 0xf3, len);
	for (i = 0; i < len/4; i++)
	{
	    addr = (unsigned int *)(0x44000000 + (i<<2));
	    value =  *addr;
	    if(value != 0xf3f3f3f3)
	    {
                dramc_debug("FPGA . index = 0x%x, data : 1~0x%x from addr 0x%x \n", i, value, (unsigned int)addr);    
		DDR_ASSERT();
            }
	}
}

#ifdef DDR_TEST_BYTE
void ddr_write_test_byte(unsigned int start_addr, unsigned int len)
{
    unsigned int t1;
    volatile unsigned int addr;
    unsigned char c1;
    volatile unsigned char value;
    dramc_debug("FPGA byte. write data : 1~0x%x from addr 0x%x \n",len, start_addr);    
    for(t1 = 0; t1 < len; t1++)    
    {    
		c1 = t1&0xff;
		value = c1;
		addr = (start_addr + (t1<<2));
		 *(unsigned char *)addr = value;
		 value = c1 + 1;
		 addr = (start_addr + (t1<<2) + 1);
		 *(unsigned char *)addr = value;	
		 value = c1 + 2;
		 addr = (start_addr + (t1<<2) + 2);
		 *(unsigned char *)addr = value;		 
		 value = c1 + 3;
		 addr = (start_addr + (t1<<2) + 3);
		 *(unsigned char *)addr = value;		 		 

#if 1		
		unsigned char cmpvalue; 
		c1 = t1&0xff;
	cmpvalue = c1;
        addr = (start_addr + (t1<<2));
        value = *(unsigned char *)addr;
        if(cmpvalue !=  value) 
		{
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)); 
			DDR_ASSERT();
		}
	cmpvalue = (c1 + 1)&0xff;
        addr = (start_addr + (t1<<2) + 1);
        value = *(unsigned char *)addr;
        if(cmpvalue !=  value) 
		{
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+1); 
			DDR_ASSERT();
		}
	cmpvalue = (c1 + 2)&0xff;
        addr = (start_addr + (t1<<2) + 2);
        value = *(unsigned char *)addr;
        if(cmpvalue !=  value) 
		{
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+2); 
			DDR_ASSERT();
		}
	cmpvalue = (c1 + 3)&0xff;
        addr = (start_addr + (t1<<2) + 3);
        value = *(unsigned char *)addr;
        if(cmpvalue !=  value) 
		{
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+3); 
			DDR_ASSERT();
		}
#endif		
	}
}
#endif

void ddr_write_test_word(unsigned int start_addr, unsigned int len)
{
    unsigned int t1;
    volatile unsigned int addr;
    dramc_debug("FPGA . write data : 1~0x%x from addr 0x%x \n",len, start_addr);    
    for(t1 = 0; t1 < len; t1++)    
    {    
	volatile unsigned int value;
	value = t1&0xff;
	value = value | (value << 8);
	value = value | (value << 16);
	addr = start_addr + MARGIN_OFF + (t1<<2);
        writel(value , addr);
    }
}
void test(unsigned int start_addr, unsigned int t1, unsigned char c1)
{
    volatile unsigned int addr;
    unsigned char cmpvalue;
    unsigned char value;
        addr = (start_addr + (t1<<2));
        value = *(unsigned char *)addr;
	cmpvalue = c1;
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned char *)(start_addr + (t1<<2)), start_addr + (t1<<2));
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2));
}
#ifdef DDR_TEST_BYTE
void ddr_read_test_byte(unsigned int start_addr, unsigned int len)
{
    unsigned int t1;
    volatile unsigned int addr;
    unsigned char c1;
    unsigned char cmpvalue;
    unsigned char value;
    dramc_debug("FPGA . read data : 1~0x%x from addr 0x%x \n",len, start_addr);    
    for(t1 = 0; t1 < len; t1++)    
    {    
        c1 = t1&0xff;

        addr = (start_addr + (t1<<2));
        value = *(unsigned char *)addr;
	cmpvalue = c1;
        if(cmpvalue !=  value)
        {
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned char *)(start_addr + (t1<<2)), start_addr + (t1<<2));
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2));
	    test(start_addr, t1, c1);
            DDR_ASSERT();
        }

        addr = (start_addr + (t1<<2) + 1);
        value = *(unsigned char *)addr;
        cmpvalue = (c1 + 1)&0xff;
        if(cmpvalue !=  value)
        {
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned char *)(start_addr + (t1<<2)+1), start_addr + (t1<<2)+1);
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+1);
        addr = (start_addr + (t1<<2) + 1);
        value = *(unsigned char *)addr;
        cmpvalue = (c1 + 1)&0xff;
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned char *)(start_addr + (t1<<2)+1), start_addr + (t1<<2)+1);
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+1);
            DDR_ASSERT();
        }

        addr = (start_addr + (t1<<2) + 2);
        value = *(volatile unsigned char *)addr;
        cmpvalue = (c1 + 2)&0xff;
        if(cmpvalue !=  value)
        {
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned int *)(start_addr + (t1<<2)+2), start_addr + (t1<<2)+2);
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+2);
            DDR_ASSERT();
        }

        addr = (start_addr + (t1<<2) + 3);
	value = *(volatile unsigned char *)addr;
        cmpvalue = (c1 + 3)&0xff;
        if(cmpvalue !=  value)
        {
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned int *)(start_addr + (t1<<2)+3), start_addr + (t1<<2)+3);
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+3);
        addr = (start_addr + (t1<<2) + 3);
	value = *(volatile unsigned char *)addr;
        cmpvalue = (c1 + 3)&0xff;
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned int *)(start_addr + (t1<<2)+3), start_addr + (t1<<2)+3);
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       cmpvalue, value, start_addr + (t1<<2)+3);
            DDR_ASSERT();
        }

    }
}
#endif

void ddr_read_test_word(unsigned int start_addr, unsigned int len)
{
    unsigned int t1;
    volatile unsigned int addr;
    volatile unsigned int value;
    volatile unsigned int cmpvalue;
    dramc_debug("FPGA . read data : 1~0x%x from addr 0x%x \n",len, start_addr);    
    for(t1 = 0; t1 < len; t1++)    
    {    
	cmpvalue = t1&0xff;
	cmpvalue = cmpvalue | (cmpvalue << 8);
	cmpvalue = cmpvalue | (cmpvalue << 16);
	addr = start_addr + MARGIN_OFF + (t1<<2);
	value = readl(start_addr + MARGIN_OFF + (t1<<2));
        if(value != cmpvalue)
		{
            dramc_debug("FPGA . cmp original data 0x%x and  get value 0x%x @ addr 0x %x fail! the result is err!\n",
                       t1, *(volatile unsigned int *)(start_addr + (t1<<2)), start_addr + (t1<<2)); 
			DDR_ASSERT();
		}
    }
}

void ddr_read_write_area_test(unsigned int start, unsigned len, unsigned int offset, unsigned int part_size)
{
	int i = 0;
#ifdef DDR_TEST_BYTE
	for (i = 0; i <= 7; i++)
	{
		ddr_write_test_byte(start + i*part_size + offset, len/4);
	}
	for (i = 0; i <= 7; i++)
	{
		ddr_read_test_byte(start + i*part_size + offset, len/4);
	}
#endif
	for (i = 0; i <= 7; i++)
	{
		ddr_write_test_word(start + i*part_size + offset, len/4);
	}
	for (i = 0; i <= 7; i++)
	{
		ddr_read_test_word(start + i*part_size + offset, len/4);
	}

}

void ddr_read_write_border_test(unsigned int start, unsigned len, unsigned int part_size)
{
	int i = 0;
	if (len > part_size)
	{
    	dramc_debug("FPGA . dram area test :pls set right para, len=0x%x, part_size=0x%x.\n", len, part_size);
	    return;
	}

#ifdef DDR_TEST_BYTE
	for (i = 0; i <= 7; i++)
	{
		ddr_write_test_byte(start + i*part_size + part_size -len, len/4);
	}
	for (i = 0; i <= 7; i++)
	{
		ddr_read_test_byte(start + i*part_size + part_size - len, len/4);
	}
#endif
	for (i = 0; i <= 7; i++)
	{
		ddr_write_test_word(start + i*part_size + part_size -len, len/4);
	}
	for (i = 0; i <= 7; i++)
	{
		ddr_read_test_word(start + i*part_size + part_size -len, len/4);
	}
}

void ddr_read_write_test(unsigned int start, unsigned int part_size, unsigned int test_rate)
{
	unsigned int offset = 0; 
//	unsigned int part_size  = 0x4000000;
	unsigned int part_tested_size = part_size>>test_rate;
	unsigned int len;
	if (test_rate == 0 || test_rate>(16))
	{
    	    dramc_debug("FPGA . dram area test :pls set right para, test_rate=0x%x.\n", test_rate);
	    return;
	}
#ifdef CONFIG_COMPILE_RTL
	len = 0x400;
#else
	len = 0x20000;
#endif	
	//testchar();
	//test_zero();
	ddr_read_write_border_test(start, len, part_size);
	for (offset = 0; offset  < part_tested_size; offset+= len)
	{
    	dramc_debug("FPGA . dram area test : start=0x%x, len=0x%x, offset=0x%x, part_sz=0x%x, part_tst_sz=0x%x.\n", 
			start, len ,offset, part_size, part_tested_size);
		ddr_read_write_area_test(start, len, offset, part_size);
	}
}
/*
 * division designed by terry using number shift and subtraction, to improve efficiency
 * and in case that the arm-gcc compiler don't support division
 * @v1: dividend
 * @v2: divisor
 *
 * return quotient
 */
uint32_t division(uint32_t v1, uint32_t v2)
{
        int i;
        uint32_t ret = 0;
        uint32_t dividend[2] = { v1, 0 };

        for(i = 0; i < 32; i++) {
                if(dividend[0] & (1 << 31))
                        break;
                else
                        dividend[0] <<= 1;
        }
        for(; i < 32; i++) {
                dividend[1] = (dividend[1] << 1) + (dividend[0] >> 31);
                dividend[0] <<= 1;
                ret <<= 1;
                if(dividend[1] >= v2) {
                        dividend[1] -= v2;
                        ret++;
                }
        }

        return ret;

}

/* describe all the infomation of drams that supported by infotm, we set their default valaues first */
static struct infotm_dram_info dram = {
        .type = DDR3,
        .cl = 6,
        .width = 8,
        .rtt = 0x4,
        .freq = 444,
        .rank_sel = 1,
        .reduce_flag = 0,
        .addr_map_flag = 0,     /* 1: screen res high    0: screen res low */
        .timing = {
                .trfc_d = 0,
        //.tras    = 0,    /*defule set in fun: dramc_get_items*/
        },
};

/* describe whether it is a wake up process */
int dramc_set_para(void)
{
    uint32_t tmp;
#if (MEMC_DRAM_DATA_WIDTH == 16)
    uint32_t rank[][5] = {
        /* size 128MB 256MB 512MB, size 1GB, size 2GB */
        {1, 1, 1, 1, 1 },        /* total width 16bit */
        {3, 3, 3, 3, 3 },        /* total width 32bit */    //1G 32bit width need verify?
        {3, 3, 3, 3, 3 }         /* total width 64bit */  // 2 chipselect *32 equal to 64 bit 
     };
#else
    uint32_t rank[][5] = {
        /* size 128MB 256MB 512MB, size 1GB, size 2GB */
        {1, 1, 1, 1, 1 },        /* total width 16bit */
        {1, 1, 1, 1, 1 },        /* total width 32bit */    //1G 32bit width need verify?
        {3, 3, 3, 3, 3 }         /* total width 64bit */  // 2 chipselect *32 equal to 64 bit 
     };
#endif

    /* type : DDR3, LPDDR2S2, LPDDR2S4  add DDR2*/
    //dram.type = LPDDR2S4;
    dram.type = DDR3;

    /* freq */
    dram.freq = 400;



    /* cl : 2 ~ 8 */
    dram.cl = 6;

    /* count: 2, 4, 8 */
#ifdef    CONFIG_COMPILE_FPGA
    dram.count = 2;
#else
    dram.count = 2;
#endif

//#ifdef CONFIG_COMPILE_DDR2
    dram.type = DDR2;
    dram.count = 1;
    dram.freq = 400;
//#endif

#ifdef DDR_533MHZ    
    dram.freq = 533;
	dram.cl = 7;
#endif
    dram.count = ffs(dram.count) - 1;                       /* we set the registers using its ffs value */

    /* width: 8, 16, 32 */
    dram.width = 16;
    dram.width = ffs(dram.width) - 3;

    if(MEMC_DRAM_DATA_WIDTH == 16)
    {
        if((dram.count + dram.width > 3) || (dram.count + dram.width < 2)) {               /* the total width must in the range of 16bit to 64bit */
            dramc_debug("the total dram width is not between 16bit ~ 64bit, dram configuration error!\n");
            return 1;
        }
    }
    else
    {
        if((dram.count + dram.width > 4) || (dram.count + dram.width < 2)) {               /* the total width must in the range of 16bit to 64bit */
            dramc_debug("the total dram width is not between 16bit ~ 64bit, dram configuration error!\n");
            return 1;
        }
    }

    /* capacity: 8MB, 16MB, 32MB, 64MB, 128MB, 256MB, 512MB, 1024MB */
#ifdef    CONFIG_COMPILE_FPGA
    dram.capacity = 1024;
#else
    dram.capacity = 64;
#endif

    dram.capacity = ffs(dram.capacity) - 4;

    /* rtt: 0x4, 0x40, 0x44 */
    if(dram.type == DDR3 ) {
        tmp = 4;
        dram.rtt = ((tmp == 0) ? 0x4 : ((tmp == 1) ? 0x40 : 0x44));
    }
    else if (dram.type == DDR2)
    {
        dram.rtt = 0x04; //RTT 75Ohm
    }

    /* driver, for ddr3: 0x0, 0x2; for lpddr2: 1 ~ 7 */
    dram.driver     = ((dram.type == DDR3 || dram.type == DDR2) ? DRIVER_DIV_6 : DS_40_OHM);     /* set default driver first, ddr3 and lpddr2 respectively */

    /*memory.driver DDR3:  "6", "7"  LPDDR: "34.3", "40", "48", "60", "68.6", "resv", "80", "120"*/
    if(dram.type == DDR3)
        tmp = 6;
    else
        tmp = 0; 
    if(dram.type == DDR3 || dram.type == DDR2)
        dram.driver = ((tmp == 0) ? 0x0 : 0x2);
    else
        dram.driver = tmp + 1;

    /* dram timing trfc_d and tras */
    dram.timing.trfc_d = 64;
    if(dram.type == DDR3)
        dram.timing.tras = ((dram.freq < 410) ? 15 : 20);
    else if (dram.type == DDR2)
    {
        dram.timing.tras = division(45 * dram.freq, 1000);  
    }
    else
        dram.timing.tras = division(42 * dram.freq, 1000);              /* set default tras first, if tras is not found in items, use this default value */

    /* dram addr map, UMCTL2 only support 0 mode: bank.row.column*/
    dram.addr_map_flag = 0;

    /* reduce_flag, burst_len, rank_sel and size, they are caculated by other parameters, not read from items.itm */
    dram.reduce_flag = ((1 << (dram.count + dram.width + 2)) < MEMC_DRAM_DATA_WIDTH);
    //dram.burst_len = ((dram.type == DDR3 || dram.type == DDR2) ? BURST_8 : BURST_4);
    dram.burst_len =  BURST_8;
    tmp = dram.count + dram.capacity;
    if (tmp < 6)
        tmp = 6;
    dram.rank_sel = rank[dram.count + dram.width - 2 ][tmp - 6];
    dram.size = 1 << (dram.count + dram.capacity + 3);
    printf("count width capacity: %d, %d %d, size 0x%x\n", dram.count, dram.width, dram.capacity, dram.size);

    return 0;
}

int dramc_set_addr(void)
{
    uint32_t lpddr2s2_row_table[] = { 12, 12, 13, 13, 14, 15, 14, 15 };
    uint32_t lpddr2s4_row_table[] = { 12, 12, 13, 13, 13, 14, 14, 15 };

    if(dram.type == DDR3 || dram.type == DDR2) {
        if(((dram.width != IO_WIDTH8) && (dram.width != IO_WIDTH16)) || (dram.capacity < DRAM_64MB))
            return 1;
        if(dram.capacity == DRAM_1GB&& dram.width == IO_WIDTH8) {        //if has, need redefined, col 11 = ?
            dram.bank = 3;
            dram.col = 11;
            dram.row = 16;          // the max number of row line is 16
        }
        else if(dram.type == DDR2 && dram.capacity == DRAM_64MB)
        {
            dram.bank = 2;
            dram.col = 10;
            dram.row = 24 +dram.capacity - dram.width - dram.bank - dram.col;        
        }
        else {
            dram.bank = 3;
            dram.col = 10;
            dram.row = 24 + dram.capacity - dram.width - dram.bank - dram.col;
        }
    } else if(dram.type == LPDDR2S2) {
        dram.bank = ((dram.capacity < DRAM_512MB) ? 2 : 3);
        dram.row = lpddr2s2_row_table[dram.capacity - DRAM_8MB];
        dram.col = 24 + dram.capacity - dram.width - dram.bank - dram.row;
    } else if(dram.type == LPDDR2S4) {
        dram.bank = ((dram.capacity < DRAM_128MB) ? 2 : 3);
        dram.row = lpddr2s4_row_table[dram.capacity - DRAM_8MB];
        dram.col = 24 + dram.capacity - dram.width - dram.bank - dram.row;
    }

    /* apollo ddr configuring
     * ddr ce2 & A15
     * start is ce2, if ddr capacity use A15, change this configure LPDDR2 512*16 need row 16
     */
    if (dram.row == 16)
        writel(0<<7, EMIF_SYSM_ADDR_CE2_A15);

    printf("rcb: %d %d %d\n", dram.row, dram.col, dram.bank);
    return 0;
}

static const struct infotm_freq_2_param freq_2_param[] =
{
    { 600, 0x0031 }, { 576, 0x002f }, { 552, 0x002d }, { 528, 0x002b }, { 504, 0x0029 }, { 468, 0x104d },
    { 444, 0x1049 }, { 420, 0x1045 }, { 396, 0x1041 }, { 372, 0x103d }, { 348, 0x1039 }, { 330, 0x1036 },
    { 312, 0x1033 }, { 288, 0x102f }, { 264, 0x102b },
};

void dramc_set_freqency_phy(uint32_t pll_p, uint32_t phy_div)
{
    //pll_set_clock("vpll", (pll_p & 0xffff) * M_HZ * 2);  //ddr freq: 533, but vpll need 533*2?
#ifdef DDR_533MHZ
	#ifdef CONFIG_OSC_24M
    __pll_set_clock("vpll", 0x10d6);  //ddr freq: 533, but vpll need 533*2 ---->VPLL change to 768MHZ, DDR 384MHZ
	#else
    __pll_set_clock("vpll", 0x1056);  //ddr freq: 533, but vpll need 533*2 ---->VPLL change to 768MHZ, DDR 384MHZ
	#endif
#else
	#ifdef CONFIG_OSC_24M
    __pll_set_clock("vpll", 0x10bf);  //ddr freq: 533, but vpll need 533*2 ---->VPLL change to 768MHZ, DDR 384MHZ
	#else
    __pll_set_clock("vpll", 0x103f);  //ddr freq: 533, but vpll need 533*2 ---->VPLL change to 768MHZ, DDR 384MHZ
	#endif
#endif
    module_set_clock("dram", "vpll", pll_p*M_HZ, 0);
    module_set_clock("apb", "vpll", (pll_p & 0xffff) * M_HZ / 4, 0);    //apb is vpll 8 div, 96MHZ
}

void dramc_set_frequency(void)
{
    uint32_t i;

    for(i = 0; i < FR_NUM; i++) {
        if(dram.freq >= freq_2_param[i].freq) {
            dramc_set_freqency_phy(freq_2_param[i].freq, 1);
            break;
        }
    }

    /* other dram freqencys which are not in freq_val table */
    if(i == FR_NUM) {
        if(dram.freq >= 200)
            dramc_set_freqency_phy(0x1041, 3);
        else if(dram.freq >= 150)
            dramc_set_freqency_phy(0x1031, 3);
        else
            dramc_set_freqency_phy(0x1031, 3);
    }
    dramc_debug("freq: %d, param 0x%x\n", freq_2_param[i].freq, freq_2_param[i].param);
}

void dramc_set_timing(void)
{
    struct infotm_dram_timing *timing = &dram.timing;
    
    /* capacity: 8MB, 16MB, 32MB, 64MB, 128MB, 256MB, 512MB, 1024MB */
    const uint32_t trefi_param[][8] = {
        { 78, 78, 78, 78, 78, 78, 78, 78 },      /* ddr3, 78 means 7.8us */
        { 156, 156, 78, 78, 78, 39, 39, 39},    /* lpddr2S2, lpddr2S4 */
    };
    //unit ps
    const uint32_t trfc_param[][8] = {
        { 90000, 90000, 90000, 90000, 110000, 160000, 300000, 380000 },  /* ddr3 */
        { 90000, 90000, 90000, 90000, 130000, 130000, 130000, 210000 }, /* lpddr2S2, lpddr2S4 */
        { 75000, 75000, 75000, 105000, 127500, 195000, 327500, 327500},  /* ddr2 */
    };
    const uint32_t lpddr2_timing[] = { 3, 5, 6, 10, 12, 13 }; /* cl 3 ~ 8 */


    /* trefi set */
    timing->trefi = division(trefi_param[dram.type != DDR3 && dram.type != DDR2][dram.capacity]* dram.freq, 32 * 10);

    if (dram.type == DDR2)
    {
        if(dram.freq > 410)
        {
            timing->trrd = 6;
            timing->tfaw = 24;
            timing->faw_eff = (1 << 0) | (3 << 16); /* set tfaw = 5 * trrd - 3 */
        }
        else
        {
            timing->trrd = 4;
            timing->tfaw = 18;
            timing->faw_eff = 0;    /* set tfaw = 4 * trrd */
        }
    }
    else{
        /* trrd, tfaw, faw_eff */
        if((dram.width == IO_WIDTH16) && (dram.freq > 410)) {
            timing->trrd = 6;
            timing->tfaw = 27;
            timing->faw_eff = (1 << 0) | (3 << 16); /* set tfaw = 5 * trrd - 3 */
        } else if ((dram.width == IO_WIDTH16) || (dram.freq > 410)) {
            timing->trrd = 4;
            timing->tfaw = 20;
            timing->faw_eff = 1;    /* set tfaw = 5 * trrd */
        } else {
            timing->trrd = 4;
            timing->tfaw = 16;
            timing->faw_eff = 0;    /* set tfaw = 4 * trrd */
        }
    }

    /* trc */
    timing->trc = timing->tras + dram.cl;

    /* twr 15ns */
    if(dram.freq <= 350)
        timing->twr = 5;
    else if (dram.freq <= 410)
        timing->twr = 6;
    else if (dram.freq <= 475)
        timing->twr = 7;
    else
        timing->twr = 8;

    /* tcwl */
    if(dram.type == DDR3)
        timing->tcwl = (dram.cl < 7) ? 5 : 6;
    else if(dram.type == DDR2)
    {
        timing->tcwl = dram.cl -1;
    }
    else{
        timing->tcwl = dram.cl / 2;    //for LPDDR2
        if (dram.cl == 7)
            timing->tcwl = 4;
    }

    if (dram.type == DDR2)
    {
        /* trfc, trfab(ns)/tck/MEM_FREQ_RATIO */
        timing->trfc = division(trfc_param[2][dram.capacity] * dram.freq, 1000000);
    }
    else
    {
        /* trfc, trfab(ns)/tck/MEM_FREQ_RATIO */
        timing->trfc = division(trfc_param[dram.type != DDR3][dram.capacity] * dram.freq, 1000000);
    }

    /* trfc_d, trfcd, trp */
    timing->trfc_d = timing->trfc - timing->trfc_d;
    timing->trcd = (dram.type == DDR3 || dram.type == DDR2) ? dram.cl : (lpddr2_timing[dram.cl - 3]);
    timing->trp = timing->trcd;
}

/*before memory init need DRAM controler & DLL reset*/
void emif_module_reset(void)
{
    uint32_t timing;
    uint32_t lock_pll;

    timing = 0;
    lock_pll = 0x4;    //Impedance Calibration Done Flag

    /*RTC user GP0 output mode*/
    if(!dramc_wake_up_flag) {        //RTL no wakeup
        writel(readl(SYS_RTC_GPMODE) & ~0x1,    0x2d009c4c);
        writel(0x1,      0x2d009c7c);
    } else{
        readl(RTC_INFO8);
        dramc_debug("dram wake up  \n");
    }

    /*emif bus reset*/
    /*bus reset need bufore core, or ddr can not write*/
    writel(0xff, EMIF_SYSM_ADDR_BUS_AND_PHY_PLL_CLK);//enable dram axi port 0-4 axi bus clk, pll phy clk
    writel(0xff, EMIF_SYSM_ADDR_APB_AND_PHY_CLK);//enable dram   phy ctl_clk ctl_hdr_clk
    writel(0xff, EMIF_SYSM_ADDR_BUS_RES); //dram axi port 0-4 axi bus assert reset 
    //writel(0x7, EMIF_SYSM_ADDR_CORE_RES);   //asser  0:ctl_hdr_rst_n, 1:apb_ reset, 2:  ctl_rstn
    writel(0xff, EMIF_SYSM_ADDR_CORE_RES);   //asser  0:ctl_hdr_rst_n, 1:apb_ reset, 2:  ctl_rstn , ivan , new
#ifndef CONFIG_COMPILE_RTL
    udelay(0x10);
#endif
    int i;
    for(i = 0; i<0x100; i++) ;
    //deassert  1:apb_ reset
    //0:ctl_hdr_rst_n must be deasserted befor dll lock and impendance calibration
    //2: ctl_rst_n must be deasserted befor dll lock  and impendance calibration
    writel(0x5, EMIF_SYSM_ADDR_CORE_RES);
    //writel(0x0, EMIF_SYSM_ADDR_BUS_RES);//dram axi port 0-4 axi bus deassert reset , should do this after ddr_phy_set()?
#ifndef CONFIG_COMPILE_G2_PHY
    /*DLL reset*/
    writel(0x0, ADDR_PHY_ACDLLCR);

    for(i = 0; i<0x100; i++) ;

    writel(0x40000000, ADDR_PHY_ACDLLCR);    // DLL soft reset

    /*wait for pll lock*/
    while((readl(ADDR_PHY_PGSR) & lock_pll) != lock_pll)

    for(i = 0; i<0x100; i++) ;

#ifdef CONFIG_COMPILE_FPGA
    if (dram.type == DDR2 || dram.type == DDR3)
        //timing = 0x22222222;    //for x9 old fpga
        timing = 0x11111111;    //for x9 corona new fpga
    else if (dram.type == LPDDR3)        //LPDDR2S2 ??
        timing = 0x33333333;
#endif

    writel(timing, ADDR_PHY_DX0DQTR);
    writel(timing, ADDR_PHY_DX1DQTR);
    writel(timing, ADDR_PHY_DX2DQTR);
    writel(timing, ADDR_PHY_DX3DQTR);
#endif


}

void DWC_umctl2_default_reg_init(void)
{
    // to be tested
    writel(0x00003030, ADDR_UMCTL2_MRCTRL0);
    writel(0x00004daf, ADDR_UMCTL2_MRCTRL1); //bit[17:0]--mr_data
#if 1
    writel(0x00000001, ADDR_UMCTL2_PCTRL_0);   
    writel(0x00000001, ADDR_UMCTL2_PCTRL_1);
    writel(0x00000001, ADDR_UMCTL2_PCTRL_2);
    writel(0x00000001, ADDR_UMCTL2_PCTRL_3);
    writel(0x00000001, ADDR_UMCTL2_PCTRL_4);
#endif
    writel(0x00000020, ADDR_UMCTL2_DERATEEN); 
    writel(0xa1ca5c09, ADDR_UMCTL2_DERATEINT);
    writel(0x00810001, ADDR_UMCTL2_HWLPCTL);   
    writel(0x00270203, ADDR_UMCTL2_PWRTMG); //bit[4:0]--powerdown_to_x32(2),bit[15:8]--t_dpt_x4096('h32),bit[23:16]--selfref_to_x32('he)
    writel(0x00202010, ADDR_UMCTL2_RFSHCTL0); //bit[2]--per_bank_refresh(0),bit[8:4]--refresh_burst(7),bit[16:12]--refresh_to_x32('h1c),bit[23:20]--refresh_margin(2)
    writel(0x00200009, ADDR_UMCTL2_RFSHCTL1);
    writel(0x00000000, ADDR_UMCTL2_RFSHCTL3); //bit[0]--dis_auto_refresh(0),bit[1]--refresh_updata_level(0) 
    writel(0x00000000, ADDR_UMCTL2_CRCPARCTL0);
    writel(0x00000000, ADDR_UMCTL2_DIMMCTL); //bit[0]--dimm_stagger_cs_en,bit[1]--dimm_addr_mirr_en
    writel(0x000007ff, ADDR_UMCTL2_PERFVPR1); //bit[10:0]--vpr_timeout_range  //not use 
    writel(0x000007ff, ADDR_UMCTL2_PERFVPW1); //bit[10:0]--vpw_timeout_range  //not use
#if 1
    writel(0x00000010, ADDR_UMCTL2_PCCFG); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGR_0); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGW_0); //bit[]--,bit[]--,bit[]--
    writel(0x02100053, ADDR_UMCTL2_PCFGQOS0_0); //bit[]--,bit[]--,bit[]--
    writel(0x00ff00ff, ADDR_UMCTL2_PCFGQOS1_0); //bit[]--,bit[]--,bit[]--
    writel(0x00100005, ADDR_UMCTL2_PCFGWQOS0_0); //bit[]--,bit[]--,bit[]--
    writel(0x000000ff, ADDR_UMCTL2_PCFGWQOS1_0); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGR_1); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGW_1); //bit[]--,bit[]--,bit[]--d
    writel(0x02100053, ADDR_UMCTL2_PCFGQOS0_1); //bit[]--,bit[]--,bit[]--
    writel(0x00ff00ff, ADDR_UMCTL2_PCFGQOS1_1); //bit[]--,bit[]--,bit[]--
    writel(0x00100005, ADDR_UMCTL2_PCFGWQOS0_1); //bit[]--,bit[]--,bit[]--
    writel(0x000000ff, ADDR_UMCTL2_PCFGWQOS1_1); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGR_2); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGW_2); //bit[]--,bit[]--,bit[]--
    writel(0x02100053, ADDR_UMCTL2_PCFGQOS0_2); //bit[]--,bit[]--,bit[]--
    writel(0x00ff00ff, ADDR_UMCTL2_PCFGQOS1_2); //bit[]--,bit[]--,bit[]--
    writel(0x00100005, ADDR_UMCTL2_PCFGWQOS0_2); //bit[]--,bit[]--,bit[]--
    writel(0x000000ff, ADDR_UMCTL2_PCFGWQOS1_2); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGR_3); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGW_3); //bit[]--,bit[]--,bit[]--
    writel(0x02100053, ADDR_UMCTL2_PCFGQOS0_3); //bit[]--,bit[]--,bit[]--
    writel(0x00ff00ff, ADDR_UMCTL2_PCFGQOS1_3); //bit[]--,bit[]--,bit[]--
    writel(0x00100005, ADDR_UMCTL2_PCFGWQOS0_3); //bit[]--,bit[]--,bit[]--
    writel(0x000000ff, ADDR_UMCTL2_PCFGWQOS1_3); //bit[]--,bit[]--,bit[]--
    writel(0x00004080, ADDR_UMCTL2_PCFGR_4);
    writel(0x00004080, ADDR_UMCTL2_PCFGW_4);
    writel(0x02100053, ADDR_UMCTL2_PCFGQOS0_4);
    writel(0x00ff00ff, ADDR_UMCTL2_PCFGQOS1_4);
    writel(0x00100005, ADDR_UMCTL2_PCFGWQOS0_4);
    writel(0x000000ff, ADDR_UMCTL2_PCFGWQOS1_4);
#endif
}

/**
 * Program the DWC_ddr_umctl2 registers
 * Ensure that DFIMISC.dfi_init_complete_en is set to 0
 */
void DWC_umctl2_reg(void)
{
    uint32_t tmp = 0;
    struct infotm_dram_timing *timing = &dram.timing;
    uint32_t cl = dram.cl;

    DWC_umctl2_default_reg_init();

    writel(0x0, ADDR_UMCTL2_DFIMISC);// disable dif_init_complete_en

    /*cfg MSTR reg, rank ,bank ,burst */
#if MEMC_2T_MODE
    tmp = (((dram.rank_sel & 0x3) << 24) | ((dram.burst_len & 0xf) << 16) | ((dram.reduce_flag & 0x3) << 12) | (1 << 10)
        | ((dram.type == LPDDR3) << 3) | ((dram.type == LPDDR2S4 || dram.type ==LPDDR2S2) << 2) |((dram.type == DDR3) << 0));
    writel(tmp, ADDR_UMCTL2_MSTR);  //0x3040001
#else
    tmp = (((dram.rank_sel & 0x3) << 24) | ((dram.burst_len & 0xf) << 16) | ((dram.reduce_flag & 0x3) << 12)
        | ((dram.type == LPDDR3) << 3) | ((dram.type == LPDDR2S4 || dram.type ==LPDDR2S2) << 2) |((dram.type == DDR3) << 0));
    writel(tmp, ADDR_UMCTL2_MSTR);    //0x3040001
#endif

    tmp =(((timing->trefi & 0xfff) << 16) | (timing->trfc & 0xff));    //0x610040 alin define 0x00620070
#ifdef    CONFIG_COMPILE_FPGA
    writel(0x00080030/MEMC_FREQ_RATIO, ADDR_UMCTL2_RFSHTMG);
#else
    writel(tmp/MEMC_FREQ_RATIO, ADDR_UMCTL2_RFSHTMG);
#endif

#ifdef CONFIG_COMPILE_RTL
        //writel((dram.type == DDR3) ? 0x00010001/MEMC_FREQ_RATIO : 0x00010001/MEMC_FREQ_RATIO, ADDR_UMCTL2_INIT0); /* time period(us) during memory power up, DDR3 at least 500us*/
        // round up to 1  //to be test
        writel((dram.type == DDR3) ? 0x000200c4 : 0x000200c4, ADDR_UMCTL2_INIT0); /* time period(us) during memory power up, DDR3 at least 500us*/
#else
        writel((dram.type == DDR3) ? ((MEMC_FREQ_RATIO==1)?0x00010150:0x000100a8) : ((MEMC_FREQ_RATIO==1)?0x000100a0:0x00010050), ADDR_UMCTL2_INIT0); /* time period(us) during memory power up, DDR3 at least 500us*/
#endif

#ifdef CONFIG_COMPILE_RTL
        writel((dram.type == DDR3) ? 0x00020101 : 0x00010101, ADDR_UMCTL2_INIT1);         /* time period(us) during ddr3 power up, at least 200us */
        //for test 
#else
        writel((dram.type == DDR3) ? 0x00f0010f : 0x01000a28, ADDR_UMCTL2_INIT1);         /* time period(us) during ddr3 power up, at least 200us */
#endif

    if(dram.type != DDR3)
        writel(0xc06, ADDR_UMCTL2_INIT2);

    if(dram.type == DDR3){
        tmp = ((cl - 4) << (4+16)) | ((timing->twr - 4) << (9+16)) | (1 << (8+16)) | (dram.rtt & 0xff) | dram.driver;    /*MR0 & MR1*/ //0x4200004, alin define 0x5200004
        writel(tmp, ADDR_UMCTL2_INIT3);
        tmp = ((timing->tcwl - 5) << (3+16));
        writel(tmp, ADDR_UMCTL2_INIT4);                      /*MR2 & MR3*/
    }
    else if (dram.type == DDR2)
    {
        tmp =  (3<<(16)) | (cl<<(4+16)) |((timing->twr-1)<<(9+16)) | (1<<(8+16)) |  (dram.rtt & 0xff) | dram.driver;
        writel(tmp, ADDR_UMCTL2_INIT3);
        tmp = 0;
        writel(tmp, ADDR_UMCTL2_INIT4);
    }
    else{        //LPDDR2 user
        tmp = ((timing->twr - 2) << (5+16)) | 0x3<<16 | (cl -2);    //BL=8 fixed
        writel(tmp, ADDR_UMCTL2_INIT3);
        tmp = (dram.driver << 16);
        writel(tmp, ADDR_UMCTL2_INIT4);                      /*MR2 & MR3*/
    }

    //ddr3 zq initial calibration need 512 clock,17*32
    tmp = 0x11 << 16 | (dram.type == DDR3 ? 1 : division((dram.freq * 10 +1023), 1024));        //tmp 0x100001, alin define 0x00110001
    writel(tmp, ADDR_UMCTL2_INIT5);
    writel((MEMC_FREQ_RATIO == 2) ? 0x000366 : 0x00066b, ADDR_UMCTL2_RANKCTL);

    /*need use cl*/
    tmp = (timing->tcwl + 4 + division(15 * dram.freq, 1000) + MEMC_FREQ_RATIO - 1) << 24
        | (timing->tfaw) << 16 | (timing->tras + 10)<< 8 
        | (timing->tras + MEMC_FREQ_RATIO - 1);    //0xf10190f alin 0x0f101a0f
    writel(tmp/MEMC_FREQ_RATIO, ADDR_UMCTL2_DRAMTMG0);

    if (dram.type == DDR2 && dram.freq > 410)
    {
        tmp = 0x8 << 16 | 0x6 << 8 | (timing->trc + MEMC_FREQ_RATIO - 1);    //8040a alin 0x00080416 , need >>1?
    }
    else
    {
        tmp = 0x8 << 16 | 0x4 << 8 | (timing->trc + MEMC_FREQ_RATIO - 1);    //8040a alin 0x00080416 , need >>1?
    }
    writel(tmp/MEMC_FREQ_RATIO, ADDR_UMCTL2_DRAMTMG1);

    tmp = timing->tcwl << 24 | cl << 16 | (cl + 6 -timing->tcwl + MEMC_FREQ_RATIO -1 + ((dram.type == DDR3 || dram.type == DDR2) ? 0 : 3)) << 8 | (timing->tcwl + 4 + 4);    //set twrt cl?=rl wl 0x506070d alin 0x0506070d
    writel(tmp/MEMC_FREQ_RATIO, ADDR_UMCTL2_DRAMTMG2);

    tmp = (dram.type == DDR3 ? 0:5) << 20 | 0x4/MEMC_FREQ_RATIO << 12 | (dram.type == DDR3 ? (0xd+MEMC_FREQ_RATIO-1)/MEMC_FREQ_RATIO : 0);    //set tmdr tmod 0x400d alin 0x04010, round up
    writel(tmp,    ADDR_UMCTL2_DRAMTMG3);

    tmp = timing->trcd << 24 | 0x4 << 16 | timing->trrd << 8 | timing->trp;    //t_rcd, t_ccd, t_rrd, t_rp 0x6040406 alin 0x06040406
    writel(tmp/MEMC_FREQ_RATIO + (MEMC_FREQ_RATIO == 2 ? 1 : 0), ADDR_UMCTL2_DRAMTMG4);

    if (dram.type == DDR3) {
        //0x5050403 alin 0x5040403 ,tcksrx 24:27, tcksre 16:19, tckesr 8:13, t_cke0:4
        tmp = (MEMC_FREQ_RATIO == 2) ? 
              (3 << 24 | ((division(10 * dram.freq, 1000)+1)>>2)  << 16 |  0x2 << 8 | 0x2):
              (5 << 24 | division(10 * dram.freq, 1000)  << 16 |  0x4 << 8 | 0x3);    //0x5050403 alin 0x5040403
    }
    else if (dram.type == DDR2) {
        tmp = (MEMC_FREQ_RATIO == 2) ? 0x1010202: 0x2020303;
    }
    else {
        tmp = (MEMC_FREQ_RATIO == 2) ? 0x1010302: 0x2020503;
    }
    writel(tmp,  ADDR_UMCTL2_DRAMTMG5);

    writel((dram.type == DDR3) ? 0:((MEMC_FREQ_RATIO==1)?0x2020005:0x01010003),  ADDR_UMCTL2_DRAMTMG6);
    writel((dram.type == DDR3) ? 0:202/MEMC_FREQ_RATIO,     ADDR_UMCTL2_DRAMTMG7);//tck_pde 8:11, tck_pdx 0:3
    writel((MEMC_FREQ_RATIO==1) ? 0x06061004: 0x03030802, ADDR_UMCTL2_DRAMTMG8);
    writel((dram.type == DDR3) ? (MEMC_FREQ_RATIO == 2 ? 0x1000020 : 0x1000040) : (MEMC_FREQ_RATIO == 2 ? 0x403c000f : 0x4078001E),     ADDR_UMCTL2_ZQCTL0);
    writel((dram.type == DDR3) ? (MEMC_FREQ_RATIO == 2 ? 0x1000100 : 0x2000100) : (MEMC_FREQ_RATIO == 2 ? 0x0900070: 0x1100070),     ADDR_UMCTL2_ZQCTL1);

    if(MEMC_FREQ_RATIO == 2)
    {
        tmp = 0x02000000
            |(((cl - 2 - (cl%2)) >> 1 ) << 16)  //dfi_rddata_en
            | (0 << 8)                          //dfi_tphy_wrdata
            | ((timing->tcwl - 2 +  (timing->tcwl%2) + ((dram.type == DDR3||dram.type == DDR2) ? 0:1))>>1 );
        writel(tmp,     ADDR_UMCTL2_DFITMG0);
    }
    else
    {
        tmp = 0x02000000 | (cl - 2) << 16 | (timing->tcwl - 1 + ((dram.type == DDR3||dram.type == DDR2) ? 0:1));    //0x2040104 alin 0x02040104, need test, ddr3: cwl -1,lpddr2: cwl
        writel(tmp,     ADDR_UMCTL2_DFITMG0);    
    }
    writel(0x30202,     ADDR_UMCTL2_DFITMG1);//t_wrdata_delay = 1.75 hdr clock + 1.75 dram clk = 2.625 hdr clk = 3

    // to be tested
    //writel(0x02020002, ADDR_UMCTL2_DFITMG0);
    //writel(0x1100c202, ADDR_UMCTL2_DFITMG1);
    writel((dram.type == DDR3 || dram.type == DDR2 ) ? 0x07012000 : 0x07C10021,     ADDR_UMCTL2_DFILPCFG0);

	//ddr_16bits
	writel(0x60800020, 	ADDR_UMCTL2_ZQCTL0);
	writel(0x00000170, 	ADDR_UMCTL2_ZQCTL1);
	writel(0x00000000, 	ADDR_UMCTL2_ZQCTL2);

	//writel(0x02030102,  ADDR_UMCTL2_DFITMG0);
	//writel(0x00030203,  ADDR_UMCTL2_DFITMG1);
    writel((dram.type == DDR3) ? 0x07012000 : 0x07C10021,     ADDR_UMCTL2_DFILPCFG0);
    writel(0x40003,     ADDR_UMCTL2_DFIUPD0);
    writel(0x00c300f0,    ADDR_UMCTL2_DFIUPD1);
    //writel(0x866c006c,     ADDR_UMCTL2_DFIUPD2); 
    
    writel(0,     ADDR_UMCTL2_DFIUPD2);// to be tested

    if(dram.col == 11 && dram.type == LPDDR2S4){
        /*addr map(row14, bank8, col11)    ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        //v2.4 cs0 = base 6 + 14 +7 + 1= hif_cmd_addr[28], reduced [27]
        writel((0x1f00 | (dram.row + (!dram.reduce_flag ? 0x8 : 0x7))), ADDR_UMCTL2_ADDRMAP0);    //rank defined
        
        //lpddr2/lpddr3 full mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[11:13] base2-4, program 9  
        //lpddr2/lpddr3 half mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[10:12]base2-4, program 8 
        writel(0x080808 + (!dram.reduce_flag ? 0x010101:0),     ADDR_UMCTL2_ADDRMAP1);
        
        if(!dram.reduce_flag){
            //lpddr2/lpddr3 full mode umctl v2.4 ,  col2-9 adjust to col2-9, col 10-11 map to col 10-11
            //ddr3 full mode umctl v2.4 , col2-9 adjust to col2-9
            //v2.4 col =11,  col2-9 sequencial map to hi_cmd_addr[2:9], col10 map to  hi_cmd_addr[10], col 11 nomap
            writel(0,     ADDR_UMCTL2_ADDRMAP2);
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f00,  ADDR_UMCTL2_ADDRMAP4);
        }
        else{
            //lpddr2/lpddr3 half mode umctl v2.4 , col shift up 1, col2-9 adjust to col3-10,  col10 for auto prechage, col 10-11 no map
            //ddr3 half mode umctl v2.4 , col shift up 1, col2-> col9 adjust to col3-9, col11 , skip col 10
            //v2.4 adjusted  col3-10 sequencial map to hi_cmd_addr[2:9]([3:10] half mode  shift right one)
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);         
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }
        
        //lpddr2/lpddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[14:25]  ,base 6  program8 , taotal [14:27]
        //lpddr2/lpddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[13:24] ,base 6  program 7, taotal [13:26]
        writel((!dram.reduce_flag ? 0x08080808:0x07070707), ADDR_UMCTL2_ADDRMAP5);
        
        //b12 base 18, [26] ,program to 8, or 7 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f08:0x0f0f0f07), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0808:0x0f0f0707), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f080808:0x0f070707), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x08080808:0x07070707), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x08080808:0x07070707), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x08080808:0x07070707), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000008:0x00000007), ADDR_UMCTL2_ADDRMAP11);        
    } 
    else if(dram.col == 11 && dram.bank == 2 && dram.type == LPDDR2S4){
        /*addr map(row14, bank4, col11)    ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        //v2.4 cs0 = base 6 + 14 +7 + 1= hif_cmd_addr[28], reduced [27]
        writel((0x1f00 | (dram.row + (!dram.reduce_flag ? 0x8 : 0x7))), ADDR_UMCTL2_ADDRMAP0);    //rank defined

        //lpddr2/lpddr3 full mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[11:12] base2-4, program 9  
        //lpddr2/lpddr3 half mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[10:11]base2-4, program 8 
        writel(0x1f0808 + (!dram.reduce_flag ? 0x000101:0),     ADDR_UMCTL2_ADDRMAP1);
        
        if(!dram.reduce_flag){
            //lpddr2/lpddr3 full mode umctl v2.4 ,  col2-9 adjust to col2-9, col 10-11 map to col 10-11
            //ddr3 full mode umctl v2.4 , col2-9 adjust to col2-9
            //v2.4 col =11,  col2-9 sequencial map to hi_cmd_addr[2:9], col10 map to  hi_cmd_addr[10], col 11 nomap
            writel(0,     ADDR_UMCTL2_ADDRMAP2);
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f00,  ADDR_UMCTL2_ADDRMAP4);
        }
        else{
            //lpddr2/lpddr3 half mode umctl v2.4 , col shift up 1, col2-9 adjust to col3-10,  col10 for auto prechage, col 10-11 no map
            //ddr3 half mode umctl v2.4 , col shift up 1, col2-> col9 adjust to col3-9, col11 , skip col 10
            //v2.4 adjusted  col3-10 sequencial map to hi_cmd_addr[2:9]([3:10] half mode  shift right one)
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);         
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }

        //lpddr2/lpddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[13:24]  ,base 6  program7 , taotal [13:26]
        //lpddr2/lpddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[12:23] ,base 6  program 6, taotal [12:25]
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP5);

        //b12 base 18, [26] ,program to 8, or 7 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f07:0x0f0f0f07), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0707:0x0f0f0606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f070707:0x0f060606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000008:0x00000007), ADDR_UMCTL2_ADDRMAP11);        
    } 
    else if(dram.col == 10 && dram.bank == 2 && dram.type == LPDDR2S4){
        /*addr map(row14, bank4, col11) ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        //v2.4 cs0 = base 6 + 14 +5 + 1= hif_cmd_addr[26], reduced [25]
        writel((0x1f00 | (dram.row + (!dram.reduce_flag ? 0x6 : 0x5))), ADDR_UMCTL2_ADDRMAP0);  //rank defined

        //lpddr2/lpddr3 full mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[10:11] base2-4, program 8  
        //lpddr2/lpddr3 half mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[9:10]base2-4, program 7 
        writel(0x1f0707 + (!dram.reduce_flag ? 0x00000101:0),     ADDR_UMCTL2_ADDRMAP1);
        
        if(!dram.reduce_flag){
            //lpddr2/lpddr3 full mode umctl v2.4 ,  col2-9 adjust to col2-9, col10-11 to col10-11, no map
            //v2.4 col =11,  col2-9 sequencial map to hi_cmd_addr[2:9], col10  col 11 nomap
            writel(0,   ADDR_UMCTL2_ADDRMAP2);
            writel(0x00000000,  ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }
        else{
            //lpddr2/lpddr3 half mode umctl v2.4 , col shift up 1, col2-9 adjust to col3-10,  col10 for auto prechage, col 11 no map
            //v2.4 adjusted  col3-9 sequencial map to hi_cmd_addr[2:8]([3:9] half mode  shift right one)
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);
            writel(0x0f000000,  ADDR_UMCTL2_ADDRMAP3);                
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }

        //lpddr2/lpddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[12:23]  ,base 6  program6, total [12:25]
        //lpddr2/lpddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[11:22] ,base 6  program 5, total [11:24]
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP5);

        //b12 base 18, [25] ,program to 7, or 6 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f06:0x0f0f0f05), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0606:0x0f0f0505), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f060606:0x0f050505), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000006:0x00000006), ADDR_UMCTL2_ADDRMAP11);
    } 
    else if(dram.col == 9 && dram.bank == 2 && dram.type == LPDDR2S4){ //only 256Mb or 128Mb
        /*addr map(row14, bank8, col9 ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        writel((0x1f00 | (dram.row + 0x7)), ADDR_UMCTL2_ADDRMAP0);  //rank defined

        //lpddr2/lpddr3 full mode umctl v2.4 ,  bank0-1,  map to col hif_cmd_addr[9:10] base2-4, program 7 
        //lpddr2/lpddr3 half mode umctl v2.4 ,  bank0-1,  map to col hif_cmd_addr[8:9]base2-4, program 6 
        writel(0x1f0606+ (!dram.reduce_flag ? 0x00000101:0),     ADDR_UMCTL2_ADDRMAP1);
        
        if(!dram.reduce_flag){
            //lpddr2/lpddr3 full mode umctl v2.4 ,  col2-8 adjust to col2-8, col9 col10-11, no map
            //v2.4 col =11,  col2-8 sequencial map to hi_cmd_addr[2:8], base 2
            writel(0,   ADDR_UMCTL2_ADDRMAP2);
            writel(0x0f000000,  ADDR_UMCTL2_ADDRMAP3);
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }
        else{
            //lpddr2/lpddr3 half mode umctl v2.4 , col shift up 1, col2-8 adjust to col3-8,  col9 col10-11  no map
            //v2.4 adjusted  col3-8 sequencial map to hi_cmd_addr[2:7] ([3:9] half mode  shift right one)
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);
            writel(0x0f0f0000,  ADDR_UMCTL2_ADDRMAP3);                
            writel(0x0f0f,  ADDR_UMCTL2_ADDRMAP4);
        }

        //lpddr2/lpddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[11:22]  ,base 6  program6, total  [b0-b13] to[11:24]
        //lpddr2/lpddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[10:21] ,base 6  program 5 total [b0-b13] to [10:23]
        writel((!dram.reduce_flag ? 0x05050505:0x04040404), ADDR_UMCTL2_ADDRMAP5);

        //b12 base 18, [23] ,program to 5, or 4 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f05:0x0f0f0f04), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0505:0x0f0f0404), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f050505:0x0f040404), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x05050505:0x04040404), ADDR_UMCTL2_ADDRMAP6);  /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x05050505:0x04040404), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x05050505:0x04040404), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000005:0x00000004), ADDR_UMCTL2_ADDRMAP11);
    }
    else if (dram.bank == 2 && dram.type == DDR2) //64MB DDR2,default col  10bits
    {
        // default bank 8, 10 bit col ddr3 , no consideration of 1Gb*8 11 bit col ddr3  case or bank 4 
        /*addr map(row14, bank8, col10)    ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        //v2.4 cs0 [25], reduced [26]
        writel((0x1f1f | (dram.row + (!dram.reduce_flag ? 0x7 : 0x6))), ADDR_UMCTL2_ADDRMAP0);    //rank defined

        //ddr2 full mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[10:11] base2-4, program 8  
        //ddr2 half mode umctl v2.4 ,  bank0-1,  map to col hif_cmd_addr[9:10]base2-4, program 7 
        writel(0x1f0707 + (!dram.reduce_flag ? 0x0101:0),     ADDR_UMCTL2_ADDRMAP1);        //bank 0~2 always in HIF bit[9~11]
        
        if(!dram.reduce_flag){
            //ddr3 full mode umctl v2.4 , col2-9 adjust to col2-9
            //v2.4 col =10,  col2-9 sequencial map to hi_cmd_addr[2:9], col10/col 11 nomap, ,col10-11 no map
            writel(0,     ADDR_UMCTL2_ADDRMAP2);
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
        }
        else{
        //ddr3 half mode umctl v2.4 , col2-9 adjust to col3-9
        //v2.4 col =10,  adjusted col3-9 sequencial map to hi_cmd_addr[2:8], col10/col 11 nomap, ,col10-11 no map   
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);
            writel(0x0f000000,     ADDR_UMCTL2_ADDRMAP3);
        }
        writel(0x0f0f,     ADDR_UMCTL2_ADDRMAP4);            //col bit12 bit13 not used

        //ddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[12:23]  ,base 6  program7, total [b0-b13] to [12:25], 
        //ddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[11:22] ,base 6  program 6 total  [b0-b13] to[12:25]
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP5);
        
        //b12 base 18, [25] ,program to 7, or 6 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f06:0x0f0f0f05), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0606:0x0f0f0505), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f060606:0x0f050505), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x06060606:0x05050505), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000006:0x00000005), ADDR_UMCTL2_ADDRMAP11);
    }
    else {
        // default bank 8, 10 bit col ddr3/ddr2 , no consideration of 1Gb*8 11 bit col ddr3  case or bank 4 
        /*addr map(row14, bank8, col10)    ADDR_UMCTL2_ADDRMAP0 ~ ADDR_UMCTL2_ADDRMAP6*/
        //v2.4 cs0 = base 6 + 14 + 6+ 1= hif_cmd_addr[27], reduced [26]
        writel((0x1f00 | (dram.row + (!dram.reduce_flag ? 0x7 : 0x6))), ADDR_UMCTL2_ADDRMAP0);    //rank defined

        //ddr3 full mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[10:12] base2-4, program 8  
        //ddr3 half mode umctl v2.4 ,  bank0-2,  map to col hif_cmd_addr[9:11]base2-4, program 7 
        writel(0x070707 + (!dram.reduce_flag ? 0x010101:0),     ADDR_UMCTL2_ADDRMAP1);        //bank 0~2 always in HIF bit[9~11]
        
        if(!dram.reduce_flag){
            //ddr3 full mode umctl v2.4 , col2-9 adjust to col2-9
            //v2.4 col =10,  col2-9 sequencial map to hi_cmd_addr[2:9], col10/col 11 nomap, ,col10-11 no map
            writel(0,     ADDR_UMCTL2_ADDRMAP2);
            writel(0x00000000,     ADDR_UMCTL2_ADDRMAP3);
        }
        else{
        //ddr3 half mode umctl v2.4 , col2-9 adjust to col3-9
        //v2.4 col =10,  adjusted col3-9 sequencial map to hi_cmd_addr[2:8], col10/col 11 nomap, ,col10-11 no map   
            writel(0x00000000,      ADDR_UMCTL2_ADDRMAP2);
            writel(0x0f000000,     ADDR_UMCTL2_ADDRMAP3);
        }
        writel(0x0f0f,     ADDR_UMCTL2_ADDRMAP4);            //col bit12 bit13 not used

        //ddr3 full mode umctl v2.4 ,  row b0-b11,  map to col hif_cmd_addr[13:24]  ,base 6  program7, total [b0-b13] to [13:26], 
        //ddr3 half mode umctl v2.4, row b0-b11,  map to col hif_cmd_addr[12:23] ,base 6  program 6 total  [b0-b13] to[12:25]
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP5);
        
        //b12 base 18, [25] ,program to 7, or 6 (reduced)
        if(dram.row == 12)
            writel(0x0f0f0f0f, ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 13)
            writel((!dram.reduce_flag ? 0x0f0f0f07:0x0f0f0f06), ADDR_UMCTL2_ADDRMAP6);
        if(dram.row == 14)
            writel((!dram.reduce_flag ? 0x0f0f0707:0x0f0f0606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[26]: (0x14 + offset:0x6) */
        if(dram.row == 15)
            writel((!dram.reduce_flag ? 0x0f070707:0x0f060606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[27]: (0x15 + offset:0x6) */
        if(dram.row == 16)
            writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP6);    /*X9_EVB: full mode, bank 0 in HIF bit[28]: (0x16 + offset:0x6) */

        //b2 base 8
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP9);
        writel((!dram.reduce_flag ? 0x07070707:0x06060606), ADDR_UMCTL2_ADDRMAP10);
        writel((!dram.reduce_flag ? 0x00000007:0x00000006), ADDR_UMCTL2_ADDRMAP11);
    }

    if (dram.type == DDR2)
    {
        //burst len 8 
        if (dram.freq < 410)
        {
            tmp = (6 << 24) //wr_odt_hold
                   |((timing->twr - 4) <<16)  //wr_odt_delay = cwl + al -4
                   |(6<<8)                    //rd_odt_hold 
                   |((cl-4)<<2);                   //rd_odt_delay
        }
        else
        {
            tmp = (7 << 24) //wr_odt_hold
                    |((timing->twr - 5) <<16)  //wr_odt_delay = cwl + al -4(//wr_odt_delay = cwl + al -5
                    |(7<<8)                    //rd_odt_hold 
                    |((cl-5)<<2);                   //rd_odt_delay
        }
        writel(tmp, ADDR_UMCTL2_ODTCFG);
    }
    else
    {
        tmp = (0x04000400 | (cl - timing->tcwl) << 2); 
        writel(tmp,  ADDR_UMCTL2_ODTCFG);
    }
#if 0
    if (dram.rank_sel == 3)
    {
        writel(0x00001122, ADDR_UMCTL2_ODTMAP); // to be tested
    }
    else
    {
        writel(0x00000000, ADDR_UMCTL2_ODTMAP); // to be tested
    }
#else
    writel(0x00000000, ADDR_UMCTL2_ODTMAP); // to be tested verify rank1 odt error
#endif    
    //writel(0x7fc80f01, ADDR_UMCTL2_SCHED);
    writel(0x00861f05, ADDR_UMCTL2_SCHED);// to be tested
    writel(0x00000000, ADDR_UMCTL2_SCHED1); //bit[7:0]--pageclose_timer to be tested
    //if(MEMC_FREQ_RATIO == 1) // to be tested
    //    writel(0xffff00c8, ADDR_UMCTL2_PERFHPR0);
    writel(0x40000c0, ADDR_UMCTL2_PERFHPR1);
    //if(MEMC_FREQ_RATIO == 1)
    //    writel(0xffff00ff, ADDR_UMCTL2_PERFLPR0);// to be tested
    writel(0x4000045, ADDR_UMCTL2_PERFLPR1);    

    //if(MEMC_FREQ_RATIO == 1)
    //    writel(0xffff00c9, ADDR_UMCTL2_PERFWR0);
    writel(0x40000c0, ADDR_UMCTL2_PERFWR1);

    //writel(0x12000000, ADDR_UMCTL2_DBG0);
    writel(0x00000016, ADDR_UMCTL2_DBG0);// to be tested
    
    //writel(0xff000000, ADDR_UMCTL2_DBG1);
    writel(0, ADDR_UMCTL2_DBG1);//to be tested
    writel(0x00000000, ADDR_UMCTL2_DBGCMD); //to be tested //bit[0]--rank0_refresh,bit[1]--rank1_refresh,bit[2]--rank2_refresh,bit[3]--rank3_refresh,bit[4]--zq_calib_short,bit[5]--ctrlupd


    writel(0x00000008, ADDR_UMCTL2_PWRCTL);

}

void ddr_phy_set(void)
{
    uint32_t cl = dram.cl;
    struct infotm_dram_timing *timing = &dram.timing;
    int tmp = 0;

    if(dram.reduce_flag)
    {
        writel(0x1B6CCE80, ADDR_PHY_DX2GCR);
        writel(0x1B6CCE80, ADDR_PHY_DX3GCR);
    }
    //ivan 0621
    writel(0xb00001ce, ADDR_PHY_ZQ0CR0);
    writel(0xb00001ce, ADDR_PHY_ZQ1CR0);
    writel(0xb00003de, ADDR_PHY_ZQ0CR0);
    writel(0xb00003de, ADDR_PHY_ZQ1CR0);
    #if EVB_DRAM_TEST
    #if EVB_DRAM_ODT
    writel(0xb0031bde, ADDR_PHY_ZQ0CR0);
    writel(0xb0031bde, ADDR_PHY_ZQ1CR0);
    #endif
    #endif
    writel(0x0, ADDR_PHY_ZQ0CR1);
    writel(0x0, ADDR_PHY_ZQ1CR1);
    tmp = 0x01802E02 | (dram.rank_sel << 18) | (dram.type == DDR3 ? 0x4 : 0);    //0x18c2e06 alin 0x18c2e06
    writel(tmp, ADDR_PHY_PGCR);
#if MEMC_2T_MODE
    writel((0xa + ((dram.type == DDR2)? 0 : (dram.type == DDR3?1:2))) | (dram.type == LPDDR2S2 ? (0x1<<8):0) | (1 << 28),     ADDR_PHY_DCR);          /* DDR8BNK, DDRMD(DDR3) */
#else
    writel((0xa + ((dram.type == DDR2)? 0 : (dram.type == DDR3?1:2))) | (dram.type == LPDDR2S2 ? (0x1<<8):0),     ADDR_PHY_DCR);/* DDR8BNK,DDRMD(DDR3) */
#endif
    if (dram.type == DDR2)
    {
        tmp = 3 | (cl << 4) | ((timing->twr - 1) << 9);    
    }
    else
    {
        tmp = ((cl - 4) << 4) | ((timing->twr - 4) << 9);
    }
    writel(tmp,  ADDR_PHY_MR0);          /* CAS latency, write recovery(use twr) , LPDDR2 not use*/
    if(dram.type == DDR3){
        writel((dram.rtt | dram.driver),                ADDR_PHY_MR1);          /* RTT, DIC */
        writel((timing->tcwl - 5) << 3,                 ADDR_PHY_MR2);          /* CWL(CAS write latency, use tcwl) */
        writel(0x0,                         ADDR_PHY_MR3);
    } 
    else if (dram.type == DDR2)
    {
        writel((dram.rtt | dram.driver),                ADDR_PHY_MR1);          /* RTT, DIC */
        writel(1<<3, ADDR_PHY_MR2);
    }        
    else {        //LPDDR2 user
        writel(0x3 |((timing->twr - 2) << 5), ADDR_PHY_MR1);
        writel(cl -2, ADDR_PHY_MR2);
        writel(dram.driver,    ADDR_PHY_MR3);
    }
    if (dram.type == DDR2 && dram.freq > 410)
    {
        tmp = 0x3 | (6 << 2) | (5 << 5) | (cl << 8) | (timing->trcd << 12) | (timing->tras << 16) | (timing->trrd << 21) | (timing->trc << 25); //0x2a8f6690 alin 0x2c906693-->tras=15
    }
    else
    {
        tmp = 0x3 | (5 << 2) | (3 << 5) | (cl << 8) | (timing->trcd << 12) | (timing->tras << 16) | (timing->trrd << 21) | (timing->trc << 25); //0x2a8f6690 alin 0x2c906693-->tras=15
    }
    writel(tmp, ADDR_PHY_DTPR0);

    tmp = (timing->tfaw << 3) | (timing->trfc << 16 | ((dram.type == DDR3||dram.type == DDR2) ? 0: (0x11<<24)));    //0x4000a0 alin 0x2a2c6080
#ifdef    CONFIG_COMPILE_FPGA
    writel(0x09220050,  ADDR_PHY_DTPR1);        /* tFAW, tRFC */
#else
    writel(tmp,  ADDR_PHY_DTPR1);        /* tFAW, tRFC */
#endif
    //writel(0x10022c00,                                  ADDR_PHY_DTPR2);
    if (dram.type == DDR2)
    {
        writel(0x0641a0c8,                                  ADDR_PHY_DTPR2);
    }
    else
    {
        writel(0x1001b00c,                                  ADDR_PHY_DTPR2);
    }

    tmp = (0x1b << 0) | (0x14 << 6) | (0x8 << 18); /* DLL soft reset time, DLL lock time, ITM soft reset time */ //0x20051b alin 0x0020051b
    writel(tmp,                    ADDR_PHY_PTR0); /* DLL soft reset time, DLL lock time, ITM soft reset time */
    if(dram.type == LPDDR2S4 || dram.type == LPDDR2S2)
        writel(0x00000c40, ADDR_PHY_DXCCR);//bit 0 no dxodt, bit1 io sstl, bit4:7 dqs pullup/down resister bit8:11 dqs# resister
    writel(0xfa00001f | ((dram.type == DDR3 ||dram.type== DDR2) ? 0: (0x2<<5 | 0x2<<8)), ADDR_PHY_DSGCR);
    while((readl(ADDR_PHY_PGSR) & 0x3) != 0x3);    /* wait for init done and dll lock done */

    if(dramc_wake_up_flag) {                            //RTL no wakeup
    //if(0) {
#ifndef    CONFIG_COMPILE_FPGA
        writel(0x40000001,      ADDR_PHY_PIR);          /* ddr system init */
        while((readl(ADDR_PHY_PGSR) & 0x1) == 0x1);     /* wait for init done */
        writel(0x1000014a,      ADDR_PHY_ZQ0CR0);       /* impendance control and calibration */
        writel(readl(SYS_RTC_GPMODE) & ~0x1,             0x2d009c4c);
        writel(0x1,             0x2d009c7c);
        writel(0x0000014a,      ADDR_PHY_ZQ0CR0);
        writel(0x00000009,      ADDR_PHY_PIR);          /* impendance calibrate */
        while((readl(ADDR_PHY_PGSR) & 0x5) == 0x5);     /* wait for init done and impendance calibration done */
#else
        writel(0x00040001, ADDR_PHY_PIR);/*bi 18 ==1 indicate dram initialization will be performed by controller */
        while((readl(ADDR_PHY_PGSR) & 0x3) != 0x3);    /* wait for init done and dll lock done */
#endif
    }else{
#ifndef    CONFIG_COMPILE_FPGA
        if (dram.type == DDR2){
            writel(0x00000007, ADDR_PHY_PIR);
            while((readl(ADDR_PHY_PGSR) & 0x3) != 0x3);    /* wait for init done and dll lock done */
        }
        else
        {
            writel(0x0000000f, ADDR_PHY_PIR);
            while((readl(ADDR_PHY_PGSR) & 0x7) != 0x7);    /* wait for init done and dll lock done */
        }
#else
        writel(0x00040001, ADDR_PHY_PIR);           /*bi 18 ==1 indicate dram initialization will be performed by controller */
        while((readl(ADDR_PHY_PGSR) & 0x3) != 0x3);    /* wait for init done and dll lock done */
#endif
    }

    /*Start PHY initialization*/
    writel(0x0000011,       ADDR_PHY_PIR);  /*itm soft reset*/
    while((readl(ADDR_PHY_PGSR) & 0x3) != 0x3);    /* wait for init done and dll lock done */
#ifndef    CONFIG_COMPILE_FPGA
    writel(0x00040001, ADDR_PHY_PIR);
#endif
    while((readl(ADDR_PHY_PGSR) & 0x1) != 0x1);    /* poll done ,test */

    if(MEMC_FREQ_RATIO == 2)
        writel(0x0,                ADDR_UMCTL2_SWCTL);// enable quasi-dynamic register programming 

    writel(0x1,         ADDR_UMCTL2_DFIMISC);
    if(MEMC_FREQ_RATIO == 2){
        writel(0x1,                ADDR_UMCTL2_SWCTL);// disable quasi-dynamic register programming 
        while((readl(ADDR_UMCTL2_SWSTAT) & 0x1) != 0x1);//wait and echo when set swctl, to make sure values are already seted to the register

    }
    /*Wait for DWC_ddr_umctl2 to move to normal*/
    while((readl(ADDR_UMCTL2_STAT) & 0x3) != 0x1);
}

void dis_auto_fresh(void)
{
    writel(0x1,         ADDR_UMCTL2_RFSHCTL3);// disable auto refresh generated by umctl
    writel(0x0,         ADDR_UMCTL2_PWRCTL);  // 0:none, 1:set sdram into self refresh
    writel(0x0,         ADDR_UMCTL2_DFIMISC);
}

int ddr_training(void)
{

    //if(dramc_wake_up_flag && dram.rank_sel == 3)    //RTL no wakeup
#ifndef    CONFIG_COMPILE_FPGA
    int i;
    if(0 && dram.rank_sel == 3)
        writel(0x01882E06, ADDR_PHY_PGCR);
    writel(DQS_ADDR+0x1000,     ADDR_PHY_DTAR);     /*data training address, column, row and bank address*/
    //writel(0x71fff000,     ADDR_PHY_DTAR);     /*data training address, column, row and bank address*/
    writel(0x181,         ADDR_PHY_PIR);        /*PHY Initialization: Read DQS Training & Read Valid Training*/
    while((readl(ADDR_PHY_PGSR) & 0x10) != 0x10);     /* wait for Data Training Done */
    dramc_debug("ADDR_PHY_PGSR = 0x%x\n", readl(ADDR_PHY_PGSR));  /*Read General Status Register*/
    if(readl(ADDR_PHY_PGSR) & 0x20) {       /* test whether DQS gate training is error */
        dramc_debug("DQS Gate Training Error\n");
        /*DQS err than judge which bit is err*/
        //for(i=0; i<(dram.reduce_flag ? 2 : 4); i++)
        for(i=0; i<  2 /*(dram.reduce_flag ? 2 : 4)*/; i++)
        {
            if(readl(ADDR_PHY_DXGSR0(i)) & 0xf0)
                dramc_debug("dram train byte%d error \n", i);
            else
                dramc_debug("dram train byte%d Ok \n", i);
        }
        return 1;
    }
#if 1
    if((readl(ADDR_PHY_PGSR) & 0x100) == 0x100) {       /* test whether dramc Read Valid Training is error */
        dramc_debug("Read Valid Training Error\n");
        return 1;
    }
#endif
#endif

    writel(0x0,         ADDR_UMCTL2_RFSHCTL3);
    return 0;
}

/***************************************
 * V0.1 2015.12.10  q3f version test
 * V0.1 2015.12.10  q3f support 16bit
 *
 *
 *
 *************************************/
int dramc_init_memory(int suspend_resume)
{
    printf("DDR version V0.1, %s\n", __TIME__);
    //irf->module_enable(EMIF_SYSM_ADDR);
    /*before: emif & dll module reset*/
    dramc_wake_up_flag = suspend_resume;

    emif_module_reset();

    /*step1: Program the DWC_ddr_umctl2 registers*/
#if 1
    DWC_umctl2_reg();

    /*step2: Deassert soft reset signal RST.soft_rstb, reset_dut*/
    writel(0x0, EMIF_SYSM_ADDR_CORE_RES);
        writel(0x0, EMIF_SYSM_ADDR_BUS_RES);//dram axi port 0-4 axi bus deassert reset
    /*step3 & step4:Start PHY initialization by accessing relevant*/

    ddr_phy_set();

    /*step4: Disable auto-refreshes and powerdown by setting*/
    dis_auto_fresh();

    /*least all: Perform PUBL training as required*/
    if(ddr_training())
        return 1;

#else



    extern void test_umctl_reg(void);
    extern void test_phy_reg(void);
    /*step1: Program the DWC_ddr_umctl2 registers*/
    test_umctl_reg();
    /*step2: Deassert soft reset signal RST.soft_rstb, reset_dut*/
    writel(0x0, EMIF_SYSM_ADDR_CORE_RES);
    writel(0x0, EMIF_SYSM_ADDR_BUS_RES);//dram axi port 0-4 axi bus deassert reset
    /*step3 & step4:Start PHY initialization by accessing relevant*/
    test_phy_reg();
#endif
#if 1
    ddr_test_start();
    //ddr_test_pass(); // test only
	//ddr_read_write_test(0x40000000, 0x800000, 1);
	ddr_read_write_test(0x40000000, 0x800000, 12);
    int *addr = (int*)0x43000000;
    int i = 0;
     #define TEST_CNT 0x400000
    for (i = 0; i < TEST_CNT; i++)
    {
        addr[i] = 0xa5a5a5a5;
    }
    for (i = 0; i < TEST_CNT; i++)
    {
        if (addr[i] != 0xa5a5a5a5)
        {
            dramc_debug("addr[%d] =%d ,!= 0xa5a5a5a5\n", i, addr[i]);
            while(1);
        }   
    }
	//ddr_read_write_test(0x60000000, 0x4000000, 14);
    ddr_test_pass();
#endif

    return 0;
}

void dramc_set_bypass(void)
{
    //set vpll freq to 200MHZ
    //set PIR [17] to 1
    //set DLLGCR  [23] to 1

}

int dramc_verify_size(void)
{
    unsigned int checkaddr1=0, checkaddr2=0,checkaddr3=0;

    checkaddr1 = 0x40000000;
    checkaddr2 = checkaddr1 + (dram.size << 19);
    checkaddr3 = ((checkaddr1 >> 1) + (checkaddr2 >> 1));
    dramc_debug("checkaddr1 = 0x%x, checkaddr2 = 0x%x, checkaddr3 = 0x%x\n", checkaddr1, checkaddr2, checkaddr3);
    writel(0x87654321, checkaddr2);
    writel(0x12345678, checkaddr1);
    writel(0x87654321, checkaddr3);

#if IRAM_TEST
    int i;
    int test, test1;
    writel(0x12345678, 0x3c000000);
    writel(0x23456789, 0x3c005ffc);
    writel(0x23456789, 0x3c006000);
    writel(0x3456789a, 0x3c00bffc);
    writel(0x3456789a, 0x3c00c000);
    writel(0x456789ab, 0x3c011ffc);
    writel(0x456789ab, 0x3c012000);
    writel(0x56789abc, 0x3c017ffc);
    writel(0x56789abc, 0x3c018000);
    writel(0x6789abcd, 0x3c01effc);
    writel(0x6789abcd, 0x3c01f000);
    writel(0x789abcde, 0x3c023ffc);
    writel(0x789abcde, 0x3c024000);
    writel(0x89abcdef, 0x3c029ffc);
    writel(0x89abcdef, 0x3c02a000);
    writel(0x9abcdef0, 0x3c02fffc);
    writel(0x9abcdef0, 0x3c030000);
    writel(0xabcdef01, 0x3c031ffc);
    readl(0x3c000000);
    for(i=1; i<=8; i++){
        readl(0x3c000000 + i*0x6000 -0x4);
        readl(0x3c000000 + i*0x6000);
    }
    readl(0x3c031ff8);

    for(i=0; i<=7; i++){
        test = 0x55555555 + 0x11111111*i;
        test1 = 0x3c005fffd + i;
        writel(test, test1);
        test = 0x3c005fffd + i;
        readl(test);
    }

    for(i=0; i<=15; i++){
        test = 0x0 + 0x11*i;
        test1 = 0x3c005fff7 + i;
        writeb(test, test1);
        test = 0x3c005fff7 + i;
        readb(test);
    }

#endif
    /*1GB 32bit 0x40000000--->0x80000000*/
    if(dram.size == 1024 && dram.rank_sel == 1){
        dramc_debug("capacity 1024MB need cs0 remap cs1\n");
        writel(0x1, EMIF_SYSM_ADDR_MAP_REG);
    }
    return ((readl(checkaddr2) != 0x87654321) ? 1:(readl(checkaddr1) != 0x12345678));
}
