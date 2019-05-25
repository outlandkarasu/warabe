/**
SDL application.
*/
module warabe.sdl.application;

import warabe.window : WindowFactory;
import warabe.sdl.exception : SDLException;
import warabe.sdl.window : SDLWindowFactory;

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
void runApplication(scope void delegate(scope WindowFactory) mainFunction)
{
    immutable loadedVersion = initializeSDL();
    scope(exit) unloadSDL();

    scope windowFactory = new SDLWindowFactory();
    mainFunction(windowFactory);
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

