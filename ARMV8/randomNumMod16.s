//This will compile, then spit out 1 random number
//the range is 1-15.


mess1:          .string "%ld\n"
                
                .balign 4   // Set 4bit allign
                .global main


main:   stp     x29,    x30,    [sp,16]!
                mov     x29,    sp


                mov     x0,             0               // init x0, rand will be stored in this reg
                bl              time                    // call time()
                bl              srand                   // call srand() seeding rand
                bl              rand                    // call rand()
                mov             x19,    x0              // store rand in x19
                mov             x22,    16              // init x22 for mod 16 ie range 1-15
                //mov           x23,    0 //counter i=0

getRand:
                udiv    x20,    x19,    x22             // formula for getting remainder
                msub    x21,    x20,    x22,            x19

//loop:
                //cmp           x23,    20
                //b.eq  exit

                ldr             x0,             =mess1                  // load mess1
                mov             x1,             x21                             // load the remainder from the calc i.e our random number 1-15
                bl              printf
                //add           x23,    x23,    1
                //b             loop


exit:
                ldp x29, x30, [sp], 16
                ret