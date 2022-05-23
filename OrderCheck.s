/* 
* 2022-05-22
* UCID:30159409
* Noah Pinel
*
* ASSIGNMENT 2 <branching and looping in ARMv8 assembly>
*/
												//String outputs
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

                .balign 4   					// Set 4bit allign
                .global main
				
main:   		stp     x29,    x30,    [sp,16]!// save fp register and link register current values on stack
                mov     x29,    sp				// update fp register
				

				mov 	x0,		0 				// init x0, rand will be stored in this reg
				bl		time		  			// call time()
				bl		srand		  			// call srand() seeding rand
				mov		x22,	16				// init x22 for mod 16 ie range 1-15
				mov		x23,	0 				// counter i=0
				mov		x25,	0				// sum init = 0

				mov		x27,	0				// ascending flag set to FALSE
				mov		x28,	0				// descending flag set to FALSE


getUI_CheckUI:	
				ldr		x0,		=UIhelper		// call UIhelper, prompts for input
				bl		printf					// call printf()
				
				ldr		w0,		=getUI 			// call the lower 32 bits of 0 reg
				ldr 	w1, 	=intN			// load the lower 32 bits of reg 1 with the address of varialble   	
				bl 		scanf					// call function scanf

				ldr		x1,		=intN			// load intN into x1
				ldr		w19,	[x1]			// store the value of 64 bit x24 into lower 32 bits of reg 19

				ldr 	x1, 	=intN			// load intN into x1  	
				ldr 	x24,	[x1]			// load content of x1 in register x24
checkInput:
				cmp		w19,	0				// if w19 > 0, this will check for negative inputs, where as the x register wouldnt work like this. 
				b.le	invalUI				   
				b		outputUI				// if TRUE continue 
invalUI:
				ldr		x0,		=invalidUI		// load error messege
				bl		printf					// call printf
				b       getUI_CheckUI		 	// re loop   
				


outputUI:
				ldr		x0,		=formatUI 		// output UI, makes output nice
				mov		x1,		x24				// move x24 val into x1
				bl		printf					// call printf()


loop: 		   // Loop test at the top
				cmp		x23,	x24				// x23 is not x24
				b.eq	orderCheck				// else proc exit
				
				bl		rand					// call rand()
				mov		x19,	x0				// load rand num into x19


//-------------------------- GETTING RAND() % 16-----------------------------------//

				udiv	x20,	x19,	x22		 // formula for getting remainder ----> formula NUMERATOR - (QUO * DENOM)
				msub	x21,	x20,	x22, 	x19	// msub, very usefull for this formula
				
				add		x25,	x25,	x21		// calc sum i.e x25 += x21 , adding rand number to x25, and keeping the sum in x25
			   	

				ldr		x0,		=printRand		// load mess1
				mov		x1,		x21				// load the remainder from the calc i.e our random number 1-15
				bl		printf					// call printf()	

				
//------------------------- CHECKING ORDER ----------------------------------------//
				
				
if:				cmp		x23,	0				// make sure loop is past first iteration, this ensures that teh temp register is not empty when cmp
				b.eq	else					// branch to else

				cmp		x21,	x26				// if current rand is <= stored rand 
				b.ge	elif					// branch to elif 
				mov		x27,	1				// set ascending flag to TRUE	

elif:	
				cmp		x21, 	x26				// if current rand is >= stored rand	
				b.le	else					// branch to else
				mov		x28,	1				// set Descending flag to TRUE
				
				
else:
			   	mov		x26,	x21				// Put rand into temp reg
			   	add		x23,	x23,	1		// i++
			
				b		loop					// loop



//------------------------- CHECKING ORDER FLAGS ----------------------------------------//			   
orderCheck:
				cmp		x27,	0				// if ascending is TRUE i.e != 0
				b.eq	ascending				// branch to ascending messege 
				
				cmp		x28,	0				// if descending is TRUE i.e != 0
				b.eq	descending				// branch to descending messege
				
				b		neither				// if neither ascending or descenindg are true then the sequence must have no order, branch to neither		
			
			
ascending:
				ldr		x0,		=ascend			// load ascending messege
				bl		printf					// call printf()
				b		printSum				// branch to printsum


descending:
				ldr		x0,		=descend		// load descending messege
				bl		printf					// call printf()
				b		printSum				//branch to printsum


neither:
				ldr		x0,		=neitherMess	// load neitherMess
				bl		printf					// call printf()
				b		printSum				// branch to printsum


printSum:
				ldr		x0,		=outputSum			// call sum format
				mov		x1,		x25				// print sum
				bl		printf					// call printf()
                	


exit:				

				ldp x29, x30, [sp], 16			// restore state
                ret


				//data section contains initialized global variables 
				.data
				intN: 	.dword	0 	 //scanf will store the number entered by user in this memory location
