/**
SDL types.
*/
module warabe.sdl.types;

import std.typecons : Typedef;

/**
SDL result type.
*/
alias Result = Typedef!(uint, uint.init, "warabe.sdl.types.Result");

