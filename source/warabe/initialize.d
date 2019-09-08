/**
Warabe initialize function module.
*/
module warabe.initialize;

import std.traits : isCallable;

import warabe.sdl.initialize : usingSdl;

/**
initialize Warabe and using it.

Params:
    F = function using Warabe.
*/
void usingWarabe(alias F)() if (isCallable!F)
{
    usingSdl!F;
}

