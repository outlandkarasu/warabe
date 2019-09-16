/**
Warabe initialize function module.
*/
module warabe.initialize;

import std.traits : isCallable;

import warabe.sdl :
    enforceSdl,
    init,
    quit,
    InitFlags,
    usingSdl;

/**
initialize Warabe and using it.

Params:
    F = function using Warabe.
*/
void usingWarabe(alias F)() if (isCallable!F)
{
    usingSdl!({
        enforceSdl(init(InitFlags.everything));
        scope(exit) quit();

        F();
    });
}

