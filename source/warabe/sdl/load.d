/**
SDL load function module.
*/
module warabe.sdl.load;

import std.traits : isCallable;

static import bindbc.sdl;

import warabe.sdl.exception : SdlException;

/**
load SDL library and using it.

Params:
    F = function using SDL.
*/
void usingSdl(alias F)() if (isCallable!F)
{
    loadSdl();

    F();

    scope(exit) unloadSdl();
}

private:

/**
load SDL library.
*/
void loadSdl() @system
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

        throw new SdlException(message);
    }
}

/**
unload SDL library.
*/
void unloadSdl() @system
{
    bindbc.sdl.unloadSDL();
}

