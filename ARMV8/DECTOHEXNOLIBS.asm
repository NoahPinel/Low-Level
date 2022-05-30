/* 
* 2022-05-28
* UCID:30159409
* Noah Pinel
*
* ASSIGNMENT 3 < binary multiplication, division, and shifting in ARMv8 assembly>
* 
* Programt takes UI, checks for parity, proceeds accordingly
* for converting to hex the program does the following
* 1) call bfxil from UI and grab lsb from pos 60 with a size of 4
* 2) take the 4 bits and store in a temp reg that is zeroed
* 3) compare the bit to a value 1-15 and print the corresponding mapped hex val
* 4) shift the UI 4 bits to the left, update counter
* 5) cont 16 time. b/c 64 // 4 == 16 we want to look at entire x register.
*/

//---------- STRING SECTION ----------//
				.text	
				promptForUi:	.string "ENTER N VALUE: "		
					  getUI:	.string "%ld"
				   outputUI: 	.string "CONVERTING %ld TO HEX...\n"
					hexForm:	.string	"0X"
				 negHexForm:	.string "-0x"
		  	   noChangeText:	.string "%ld"	
					  hex10:	.string "A"
	    			  hex11:	.string "B"
					  hex12:	.string "C"
			          hex13:	.string "D"
			    	  hex14:	.string "E"
					  hex15:	.string "F"
					exitTxt:	.string "\n"
				negOutputUI:	.string "CONVERTING -%ld TO HEX...\n"

                .balign 4   								// set 4bit allign
                .global main								// make main visible to the OS




//---------- M4 MACROS SECTION ----------//
				define(i, x20)								// define i, set to x20 register
				define(ngFlag, w21)							// define ngFlag, set to w21 register
				define(UI, x19)								// define UI, set to x19 register
				define(tmp4Lsb, x23)						// define tmp4Lsb, set to x23 register
				

main:   		stp     x29,    x30,    [sp,16]!			// save fp register and link register current values on stack
                mov     x29,    sp				    		// update fp register

				mov		i,	0								// i == 0
				mov		ngFlag,	0							// init neg flag
		
UI:				
				ldr		x0,		=promptForUi				// load greeting prompt
				bl		printf								// call printf
				ldr		x0,		=getUI						// load for UI
				ldr		x1,		=intN						// load input into intN
				bl 		scanf								// call function scanf
				ldr		x1,		=intN						// load intN into x1
				ldr		UI,	[x1]							// store value of x1 into UI_r

negiTest:
				cmp		UI,	0								// UI < 0		
				b.lt	negFlag								// if branch to neg flag set
				b		posiHex								// else cont as usual


negFlag:
				mov		ngFlag,		1						// set boolean flag to true
				neg		UI,		UI							// get the abs|intN| so we can do our conversion

				
				cmp		ngFlag,	1							// negflag == 1
				b.eq	negHex								// branch to negative handle
				b		posiHex								// else cont

negHex:
				ldr		x0,		=negOutputUI				// load outputUI messege
				mov		x1,		UI							// mov x19 into x1
				bl		printf								//	call print

				ldr		x0,		=negHexForm					// load output
				bl		printf								//	call printf
				b		loop
posiHex:
				ldr		x0,		=outputUI					// load outputUI messege
				mov		x1,		UI							// mov x19 into x1
				bl		printf								//	call printf



				ldr		x0,		=hexForm					// load output
				bl		printf								//	call printf


loop:
				cmp		i,	16								// loop 16 times 4 * 6 == 64
				b.ge	exit								// i < 16
				
				bfxil	tmp4Lsb,	UI,	60,		4			// get the 4 lsb from x19, push it 60 to handle endianness,
															// without the size being 60 this would output the hex backwards
				
hexMapping:
				cmp		tmp4Lsb,	10						// if temp 4 bits is less then 10
				b.lt	noChange							// return deci val
			
				cmp		tmp4Lsb,	0xA						// if temp 4 bits is 10
				b.eq	bhex10								// print A
			
				cmp		tmp4Lsb,	0xB						// if temp 4 bits is 11
				b.eq	bhex11								// print B
			
				cmp		tmp4Lsb,	0xC						// if temp 4 bits is 12
				b.eq	bhex12								// print C
			
				cmp		tmp4Lsb,	0xD						// if temp 4 bits is 13
				b.eq	bhex13								// print D
			
				cmp		tmp4Lsb,	0xE						// if temp 4 bits is 14
				b.eq	bhex14								// print E
			
				cmp		tmp4Lsb,	0xF						// if temp 4 bits is 15
				b.eq	bhex15								// print F


noChange:
				ldr		x0,		=noChangeText				// load outputUI messege
				mov		x1,		tmp4Lsb						// load tmp 4 lsb
				bl		printf								// call printf
				b		loopUpdate	



bhex10:
				ldr		x0,		=hex10						// load outputUI messege
				bl		printf								// call printf
				b 		loopUpdate							// cont
		
bhex11:

				ldr		x0,		=hex11						// load outputUI messege
				bl		printf								// call printf
				b 		loopUpdate							// cont

bhex12:
				ldr		x0,		=hex12						// load outputUI messege
				bl		printf								// call printf
				b 		loopUpdate							// cont


	
bhex13:
				ldr		x0,		=hex13						// load outputUI messege
				bl		printf								// call printf
				b 		loopUpdate							// cont		


	
bhex14:
				ldr		x0,		=hex14						// load outputUI messege
				bl		printf								// call printf
				b 		loopUpdate							// cont


	
bhex15:
				ldr		x0,		=hex15						// load outputUI messege
				bl		printf								// call printf
	
loopUpdate:
				add		i,	i,	1							// i++
				lsl		UI,	UI,	4					// shift UI reg l by 4
				b 		loop

				
exit:	
				ldr		x0,		=exitTxt					// load exit format
				bl		printf								// call printf

				ldp x29, x30, [sp], 16						// restore state
                ret											// return to caller


//---------- data section ----------// 
				.data
				intN: 	.dword	0 	                        //scanf will store the number entered by user in this memory location


