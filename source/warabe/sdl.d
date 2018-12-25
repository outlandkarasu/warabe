module warabe.sdl;

import std.exception : enforce;
import std.string : fromStringz;

import bindbc.sdl :
    loadSDL,
    SDL_GetError,
    SDLSupport,
    sdlSupport,
    unloadSDL;

import warabe.exception : WarabeException;

/**
SDL related exception.
*/
class SDLException : WarabeException
{
    /// constructor from super class.
    pure nothrow @nogc @safe this(
            string msg,
            string file = __FILE__,
            size_t line = __LINE__,
            Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

/**
Returns:
    last SDL error string.
*/
nothrow @nogc @system const(char)[] sdlGetError()
{
    return fromStringz(SDL_GetError());
}

/// enforce function for SDL.
T sdlEnforce(T)(T value, lazy const(char)[] msg, string file = __FILE__, size_t line = __LINE__)
{
    return enforce!SDLException(value, msg, file, line);
}

/// ditto
T sdlEnforce(T)(T value, string file = __FILE__, size_t line = __LINE__)
{
    return sdlEnforce(value, sdlGetError, file, line);
}

/**
Initialize SDL library.

Returns:
    loaded version.
*/
SDLSupport initializeSDL()
{
    immutable loaded = loadSDL();
    if (loaded != sdlSupport)
    {
        sdlEnforce(loaded != SDLSupport.noLibrary, "library not found.");
        sdlEnforce(loaded != SDLSupport.badLibrary, "bad library.");
    }
    return loaded;
}

/**
finalize SDL libraries.
*/
void finalizeSDL()
{
    unloadSDL();
}

