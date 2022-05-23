/* 
* 2022-05-22
* UCID:30159409
* Noah Pinel
*
* ASSIGNMENT 2 <branching and looping in ARMv8 assembly>
*/
//-----------------  DEFINING Strings  -----------------//

				.text
				 UIhelper:	.string "Enter an integer: "
				    getUI:	.string "%d"
				 formatUI:	.string "Generating %ld random number's....\n"
				printRand:  .string "%ld "
				invalidUI:	.string "ERROR: TRY ENTERING AN N GREATER THAN 0\n"
				outputSum:	.string "\nsum: %ld\n"
				   ascend:	.string	"\nascending order"
				  descend:	.string	"\ndescending order"
			  neitherMess:  .string "\nThese numbers are not in order at all..."

                .balign 4   					        // Set 4bit allign
                .global main
				
main:   		stp     x29,    x30,    [sp,16]!        // save fp register and link register current values on stack
                mov     x29,    sp				        // update fp register

//----------------- DEFINING M4 MACROS -----------------//

                define(curRand_r, x21)                  // define i, set to x21 register
                define(i_r, x23)                        // define i, set to x23 register
                define(UI_r, x24)                       // define UI_r, set to x24 register
                define(sum_r, x25)                      // define sum, set to x25 register
                define(storedRand_r, x26)               // define storedRand_r, set to x26 register
                define(AFLAG_r, x27)                    // define AFLAG_r, set to x27 register
                define(DFLAG_r, x28)                    // define DFLAG_r, set to x28 register

				mov 	x0,		0 				        // init x0, rand will be stored in this reg
				bl		time		  			        // call time()
				bl		srand		  			        // call srand() seeding rand
				mov		x22,	16				        // init x22 for mod 16 ie range 1-15
				mov		i_r,	0 				        // counter i=0
				mov		sum_r,	0				        // sum init = 0

				mov		AFLAG_r,	0			        // ascending flag set to FALSE
				mov		DFLAG_r,	0			        // descending flag set to FALSE


getUI_CheckUI:	
				ldr		x0,		=UIhelper		        // call UIhelper, prompts for input
				bl		printf					        // call printf()
				
				ldr		w0,		=getUI 			        // call the lower 32 bits of 0 reg
				ldr 	w1, 	=intN			        // load the lower 32 bits of reg 1 with the address of varialble   	
				bl 		scanf					        // call function scanf

				ldr		x1,		=intN			        // load intN into x1
				ldr		w19,	[x1]			        // store the value of 64 bit UI_r into lower 32 bits of reg 19

				ldr 	x1, 	=intN			        // load intN into x1  	
				ldr 	UI_r,	[x1]			        // load content of x1 in register UI_r
checkInput:     
				cmp		w19,	0				        // if w19 > 0, this will check for negative inputs, where as the x register wouldnt work like this. 
				b.le	invalUI				            // if TRUE continue 
				b		outputUI 						// pass on
												        
invalUI:
				ldr		x0,		=invalidUI		        // load error messege
				bl		printf
				b       getUI_CheckUI					 // branch
				

outputUI:
				ldr		x0,		=formatUI 		        // output UI, makes output nice
				mov		x1,		UI_r				    // move UI_r val into x1
				bl		printf					        // call printf()


loop:				
				bl		rand					        // call rand()
				mov		x19,	x0				        // load rand num into x19



//----------------- GETTING RAND() % 16 ----------------//


				udiv	x20,	x19,	x22		        // formula for getting remainder ----> formula NUMERATOR - (QUO * DENOM)
				msub	curRand_r,	x20,	x22, 	x19	// msub, very usefull for this formula
				
				add		sum_r,	sum_r,	curRand_r       // calc sum i.e sum_r += curRand_r , adding rand number to sum_r, and keeping the sum in sum_r
			   	

				ldr		x0,		=printRand		        // load mess1
				mov		x1,		curRand_r				// load the remainder from the calc i.e our random number 1-15
				bl		printf					        // call printf()	

				
//------------------ CHECKING ORDER --------------------//
				
				
if:				cmp		i_r,	0				        // make sure loop is past first iteration, this ensures that teh temp register is not empty when cmp
				b.eq	else					        // branch to else

				cmp		curRand_r,	storedRand_r		// if current rand is <= stored rand 
				b.ge	elif					        // branch to elif 
				mov		AFLAG_r,	1				    // set ascending flag to TRUE	

elif:	
				cmp		curRand_r, 	storedRand_r		// if current rand is >= stored rand	
				b.le	else					        // branch to else
				mov		DFLAG_r,	1				    // set Descending flag to TRUE
				
				
else:
			   	mov		storedRand_r,   curRand_r       // Put rand into temp reg
			   	add		i_r,	i_r,	1		        // i++
                // Loop test at the top
				cmp		i_r,	UI_r			        // i_r is not UI_r
				b.eq	orderCheck				        // else proc exit
			
				b		loop					        // loop



//------------------ CHECKING ORDER FLAGS --------------//			   
orderCheck:
				cmp		AFLAG_r,	0			        // if ascending is TRUE i.e != 0
				b.eq	ascending				        // branch to ascending messege 
				
				cmp		DFLAG_r,	0			        // if descending is TRUE i.e != 0
				b.eq	descending				        // branch to descending messege
				
				b		neither				            // if neither ascending or descenindg are true then the sequence must have no order, branch to neither		
			
			
ascending:
				ldr		x0,		=ascend			        // load ascending messege
				bl		printf					        // call printf()
				b		printSum				        // branch to printsum


descending:
				ldr		x0,		=descend		        // load descending messege
				bl		printf					        // call printf()
				b		printSum				        //branch to printsum


neither:
				ldr		x0,		=neitherMess	        // load neitherMess
				bl		printf					        // call printf()
				b		printSum				        // branch to printsum


printSum:
				ldr		x0,		=outputSum		        // call sum format
				mov		x1,		sum_r			        // print sum
				bl		printf					        // call printf()
                	


exit:				

				ldp x29, x30, [sp], 16			        // restore state
                ret


				//data section contains initialized global variables 
				.data
				intN: 	.dword	0 	                    //scanf will store the number entered by user in this memory location

