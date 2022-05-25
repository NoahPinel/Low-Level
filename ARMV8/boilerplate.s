/* 
ARMV8 Boiler Plate
*/
												//String outputs
				.text
		

                .balign 4   					// Set 4bit allign
                .global main
				

main:   		stp     x29,    x30,    [sp,16]!// save fp register and link register current values on stack
                mov     x29,    sp				// update fp register
				

                define(_r, x)                    // define , as x register
                define(_r, w)                    // define , as lower 32 bits of register


                	

exit:				

				ldp x29, x30, [sp], 16			// restore state
                ret


				                                //data section contains initialized global variables 
				.data
				
