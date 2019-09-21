/**
SDL load function module.
*/
module warabe.sdl.load;

import std.traits : isCallable;

static import bindbc.sdl;

import warabe.sdl.exception : SDLException;

/**
load SDL library and using it.

Params:
    F = function using SDL.
*/
void usingSDL(alias F)() if(isCallable!F)
{
    loadSDL();
    scope(exit) unloadSDL();

    F();
}

private:

/**
load SDL library.
*/
void loadSDL() @system
{
    immutable loadedVersion = bindbc.sdl.loadSDL();
    if (loadedVersion != bindbc.sdl.sdlSupport)
    {
        string message = "unknown error.";
        if (loadedVersion == bindbc.sdl.SDLSupport.noLibrary)
        {
            message = "SDL2 not found.";
        }
        else if (loadedVersion == bindbc.sdl.SDLSupport.badLibrary)
        {
            message = "SDL2 bad library.";
        }

        throw new SDLException(message);
    }
}

/**
unload SDL library.
*/
void unloadSDL() @system
{
    bindbc.sdl.unloadSDL();
}

