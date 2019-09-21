/**
SDL OpenGL module.
*/
module warabe.sdl.opengl;

import sdl = bindbc.sdl;
import bindbc.sdl :
    SDL_GL_CreateContext,
    SDL_GL_DeleteContext,
    SDL_GL_SetAttribute,
    SDL_GL_SetSwapInterval,
    SDL_GL_SwapWindow;

import warabe.sdl.types : Result;
import warabe.sdl.window : Window;

enum GLAttr : sdl.SDL_GLattr
{
    redSize = sdl.SDL_GL_RED_SIZE,
    greenSize = sdl.SDL_GL_GREEN_SIZE,
    blueSize = sdl.SDL_GL_BLUE_SIZE,
    alphaSize = sdl.SDL_GL_ALPHA_SIZE,
    bufferSize = sdl.SDL_GL_BUFFER_SIZE,
    doubleBuffer = sdl.SDL_GL_DOUBLEBUFFER,
    depthSize = sdl.SDL_GL_DEPTH_SIZE,
    stencilSize = sdl.SDL_GL_STENCIL_SIZE,
    accumRedSize = sdl.SDL_GL_ACCUM_RED_SIZE,
    accumGreenSize = sdl.SDL_GL_ACCUM_GREEN_SIZE,
    accumBlueSize = sdl.SDL_GL_ACCUM_BLUE_SIZE,
    accumAlphaSize = sdl.SDL_GL_ACCUM_ALPHA_SIZE,
    stereo = sdl.SDL_GL_STEREO,
    multiSampleBuffers = sdl.SDL_GL_MULTISAMPLEBUFFERS,
    multiSampleSamples = sdl.SDL_GL_MULTISAMPLESAMPLES,
    acceleratedVisual = sdl.SDL_GL_ACCELERATED_VISUAL,
    contextMajorVersion = sdl.SDL_GL_CONTEXT_MAJOR_VERSION,
    contextMinorVersion = sdl.SDL_GL_CONTEXT_MINOR_VERSION,
    contextFlags = sdl.SDL_GL_CONTEXT_FLAGS,
    contextProfileMask = sdl.SDL_GL_CONTEXT_PROFILE_MASK,
    shareWithCurrentContext = sdl.SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
}

enum GLContextFlag : sdl.SDL_GLcontextFlag
{
    debugFlag = sdl.SDL_GL_CONTEXT_DEBUG_FLAG,
    forwardCompatibleFlag = sdl.SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG,
    robustAccessFlag = sdl.SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG,
    resetIsorationFlag = sdl.SDL_GL_CONTEXT_RESET_ISOLATION_FLAG,
}

enum GLProfile : sdl.SDL_GLprofile
{
    core = sdl.SDL_GL_CONTEXT_PROFILE_CORE,
    compatibility = sdl.SDL_GL_CONTEXT_PROFILE_COMPATIBILITY,
    es = sdl.SDL_GL_CONTEXT_PROFILE_ES,
}

enum GLSwapInterval : int
{
    immediate = 0,
    vsync = 1,
    adaptiveVsync = -1,
}

alias GLContext = sdl.SDL_GLContext;

/**
set OpenGL attribute.

Params:
    attribute = OpenGL attribute.
    value = attribute value.
Returns:
    set attribute result.
*/
Result GLSetAttribute(GLAttr attribute, int value) @nogc nothrow
{
    return Result(SDL_GL_SetAttribute(attribute, value));
}

/**
set OpenGL swap interval.

Params:
    interval = swap interval flag..
Returns:
    set interval result.
*/
Result GLSetSwapInterval(GLSwapInterval interval) @nogc nothrow
{
    return Result(SDL_GL_SetSwapInterval(interval));
}

/**
create OpenGL context.

Params:
    window = OpenGL window.
Returns:
    OpenGL context.
*/
GLContext GLCreateContext(Window* window) @nogc nothrow
{
    return SDL_GL_CreateContext(window);
}

/**
delete OpenGL context.

Params:
    context = OpenGL context.
*/
void GLDeleteContext(GLContext context) @nogc nothrow
{
    SDL_GL_DeleteContext(context);
}

/**
swap window.

Params:
    window = target window.
*/
void GLSwapWindow(Window* window) @nogc nothrow
{
    SDL_GL_SwapWindow(window);
}

