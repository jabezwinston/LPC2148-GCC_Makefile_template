/*
 *  Public domain code
 */

#include"lpc214x.h"
#include "delay.h"

int main()
{
    IO0DIR|=(1<<21);
    while(1)
    {
        IO0SET|=(1<<21);
        delay();
        IO0CLR|=(1<<21);
        delay();
    }
}


