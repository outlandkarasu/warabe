/**
SDL exception module.
*/
module warabe.sdl.exception;

import std.traits : isIntegral, isPointer;
import std.string : fromStringz;

import bindbc.sdl : SDL_GetError;

/**
 *  SDL error exception.
 */
class SDLException : Exception
{
    /**
     *  Params:
     *      msg = error message
     *      file = file name
     *      line = line number
     */
    pure nothrow @nogc @safe this(
            string msg,
            string file = __FILE__,
            size_t line = __LINE__)
    {
        super(msg, file, line);
    }
}

/**
 *  check SDL functions error.
 *
 *  Params:
 *      T = result type
 *      file = file name
 *      line = line number
 *      value = result value
 *  Returns:
 *      result value.
 *  Throws: SdlException if result has error.
 */
T enforceSDL(T, string file = __FILE__, ulong line = __LINE__)(T value)
{
    static if (is(T == bool))
    {
        immutable hasError = !value;
    }
    else static if (isIntegral!T)
    {
        immutable hasError = (value != 0);
    }
    else static if (isPointer!T)
    {
        immutable hasError = (value is null);
    }
    else
    {
        static assert(false, "unsupported type. " ~ T.stringof);
    }

    if(hasError)
    {
        throw new SDLException(fromStringz(SDL_GetError()).idup, file, line);
    }
    return value;
}

