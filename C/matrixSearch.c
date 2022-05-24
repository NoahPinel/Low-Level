#include <stdio.h>
#include <stdlib.h>
#include <time.h>
/*
  2022-05-13
  UCID:30159409 
  Noah Pinel
  Assign 1
  
  Topic: basic C concepts, including 2D arrays, random numbers, and searching.
*/


/* 
randomNum Function
This method genrates a random number between n-m inclusive

parameters
- n (Lower bound)
- m (Upper bound)

returns
- A randon int between n-m inclusive.

SOURCE:
Code inspired from http://c-faq.com/lib/randrange.html
*/
int randomNum(int n, int m)
{  
    return rand() % (m - n + 1)+ n;
}


/*
initialize function.
Passing table by refrence to initiliaze, this function is also passed a size
The function then populates the NxN array using the rand() with % 10 to get digits
0 - 9.

parameters
- table (our matrix)
- size (command line fed arg for N size of NxN matrix)

returns
- a pointer table.
*/
void *initialize(int *table, int size)
{
    int i;
    int j;

    
    for (i = 0; i < size; i++)
    {
        for (j = 0; j < size; j++) 
        {
            /* 
                Making sure the offset is correct since this is really just 
                a 1D array in memory, so (i * size) will get the row, then
                adding j will get the col.
            */
            table[i * size + j] = i + j;
            /*
                This outputs the table, it will set current element to a random int 0-9
                rand() is used for this, % 10 will make sure we have our range 0-9, also
                rand() is seeded in main to ensure that we actually get different results
                at each runtime.
            */
            printf("%d ", table[i * size + j] = randomNum(0,9));
        }
        printf("\n");
    }
    return table;
}


/*
display stats function. 
- Display occurences of user provided digit in matrix, outputs coordinates of a match
- find the avg of the user digit compared with the whole matrix.

Parameters
- *table (our matrix)
- size (the command line arg taken for size of NxN)
- digit (the digit the user selected for search)
- digitFound (The number of occurences of digit that was found when search() was ran)
*/
float displayStats(int *table, int size, int digit, int digitFound)
{
    float avg;
    float avgTwo;
    int count;
    int i;
    int j;
    
    count = 1;  
    for(i = 0; i < size; i++)
    {
        for(j = 0; j < size; j++)
        {
           if(digit == table[i * size + j])
           {
               printf("\n%d. In (%d,%d)",count,i,j);
               count++;
           }
        }
    }
    avg = digitFound / (float)(size * size);
    avgTwo = avg * 100;

    return avgTwo;  
}


/*
 exact same function as displayStats except this writes to a file using fprintf
 Seems redundent but I dont know how to do this cleaner.
*/
void displayStatsForLogFile(FILE *fp,int *table, int size, int digit)
{
    int count;
    int i;
    int j;
    
    count = 1;  
    for(i = 0; i < size; i++)
    {
        for(j = 0; j < size; j++)
        {
           if(digit == table[i * size + j])
           {
               fprintf(fp, "\n%d. In (%d,%d)",count,i,j);
               count++;
           }
        }
    }
}


/*
Search function, really simple linear search, checks all elements for a match == digit.

Parameters
- *table (our matrix)
- size (the command line arg taken for size of NxN)
- digit (User provided int that will be searched for)

returns 
- int sum. The sum of all occurnces of U/I digit 
*/
int search(int *table, int size, int digit)
{
    int sum;
    int i;
    int j;
    
    sum = 0;

    for(i = 0; i < size; i++)
    {
        for(j = 0; j < size; j++)
        {
            if(digit == table[i * size + j])
            {
                sum++;
            }
        }
    }
    return sum;
}


/*
LogFile function.
Writes stats to a log file.

Parameters
- *fp (File we are passing in)
- *table (our matrix)
- size (the command line arg taken for size of NxN)
- digit (User provided int that will be searched for)
- digitFound (Returns occurences of digit in matrix)
- digitAvg (returns the avg of the digit compared to the total matrix)

returns 
- int sum. The sum of all occurnces of U/I digit 
*/
void logFile(FILE *fp,int *table, int size, int digit, int digitFound, float digitAvg)
{
    fprintf(fp,"\nUser selected digit = %d", digit);
    digitFound = search(table, size, digit);
    fprintf(fp,"\nDigit %d occurs %d times", digit, digitFound);
    displayStatsForLogFile(fp,table, size, digit);
    fprintf(fp, "\nThe digit %d is %2.0f%% of the matrix\n\n", digit, digitAvg);
}


/*
Driver code, calls all functions, formats, and outputs.
agrc and argv take command line arg, (an integer N is entered) 
for the dim of the NxN matrix.

Parameters
- argc (argument count)
- *arg[] (argument vector)
*/
int main(int argc, char *argv[])
{   
    /* initilizing vars*/
    int i; /*Loop int*/
    int j; /*Loop int*/
    int digit; /* User chosen digit*/
    int size; /* cmdLine arg for NxN matrix*/
    int *table; /* Table pointer */
    int digitFound; /* Returned from search() --> number of occurences*/
    int userContin; /* User decision to continue or leave*/
    float digitavg; /* Returned from display stats --> avg of the digit in the matrix*/
    int flag; /* flag for main while loop*/
    FILE *fp; /*File*/

    /* Opening assign1.log to be wrtiten to*/
    fp = fopen("assign1.log", "w");
    
    /* using time_t to seed rand() --> ensures different results everytime*/
    time_t seed;
    srand((unsigned) time(&seed));



    /*Error handling*/
    if (atoi(argv[1]) <= 0 )
    {
        printf("Error: Invalid arg passed.\n");
        printf("Try entering an integer greater than 0\n");
        return -1;
    }


    /*calling atoi() String arg --> int*/
    size = atoi(argv[1]);
 
    /*
    Becuase malloc will allocate mem at runtime, we need to 
    store it in a pointer, so the addr can be accesed, here 
    we are using table, which will grow based on the command
    line arg size.
    */
    table = (int *)malloc(size * size * sizeof(*table));

    /* Initilize our table*/
    printf("%d x %d matrix\n",size,size);
    printf("------------\n");
    table = initialize(table,size);

    /* Initilize flag for our loop */
    flag = 1;

       
    /*
    Writing table to assign.log, Doing this here b/c if it was in logFile()
    the table would be written every iteration of the loop.
    */
    fprintf(fp,"%d x %d matrix\n", size , size);
    fprintf(fp,"------------\n");
    for(i = 0; i < size; i++)
    {
        for(j = 0; j < size; j++)
        {
            fprintf(fp, "%d ", table[i * size + j]);
        }
        fprintf(fp,"\n");
    }
    
    while(flag)
    {
        /* Prompt for U/I, get digit, call search(), print occurences*/
        printf("\nEnter a digit to search for: ");
        scanf("%d", &digit);
        digitFound = search(table, size, digit);
        printf("Digit %d occurs %d times", digit, digitFound);

        /* Display stats from our table*/
        digitavg = displayStats(table,size,digit,digitFound);
        printf("\nThe digit %d is %2.0f%% of the matrix", digit, digitavg);  


        /* Write to logFile after each iteration (digit chose)*/
        logFile(fp, table, size, digit, digitFound, digitavg);

        /* User stay or leave branches*/
        printf("\nEnter 1 for another search or 0 to exit: ");
        scanf("%d", &userContin);
        if (userContin == 0)
        {
            /* exit message*/
            printf("\nassign1.log wrote to successfully!\n");
            printf("PROGRAM TERMINATED.....\n");
            break;
        }
        else
        {
            
            continue;
        }

    }

    /*Closing file*/
    fprintf(fp, "\n<<<Session ended>>>");
    fclose(fp);
    /* Freeing mem held for table*/
    free(table);
    return 0;
}