/* 
* 2022-06-10
* UCID:30159409
* Noah Pinel
*
* ASSIGNMENT 4 <2D arrays in ARMv8 assembly>
*/
//----------  DEFINING Strings  ------------//
	.text
			zeroHand: 		.string "There is nothing to see here.. \ntry a bigger number\n"
			 negHand:		.string "That wont work!!\nTry a positive number...\n"
			  prompt: 		.string "ENTER N: "
			   getUI: 		.string "%ld"
			  output: 		.string " %d "
			   fixOP: 		.string "\n"
			  coords: 		.string "%ld) Occurrence found at <%d,%d>\n"
		promptsearch: 		.string "\nENTER A DIGIT TO SEARCH FOR: "
		   getsearch:	  	.string	"%ld"
		  searchMess: 		.string	"SEARCHING FOR DIGIT %ld\n"
			 badSput:		.string "ERROR: SEARCH RANGE IS 0-9, TRY AGAIN"
   			 noMatch:		.string "NO OCCURENCES FOUND\n"
			 rPrompt:		.string	"ENTER 1 TO LEAVE or 0 TO SEARCH AGAIN: "
			exitmess:		.string "< - - - TERMINATING PROGRAM - - - >\n"


//------------ DEFINING M4 MACROS ----------//
			define(i,x19)					// define i, set to x19 reg
			define(j,x20)					// define j, set to x20 reg
			define(randNum,w21)				// define randNum, set to w21 reg
			define(head,x22)				// define head, set to x22 reg
			define(offset,x23)				// define offset, set to x23 reg
			define(UI, x24)					// define UI, set to x24 reg
			define(ALLOC, x27)				// define ALLOC, set to x27 reg
			define(DEALLOC, x28)			// define DEALLOC, set to x28 reg
			define(searchVal, w27)			// define searchVal, set to w27 reg
			



 
	.balign 4								// Set 4bit allign
	.global main							// make main visible to the OS
main:
	stp x29, x30, [sp, -16]!				// save fp register and link register current values on stack
	mov x29, sp								// update fp register

//--------------- GETTING UI ---------------//
mssg:
	ldr		x0,		=prompt					// ldr prompt for user
	bl		printf							// call printf
	
	ldr		x0,		=getUI					// ldr getUI string
	ldr		x1,		=intN					// store user input in intN
	bl		scanf							// call scanf
	ldr		x1,		=intN					// ldr intN into x1
	ldr		UI,	[x1]						// store value in x1 into UI
	
	cmp		UI,	0							// if (intN <= 0)
	b.eq	zeroHandle						// branch for UI == 0 case
	b.lt	negHandle						// branch for UI < 0 case
	b		goodUI							// branch for UI > 0 i.e. good input

zeroHandle:
	ldr		x0,		=zeroHand				// ldr zero error string
	bl		printf							// call printf
	b		mssg							// reprompt for UI
negHandle:
	ldr		x0,		=negHand				// ldr negative error string
	bl		printf							// call printf
	b		mssg							// reprompt for UI

	
goodUI:

//---- DYNAMICALLY ALLOCATING FOR ARRAY ----//
	mov		x21,	-4						// store -4 in x21
	mul		x26,	UI,		UI				// (UI^2) this is for calculating the first part of memory needed				
	mul		ALLOC,	x26,	x21				// now take (UI^2) * (-4), this will be our final memory allocated, 4 is negative since we want to go down the stack
	and		ALLOC,	ALLOC,	-16				// alloc /\ -16, this is is for allignment
	neg		DEALLOC,	ALLOC				// now get the positive val of alloc, this will be used to restore our memory used, i.e. free() 


	add 	sp, 	sp,		ALLOC			// allocating memory for NxN array
	mov 	i, 		0						// init i
	mov 	offset, 0						// init the offset
	mov 	head, 	sp						// head of array --> sp
	bl 		clock							// calling clock()
	bl 		srand							// calling srand()


//---- PRINTING AND STORING NxN MATRIX -----//

forloopi:
	cmp 	i, 		UI						// for(i; i < UI; i++)
	b.ge 	search							// break to search when looping done
	mov 	j, 		0						// reset j, for each i loop

forloopj: 
	cmp 	j, 		UI						// for(j; j < UI; j++)
	b.ge 	forjloopdone					// break to jloopdone when current j loop is over
	
	bl 		rand							// call rand()
	and 	randNum, 	w0, 	15			// mod 16

randtest:	
	cmp		randNum,	10					// compare randNum to 10
	b.lt	cont							// if randNum is < 10 then we have our 0-9 range
											// if not generate a randNum untill the range is met
	bl 		rand							// call rand()
	and	 	randNum, 	w0, 	15			// mod 16
	b		randtest						// branch back to range test

cont:
	str 	randNum, 	[head, offset]		// store randNum at head + current integer offset

	ldr 	x0, 	=output					// ldr output string
	mov 	w1, 	randNum					// call randNum stored in w1
	bl 		printf							// call printf

	add 	offset, offset,	 4				// update the offset, since it is an int we just add 4 'bytes'
	add 	j, 	j, 	1						// j++
	b 		forloopj						// j loop again
forjloopdone:
	ldr 	x0, 	=fixOP					// print a new line for next matrix row
	bl 		printf							// call printf

	add i, i, 1								// i++
	b 	forloopi							// i loop again



//------------ SEARCHING MATRIX ------------//
search: 	
	mul		offset,		offset,		xzr		// set offset to 0, i.e arr[0]
	mov		i,			0					// re-init i to 0
	mov		x26,		0					// intit counter for occurences found
	ldr		randNum,	[head,	offset]		// ldr randNum at arr[0]

sPrompt:
	ldr		x0,			=promptsearch		// load prompt for search UI, makes UI look better
	bl		printf							// call printf()
	
	ldr		w0,			=getsearch			// UI prompt
	ldr		w1,			=sVal				// store UI
	bl		scanf							// call scanf()
	ldr		x1,			=sVal				// ldr x1 with sVal
	ldr		searchVal,		[x1]			// ldr contents of x1 into searchVal


	cmp		searchVal,		0				// if searchVal < 0
	b.lt	badUI							// branch to badUI
	
	cmp		searchVal,		9				// if searchVal > 9
	b.gt	badUI							// branch to badUI
	b		goodSearch						// branch to goodUi 

badUI:
	ldr		x0,			=badSput			// prompt for badSput string
	bl		printf							// call printf()
	b		sPrompt							// re prompt for UI

goodSearch:
	ldr		x0,			=searchMess			// ldr searchMess string
	mov		w1,			searchVal			// ouput searchVal, the search val entered
	bl		printf							// call printf

loopi:
	cmp 	i, 			UI					// for(i; i <= UI; i++)
	b.ge 	exit							// if TRUE exit
	mov 	j, 			0					// reset j for j loop

loopj: 
	cmp 	j, 			UI					// for(j; j <= UI; j++)
	b.ge 	jloopdone

	ldr		randNum,	[head,	offset]		// load current array element


	cmp		randNum,	searchVal			// if curr array val == user search val
	b.eq	found							// branch to found branch
	b		update							// branch to update

found:
	add		x26,		x26,		1		// update found counter
	ldr		x0,			=coords				// load coords string
	mov		x1,			x26					// mov found counter into x1
	mov		x2,			i					// mov i index into x2
	mov		x3,			j					// mov j index into x3
	bl		printf							// call printf()
		
update:
	add 	offset, 	offset,	 	4		// update offset, adding 4 'bytes' since we have an integer array
	add 	j, 			j, 			1		// j++
	b 		loopj							// j loop again
jloopdone:

	add 	i, 			i, 			1		// i++
	b 		loopi							// i loop again



//----------------- EXIT -------------------//
exit:
	
	cmp		x26,	0						// if found flag is 0 no match has been found
	b.eq	noFind							// if TRUE branch to noFind 
	b		reprompt						// else branch to reprompt
	

noFind:
	ldr		x0,		=noMatch				// ldr no mathc string
	bl		printf							// call printf()	
	b		reprompt						// branch to reprompt

reprompt:
	ldr		x0,			=rPrompt			// load prompt for search UI, makes UI look better
	bl		printf							// call printf()
	
	ldr		x0,			=getsearch			// UI prompt
	ldr		x1,			=sVal				// store UI
	bl		scanf							// call scanf()
	ldr		x1,		=sVal
	ldr		x25,	[x1]					// ldr x1 contents into x25

	cmp		x25,		1					// if x25 == 1
	b.eq	done							// TRUE then break to done
	b		search							// FALSE branch to search
	
done:
	ldr		x0,			=exitmess			// load prompt for search UI, makes UI look better
	bl		printf							// call printf()

	add 	sp, 		sp, 		DEALLOC // restore memory used by array
	ldp 	x29, 		x30, 		[sp],16 // restore state
	ret										// return to caller

//---------- data section ----------// 
.data
	intN: 	.int 0	
	sVal:   .int 0
