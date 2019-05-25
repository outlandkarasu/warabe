/**
SDL application.
*/
module warabe.sdl.application;

import warabe.sdl.exception : SDLException;

import bindbc.sdl :
    loadSDL,
    sdlSupport,
    SDLSupport,
    unloadSDL
;

/**
run SDL application.

Params:
    mainFunction = application main function.
Throws:
    SDLException if failed.
*/
void runApplication(scope void delegate() mainFunction)
{
    immutable loadedVersion = initializeSDL();
    scope(exit) unloadSDL();

    mainFunction();
}

private:

/**
initialize SDL libraries.

Returns:
    loaded SDL version.
Throws:
    SDLException if failed.
*/
SDLSupport initializeSDL()
{
    immutable loadedVersion = loadSDL();
    if (loadedVersion != sdlSupport)
    {
        if (loadedVersion == SDLSupport.noLibrary)
        {
            throw new SDLException("SDL2 not found.");
        }
        else if (loadedVersion == SDLSupport.badLibrary)
        {
            throw new SDLException("SDL2 bad library.");
        }
    }
    return loadedVersion;
}

