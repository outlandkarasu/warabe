/**
Timer module.
*/
module warabe.sdl.timer;

import bindbc.sdl : SDL_Delay;

/**
Delay timer.

Params:
    ms = milliseconds.
*/
void delay(uint ms) @nogc nothrow
{
    SDL_Delay(ms);
}

