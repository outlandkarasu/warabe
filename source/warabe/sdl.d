module warabe.sdl;

import std.exception : enforce;
import std.string : fromStringz, toStringz;

import bindbc.sdl :
    loadSDL,
    SDL_GetError,
    SDL_CreateWindow,
    SDL_Delay,
    SDL_DestroyWindow,
    SDL_Event,
    SDL_GetPerformanceCounter,
    SDL_GetPerformanceFrequency,
    SDL_GL_CONTEXT_MAJOR_VERSION,
    SDL_GL_CONTEXT_MINOR_VERSION,
    SDL_GL_CONTEXT_PROFILE_MASK,
    SDL_GL_CONTEXT_PROFILE_CORE,
    SDL_GL_CreateContext,
    SDL_GL_DeleteContext,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_SetAttribute,
    SDL_Init,
    SDL_INIT_EVERYTHING,
    SDL_PollEvent,
    SDL_Quit,
    SDL_QUIT,
    SDL_WINDOW_SHOWN,
    SDL_WINDOW_OPENGL,
    SDLSupport,
    sdlSupport,
    unloadSDL;

import warabe.application : ApplicationParameters;
import warabe.exception : WarabeException;

enum WINDOW_FLAGS = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL;

enum {
    OPEN_GL_MAJOR_VERSION = 3,
    OPEN_GL_MINOR_VERSION = 3
}

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

/**
run SDL main loop.

Params:
    params = application parameters.
*/
void runSDL(ref const(ApplicationParameters) params)
{
    initializeSDL();
    scope(exit) finalizeSDL();

    sdlEnforce(SDL_Init(SDL_INIT_EVERYTHING) == 0);
    scope(exit) SDL_Quit();

    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, OPEN_GL_MAJOR_VERSION);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, OPEN_GL_MINOR_VERSION);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

    auto window = sdlEnforce(SDL_CreateWindow(
        toStringz(params.windowTitle),
        params.windowPositionX,
        params.windowPositionY,
        params.windowWidth,
        params.windowHeight,
        WINDOW_FLAGS));
    scope(exit) SDL_DestroyWindow(window);

    auto openGlContext = sdlEnforce(SDL_GL_CreateContext(window));
    scope(exit) SDL_GL_DeleteContext(openGlContext);

    immutable frequency = SDL_GetPerformanceFrequency();
    immutable msPerFrame = 1000.0 / params.fps;

    // main loop
    for(;;)
    {
        immutable start = SDL_GetPerformanceCounter();
        for(SDL_Event e; SDL_PollEvent(&e);)
        {
            switch(e.type)
            {
                case SDL_QUIT:
                    return;
                default:
                    break;
            }
        }
        immutable elapse = (SDL_GetPerformanceCounter() - start) * 1000.0 / frequency;
        SDL_Delay((msPerFrame > elapse) ? cast(uint)(msPerFrame - elapse) : 0);
    }
}

