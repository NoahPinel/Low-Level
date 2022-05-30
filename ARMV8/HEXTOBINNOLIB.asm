/* 
* 2022-05-28
* UCID:30159409
* Noah Pinel
*
* ASSIGNMENT 3 < binary multiplication, division, and shifting in ARMv8 assembly>
* 
 This program reads in 4 digit hex number i.e(ABC3) as a char, then the program
 converts the ascii value to decimal by subtracting the right number based on ascii vals.
 the program then take the decimal value and converts it to base two, the following algorithm is used
 1) divide by 2, get quotient, get remainder
 2) store mod 2 val, move quotient into current temp char
 3) repeat this 4 times, since we want 4 bytes.
 4) all 4 binary values of current char are stored.
 5) then print in reverse order, this deals with the endianness.
 6) do this total process 4 times, since we need to convert the 4 hex values one by one
 7) the result will be the binary representation of whatever hex val entered
*/	
	
//---------- STRING SECTION ----------//	
			.text
		  greet:		.string "ENTER HEX: "
		     UI:		.string	"%c%c%c%c"
		   buff:		.string "CONVERTING TO BASE 2\n"
			 OP:		.string "%d%d%d%d"
			out:		.string "\n"




			.balign 4							// set 4bit allign
			.global main						// make main visible to the OS




//---------- M4 MACROS ----------//			
			define(i, w24)						// define i, set to w24 register
			define(char1, x19)					// define char1, set to x19 register
			define(char2, x20)					// define char2, set to x20 register
			define(char3, x21)					// define char3, set to x21 register
			define(char4, x22)					// define char4, set to x22 register
			define(tmpChar, x23)				// define tmpChar, set to x23 register
			define(divisor, x25)				// define divisor, set to x25 register
			define(tmpBin1, x26)				// define tmpBin1, set to x26 register
			define(tmpBin2, x27)				// define tmpBin2, set to x27 register
			define(tmpBin3, x28)				// define tmpBin3, set to x28 register

main:	
			stp x29, x30, [sp, -16]!
			mov x29, sp
			
			mov		i,	1						// init i var, our counter			

			ldr		x0,		=greet				// prompt 
			bl		printf						// call printf
			

				
			ldr		x0,		=UI					// load UI prompt into x0
			ldr		x1,		=hex1				// load hex1 prompt into x1
			ldr		x2,		=hex2				// load hex2 prompt into x2
			ldr		x3,		=hex3				// load hex3 prompt into x3
			ldr		x4,		=hex4				// load hex4 prompt into x4

			bl		scanf						// call scanf
			ldr		x1,		=hex1				// load hex1 prompt into x1
			ldr		x2,		=hex2				// load hex2 prompt into x2
			ldr		x3,		=hex3				// load hex3 prompt into x3
			ldr		x4,		=hex4				// load hex4 prompt into x4
			

			ldr		char1,	[x1]				// load val of x1 into char	1
			ldr		char2,	[x2]				// load val of x2 into char 2
			ldr		char3,	[x3]				// load val of x3 into char 3
			ldr		char4,	[x4]				// load val of x4 into char 4

			ldr		x0,		=buff				// load screen buffer, makes output celan	
			bl		printf						// call printf
	

//---------- MAIN LOOP ----------//			

loop:						
			cmp		i,	5						// while (i <= 4) 
			b.eq	exit						// else break
			
			cmp		i,	1						// check iteration
			b.eq	it1							// branch to iter 1 	

			cmp		i,	2						// check iteration
			b.eq	it2						    // branch to iter 2
			
			cmp		i,	3						// check iteration
			b.eq	it3						    // branch to iter 3

			cmp		i,	4						// check iteration
			b.eq	it4						    // branch to iter 4
		

it1:
			mov		tmpChar,	char1			// store char 1 in tmp
			b		asctodec					// cont.

it2:
			mov		tmpChar,	char2			// store char 2 in tmp
			b		asctodec					// cont.



it3:
			mov		tmpChar,	char3			// store char 3 in tmp 
			b		asctodec					// cont.


it4:	

			mov		tmpChar,	char4			// store char 4 in tmp
			b		asctodec					// redundent continue call, make more readable


//---------- ASCII --> DEC ----------//	
asctodec:
		

			cmp		tmpChar,	58				// if tmp char is < 57 ascii val cont
			b.ge	letter						// else branch to letter conversion
			sub		tmpChar,	tmpChar,	48	// sub tmp char from 48, get dec 1-9
			b		decToBin					// cont to binary conversion

letter:	
			sub		tmpChar,	tmpChar,	55	// sub tmp char from 55, get letters A-F in our case
			b		decToBin					// redundent continue call, make more readable


//---------- DEC --> BIN ----------//	
decToBin:
			mov		divisor,	2				// divisor, dividing by 2 to convert to bin
			
		
			udiv    x1, tmpChar, divisor        // get quotient
			mul     x2, x1, divisor             // formula for get mod      
			sub     x3, tmpChar, x2             // mod 2 of tmp char 
			
			mov		tmpChar,	x1				// move quotient into tmp char
			mov		tmpBin1,	x3				// store binary value, this is to prevent the number being printed backwards, i.e handles the endianness
			
		
			udiv    x1, tmpChar, divisor         // get quotient
			mul     x2, x1, divisor              // formula for get mod       
			sub     x3, tmpChar, x2              // mod 2 of tmp char 
		
			mov		tmpChar,	x1				 // move quotient into tmp char
			mov		tmpBin2,	x3				 // store binary value, this is to prevent the number being printed backwards, i.e handles the endianness


			udiv    x1, tmpChar, divisor         // get quotient
			mul     x2, x1, divisor              // formula for get mod        
			sub     x3, tmpChar, x2				 // mod 2 of tmp char 
			
			mov		tmpChar,	x1				 // move quotient into tmp char
			mov		tmpBin3,	x3				 // store binary value, this is to prevent the number being printed backwards, i.e handles the endianness


			udiv    x1, tmpChar, divisor         // get quotient
			mul     x2, x1, divisor              // formula for get mod    
			sub     x3, tmpChar, x2              // the mod 
			
			
			ldr		x0,		=OP					 // load output string
			mov		x1,		x3					 // load 4th calculated mod 2
			mov		x2,		tmpBin3				 // load 3rd calculated mod 2
 			mov		x3,		tmpBin2				 // load 2nd calculated mod 2	
			mov		x4,		tmpBin1				 // load 1st calculated mod 2	
			bl		printf						 // call printf 
			add		i,	i,	1					 //	i++		 
			b		loop						 // loop again


//---------- EXIT ----------//	
exit:
			ldr	x0,		=out					 // load output mssg
			bl		printf						 // call printf
		
			ldp x29, x30, [sp], 16				 // restore state	
			ret								     // return to caller



.data
	
		hex1:	.dword 0						 // char1
		hex2:	.dword 0						 // char2
		hex3:	.dword 0						 // char3
		hex4:	.dword 0						 // char4


