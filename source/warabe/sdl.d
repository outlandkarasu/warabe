module warabe.sdl;

import std.exception : enforce;
import std.stdio : writefln;
import std.string : fromStringz, toStringz;

import bindbc.sdl :
    loadSDL,
    loadSDLTTF,
    SDL_AddTimer,
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
    SDL_GL_SetSwapInterval,
    SDL_GL_SwapWindow,
    SDL_Init,
    SDL_INIT_EVERYTHING,
    SDL_PollEvent,
    SDL_PushEvent,
    SDL_Quit,
    SDL_QUIT,
    SDL_RemoveTimer,
    SDL_TimerID,
    SDL_UserEvent,
    SDL_USEREVENT,
    SDL_Window,
    SDL_WINDOW_SHOWN,
    SDL_WINDOW_OPENGL,
    SDLSupport,
    sdlSupport,
    SDLTTFSupport,
    sdlTTFSupport,
    Uint32,
    unloadSDL;

import warabe.application :
    Application,
    ApplicationParameters,
    FrameCounter;

import warabe.opengl :
    GLBlendMode,
    GLBufferBit,
    OpenGLContext,
    OpenGLVersion,
    initializeOpenGL;
import warabe.renderer : Renderer;

import warabe.event : EventHandler, EventHandlerResult;
import warabe.exception : WarabeException;

enum WINDOW_FLAGS = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL;

enum FPS_COUNT_INTERVAL_MS = 1000;

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
run SDL main loop.

Params:
    params = application parameters.
    application = application instance..
*/
void runSDL(ref const(ApplicationParameters) params, scope Application application)
{
    initializeSDL();
    scope(exit) finalizeSDL();

    sdlEnforce(SDL_Init(SDL_INIT_EVERYTHING) == 0);
    scope(exit) SDL_Quit();

    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, OpenGLVersion.major);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, OpenGLVersion.minor);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);
    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

    // try adaptive vsync.
    if (SDL_GL_SetSwapInterval(-1) == -1)
    {
        // fallback: normal vsync.
        sdlEnforce(SDL_GL_SetSwapInterval(1));
    }

    auto window = sdlEnforce(SDL_CreateWindow(
        toStringz(params.windowTitle),
        params.windowPositionX,
        params.windowPositionY,
        params.windowWidth,
        params.windowHeight,
        WINDOW_FLAGS));
    scope(exit) SDL_DestroyWindow(window);

    auto sdlGlContext = sdlEnforce(SDL_GL_CreateContext(window));
    scope(exit) SDL_GL_DeleteContext(sdlGlContext);

    scope openGLContext = initializeOpenGL();
    scope(exit) destroy(openGLContext);

    auto timerID = createFPSCountTimer(FPS_COUNT_INTERVAL_MS);
    scope(exit) SDL_RemoveTimer(timerID);

    mainLoop(params, openGLContext, application, window);
}

private:

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
*/
void initializeSDL()
{
    immutable loaded = loadSDL();
    if (loaded != sdlSupport)
    {
        sdlEnforce(loaded != SDLSupport.noLibrary, "SDL library not found.");
        sdlEnforce(loaded != SDLSupport.badLibrary, "SDL bad library.");
    }

    immutable loadedTTF = loadSDLTTF();
    if (loadedTTF != sdlTTFSupport)
    {
        sdlEnforce(loadedTTF != SDLTTFSupport.noLibrary, "SDL_ttf library not found.");
        sdlEnforce(loadedTTF != SDLTTFSupport.badLibrary, "SDL_ttf bad library.");
    }
}

/**
finalize SDL libraries.
*/
void finalizeSDL()
{
    unloadSDL();
}

/// on FPS count event.
extern(C) @nogc nothrow Uint32 onFPSCountTimer(Uint32 interval, void* param)
{
    SDL_Event event;
    event.type = SDL_USEREVENT;
    event.user = SDL_UserEvent(SDL_USEREVENT);
    SDL_PushEvent(&event);
    return interval;
}

///
SDL_TimerID createFPSCountTimer(Uint32 intervalMillis)
{
    auto timerID = SDL_AddTimer(intervalMillis, &onFPSCountTimer, null);
    sdlEnforce(timerID != 0);
    return timerID;
}

/// main loop function.
void mainLoop(
        ref const(ApplicationParameters) params,
        scope OpenGLContext openGLContext,
        scope Application application,
        scope SDL_Window* window)
{
    // set up OpenGL context.
    openGLContext.enableBlend();
    openGLContext.setBlendFunc(GLBlendMode.one, GLBlendMode.oneMinusSrcAlpha);
    openGLContext.viewport(0, 0, params.windowWidth, params.windowHeight);

    auto renderer = Renderer(openGLContext);

    immutable frequency = SDL_GetPerformanceFrequency();
    immutable msPerFrame = 1000.0f / params.fps;
    FrameCounter frameCounter;
    frameCounter.reset(SDL_GetPerformanceCounter());
    for (;; frameCounter.increment())
    {
        immutable start = SDL_GetPerformanceCounter();
        for (SDL_Event e; SDL_PollEvent(&e);)
        {
            // reset fps.
            immutable fps = frameCounter.calculateFramesPerClock(start) * frequency;
            if (e.type == SDL_USEREVENT)
            {
                frameCounter.reset(start);
            }

            final switch(translateEvent(e, application, fps))
            {
                case EventHandlerResult.CONTINUE:
                    break;
                case EventHandlerResult.QUIT:
                    // exit main loop.
                    return;
            }
        }

        // render a frame.
        openGLContext.clearColor(0.0f, 0.0f, 0.0f, 0.0f);
        openGLContext.clear(GLBufferBit.color | GLBufferBit.depth);
        application.draw(renderer);
        renderer.flush();
        SDL_GL_SwapWindow(window);

        immutable elapse = (SDL_GetPerformanceCounter() - start) * 1000.0f / frequency;
        SDL_Delay((msPerFrame > elapse) ? cast(uint)(msPerFrame - elapse) : 0);
    }
}

/**
translate SDL events to Warabe application event.

Params:
    event = SDL event.
    eventHandler = application event handler.
    fps = frame per second.
Returns:
    event handler result.
*/
EventHandlerResult translateEvent(
        ref const(SDL_Event) event,
        scope EventHandler eventHandler,
        float fps)
{
    switch(event.type)
    {
        case SDL_QUIT:
            return eventHandler.onQuit();
        case SDL_USEREVENT:
            return eventHandler.onFPSCount(fps);
        default:
            return EventHandlerResult.CONTINUE;
    }
}

