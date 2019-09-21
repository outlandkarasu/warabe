/**
Warabe initialize function module.
*/
module warabe.initialize;

import std.traits : isCallable;

import warabe.sdl :
    enforceSDL,
    init,
    quit,
    InitFlags,
    usingSDL;

/**
initialize Warabe and using it.

Params:
    F = function using Warabe.
*/
void usingWarabe(alias F)() if (isCallable!F)
{
    usingSDL!({
        enforceSDL(init(InitFlags.everything));
        scope(exit) quit();

        F();
    });
}

