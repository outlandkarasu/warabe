/**
SDL application.
*/
module warabe.sdl.application;

import warabe.application : Application;
import warabe.window : WindowFactory;

import warabe.sdl.exception : SDLException;
import warabe.sdl.event: SDLEventLoop;
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
void runApplication(scope void delegate(Application) mainFunction)
{
    immutable loadedVersion = initializeSDL();
    scope(exit) unloadSDL();

    auto windowFactory = new SDLWindowFactory();
    auto eventLoop = new SDLEventLoop();
    auto application = Application(windowFactory, eventLoop);
    mainFunction(application);
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

