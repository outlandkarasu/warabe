/**
SDL initialize function module.
*/
module warabe.sdl.initialize;

import std.traits : isCallable;

import bindbc.sdl : loadSDL, sdlSupport, SDLSupport, unloadSDL;

import warabe.sdl.exception : SdlException;

/**
initialize SDL library and using it.

Params:
    F = function using SDL.
*/
void usingSdl(alias F)() if (isCallable!F)
{
    initializeSdl();

    F();

    scope(exit) finalizeSdl();
}

private:

/**
initialize SDL library.
*/
void initializeSdl() @system
{
    immutable loadedVersion = loadSDL();
    if (loadedVersion != sdlSupport)
    {
        string message = "unknown error.";
        if (loadedVersion == SDLSupport.noLibrary)
        {
            message = "SDL2 not found.";
        }
        else if (loadedVersion == SDLSupport.badLibrary)
        {
            message = "SDL2 bad library.";
        }

        throw new SdlException(message);
    }
}

/**
finalize SDL library.
*/
void finalizeSdl() @system
{
    unloadSDL();
}

