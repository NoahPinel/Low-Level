mess1: .string "Number 1 is: %d\n"
mess2: .string "Number 2 is: %d\n"
mess3: .string "The sum is: %d\n"
mess4: .string "%d == %d gj!\n"



                .balign 4   // Set 4bit allign
                .global main


main:   stp     x29,    x30,    [sp,16]!
                mov     x29,    sp

                mov     x19,    20 //x19 holds 20
                mov             x20,    80 //x20 holds 80
                add             x21,    x19,    x20 //x21 holds 20 + 80
                mov     x22,    100 //x22 holds 100

                ldr     x0,     =mess1 // load mess1 into x0
                mov     x1,             x19        // move 20 into x1 for output
                bl              printf             // call printf

                ldr     x0,             =mess2 // same as above
                mov             x1,             x20
                bl              printf

                ldr     x0,             =mess3 // same as above
                mov             x1,             x21
                bl              printf


                cmp             x21,    x22 // (x21 == x22)
                b.ne    endif
                ldr             x0,             =mess4 // if branch is reached output mess 4
                mov             x1,             x21
                mov             x2,             x22
                bl              printf









endif:
                ldp x29, x30, [sp], 16
                ret