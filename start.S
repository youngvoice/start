.text
.global _start
_start:
/*set the cpu to svc32 mode*/
	mrs r0,cpsr
	bic r0,r0,#0x1f
	orr r0,r0,#0xd3  /*I=1 disable IRQ F=1 disable FIQ T=0 arm state */
	msr cpsr,r0

/*disable_mmu*/
	mcr p15,0,r0,c7,c7,0
	mrc p15,0,r0,c1,c0,0
	bic r0,r0,#0x00000007
	mcr p15,0,r0,c1,c0,0
/*peri port setup*/
	ldr r0,=0x70000000
	orr r0,r0,#0x13
	mcr p15,0,r0,c15,c2,4
/*Disable Watchdog
 *if you don't disable watchdog,because you don't to feed dog,so the CPU will conti *nue reboot.
*/
	ldr r0,=0x7e000000
	orr r0,r0,#0x4000
	mov r1,#0
	str r1,[r0]
/*Disable interrupt*/
	mvn r1,#0
	ldr r0,=0x71200014
	str r1,[r0]

	ldr r0,=0x71300014
	str r1,[r0]
	
/*Init clock*/
#define APLL_LOCK	0x7e00f000
#define MPLL_LOCK	0x7e00f004
#define EPLL_LOCK	0x7e00f008
#define LOCK_TIME	0xffff

#define OTHERS		0x7e00f900

#define CLK_DIV0	0x7e00f020

#define CLK_SRC		0x7e00f01c

@ set the lock time to max
	ldr r0, =LOCK_TIME
	ldr r1, =APLL_LOCK
	str r0, [r1]
	ldr r1, =MPLL_LOCK
	str r0, [r1]
	ldr r1, =EPLL_LOCK
	str r0, [r1]	
					
	@ set async mode
	ldr r0, =OTHERS
	ldr r1, [r0]
	bic r1, #0xc0			
	str r1, [r0]

	loop1:
	ldr r0, =OTHERS
	ldr r1, [r0]
	and r1, #0xf00					
	cmp r1, #0
	bne loop1		

	@ set the divider

	#define DIV_VAL	( (0)|(1<<4)|(1<<8)|(1<<9)|(3<<12) )
	ldr r0, =CLK_DIV0
	ldr r1, =DIV_VAL
	str r1, [r0]	
			
	@ set APLL, MPLL, EPLL		
	#define SDIV	1
	#define PDIV	3
	#define MDIV	266	
	#define PLL_ENABLE	( 1 << 31 )
	#define APLL_VAL	( (SDIV<<0)|(PDIV<<8)|(MDIV<<16)|(PLL_ENABLE) )
	#define MPLL_VAL	APLL_VAL
	#define EPLL0_VAL	( (2<<0)|(1<<8)|(32<<16)|PLL_ENABLE)
	#define EPLL1_VAL	( 0 )
								
	#define APLL_CON	0x7e00f00c
	#define MPLL_CON	0x7e00f010
	#define EPLL_CON0	0x7e00f014
	#define EPLL_CON1	0x7e00f018

	ldr r0, =APLL_CON
	ldr r1, =APLL_VAL
	str r1, [r0]

	ldr r0, =MPLL_CON
	ldr r1, =MPLL_VAL
	str r1, [r0]
	
	ldr r0, =EPLL_CON0
	ldr r1, =EPLL0_VAL
	str r1, [r0]

	ldr r0, =EPLL_CON1
	ldr r1, =EPLL1_VAL
	str r1, [r0]

	@ select the source 					
	ldr r0, =CLK_SRC
	mov r1, #7
	str r1, [r0]
	
init_mem:
	ldr r0,=0x7e00f120
    	mov r1, #0x8
   	str r1, [r0]

        ldr r0, =0x7e001004     
        mov r1, #0x4         
        str r1, [r0]

        ldr r0, =0x7e001010  
        ldr r1, =( ( 7800 / ( 1000000000/133000000 ) + 1 ) )      
        str r1, [r0]

        ldr r0, =0x7e001014  
        mov r1, #(3 << 1)
        str r1, [r0]

        ldr r0, =0x7e001018      
        mov r1, #0x1
        str r1, [r0]

        ldr r0, =0x7e00101c      
        mov r1, #0x2
        str r1, [r0]

        ldr r0, =0x7e001020       
        ldr r1, =( ( 45 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001024       
        ldr r1, =( ( 68 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001028       
        ldr r1, =( ( 23 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e00102c       
        ldr r1, =( ( 80 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001030       
        ldr r1, =( ( 23 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001034       
        ldr r1, =( ( 15 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001038       
        ldr r1, =( ( 15 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e00103c       
        mov r1, #0x07
        str r1, [r0]

        ldr r0, =0x7e001040       
        mov r1, #0x02
        str r1, [r0]

        ldr r0, =0x7e001044      
        ldr r1, =( ( 120 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e001048       
        ldr r1, =( ( 120 / ( 1000000000 / 133000000 ) + 1 ) )
        str r1, [r0]

        ldr r0, =0x7e00100c       
        ldr r1, =0x00010012       
        str r1, [r0]
 
        ldr r0, =0x7e00104c      
        ldr r1, =0x0b45
        str r1, [r0]

        ldr r0, =0x7e001200   
        ldr r1, =0x150f8
        str r1, [r0]

        ldr r0, =0x7e001304       
        mov r1, #0x0
        str r1, [r0]
 
        ldr r0, =0x7e001008
        ldr r1, =0x000c0000
        str r1, [r0]

        ldr r1, =0x00000000
        str r1, [r0]

        ldr r1, =0x00040000
        str r1, [r0]

        ldr r1, =0x000a0000
        str r1, [r0]

        ldr r1, =0x00080032
        str r1, [r0]

        ldr r0, =0x7e001004
        mov r1, #0x0
        str r1, [r0]

check_dmc1_ready:
    
        ldr r0, =0x7e001000 
        ldr r1, [r0]
        mov r2, #0x3
        and r1, r1, r2
        cmp r1, #0x1
        bne check_dmc1_ready
        nop

    
	
/*prepare C language environment*/


/*
*copy_to_ram:
*	ldr r0,=0x0c000000
*	ldr r1,=0x50000000
*	add r3,r0,#1024*4
*copy_loop:
*	ldr r2,[r0],#4
*	str r2,[r1],#4
*	cmp r0,r3
*	bne copy_loop
*/

	
init_stack:
	ldr sp,=0x54000000

copy_to_ram:
	adr r0, _start   /* 获得_start指令当前所在的地址 : 0*/
	ldr r1, =_start  /* _start的链接地址 0x51000000 */
	
	ldr r2, =bss_start      /* bss段的起始链接地址 */
	
	sub r2, r2, r1
	
	cmp r0,r1
	beq clean_bss
	
	bl copy2ddr
	cmp r0, #0
	bne halt	
clean_bss:
	ldr r0,=bss_start
	ldr r1,=bss_end
	cmp r0,r1
	beq to_ddr
clean_loop:
	mov r2,#0
	str r2,[r0],#4
	cmp r0,r1
	bne clean_loop
			

	


to_ddr:
	bl light_led
	ldr pc,=main

light_led:
	ldr r1, =0x7F008820
	ldr r0, =0x1111
	str r0, [r1]
	
	ldr r1, =0x7F008824
	mov r0,#0xe
	str r0,[r1]
	mov pc, lr	
	
halt:
	b halt
