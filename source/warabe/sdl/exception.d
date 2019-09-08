/**
Warabe SDL exception.
*/
module warabe.sdl.exception;

import warabe.exception : WarabeException;

/**
SDL related exception.
*/
class SdlException : WarabeException
{
    /**
    construct by message.

    Params:
        msg = exception message.
        file = file name.
        line = source line number.
        nextInChain = exception chain.
    */
    @nogc nothrow pure @safe
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

