module warabe.application;

import warabe.sdl :
    initializeSDL,
    finalizeSDL,
    sdlEnforce;

import bindbc.sdl :
    SDL_CreateWindow,
    SDL_Delay,
    SDL_DestroyWindow,
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
    SDL_Quit,
    SDL_WINDOW_SHOWN,
    SDL_WINDOW_OPENGL;

enum {
    WINDOW_POS_X = 0,
    WINDOW_POS_Y = 0,
    WINDOW_WIDTH = 800,
    WINDOW_HEIGHT = 600,
}

enum WINDOW_TITLE = "Warabe";

enum WINDOW_FLAGS = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL;

enum {
    OPEN_GL_MAJOR_VERSION = 3,
    OPEN_GL_MINOR_VERSION = 3
}

/**
running warabe application.

Params:
    args = command line arguments.
*/
void run(string[] args)
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
        WINDOW_TITLE,
        WINDOW_POS_X,
        WINDOW_POS_Y,
        WINDOW_WIDTH,
        WINDOW_HEIGHT,
        WINDOW_FLAGS));
    scope(exit) SDL_DestroyWindow(window);

    auto openGlContext = sdlEnforce(SDL_GL_CreateContext(window));
    scope(exit) SDL_GL_DeleteContext(openGlContext);

    SDL_Delay(5000);
}

