/**
Warabe SDL exception.
*/
module warabe.sdl.exception;

import std.string : fromStringz;
import std.traits : Unqual;

import bindbc.sdl : SDL_GetError;

import warabe.exception : WarabeException;
import warabe.sdl.types : Result;

/**
SDL related exception.
*/
class SDLException : WarabeException
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

/**
enforce success SDL function.

Params:
    file = file name.
    line = line number.
    result = SDL function result.
Returns:
    result.
Throws:
    SDLException if result is error.
*/
T enforceSDL(string file = __FILE__, size_t line = __LINE__, T)(T result)
{
    if (isSDLFailed(result))
    {
        immutable message = fromStringz(SDL_GetError()).idup;
        throw new SDLException(message, file, line);
    }
    return result;
}

///
@system unittest
{
    try
    {
        import warabe.sdl : usingSDL;
        immutable result = Result(1);
        usingSDL!({ enforceSDL(result); });
    }
    catch(SDLException e)
    {
        // expected exception.
    }
    catch(Throwable e)
    {
        assert(false, "unexpected exception" ~ e.toString());
    }
}

private:

/**
check SDL function result.

Params:
    result = function result.
Returns:
    true if result is failed.
*/
@nogc nothrow pure @safe
bool isSDLFailed(T)(T result)
{
    static if (is(Unqual!T == Result))
    {
        return result != 0;
    }
    else static if(is(T U : U*))
    {
        return !result;
    }
    else
    {
        static assert(false, "unexpected type. " ~ T.stringof);
    }
}

///
@nogc nothrow pure @safe unittest
{
    assert(!isSDLFailed(Result(0)));
    assert( isSDLFailed(Result(-1)));
    assert( isSDLFailed(Result(1)));

    string value = "abc";
    assert( isSDLFailed(null));
    assert(!isSDLFailed(&value[0]));
}

