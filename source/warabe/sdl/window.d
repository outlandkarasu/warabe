/**
Window module.
*/
module warabe.sdl.window;

import bindbc.sdl :
    SDL_CreateWindow,
    SDL_DestroyWindow;

import bindbc.sdl :
    SDL_WINDOW_FULLSCREEN,
    SDL_WINDOW_FULLSCREEN_DESKTOP,
    SDL_WINDOW_OPENGL,
    SDL_WINDOW_HIDDEN,
    SDL_WINDOW_BORDERLESS,
    SDL_WINDOW_RESIZABLE,
    SDL_WINDOW_MINIMIZED,
    SDL_WINDOW_MAXIMIZED,
    SDL_WINDOW_INPUT_GRABBED,
    SDL_WINDOW_SHOWN;

import bindbc.sdl :
    SDL_WINDOWPOS_CENTERED,
    SDL_WINDOWPOS_UNDEFINED;

import bindbc.sdl :
    SDL_Window,
    SDL_WindowFlags,
    Uint32;

/**
Window type.
*/
alias Window = SDL_Window;

/**
Window flags.
*/
enum WindowFlags : SDL_WindowFlags
{
    fullscrenn = SDL_WINDOW_FULLSCREEN,
    fullscreenDesktop = SDL_WINDOW_FULLSCREEN_DESKTOP,
    openGL = SDL_WINDOW_OPENGL,
    hidden = SDL_WINDOW_HIDDEN,
    borderless = SDL_WINDOW_BORDERLESS,
    resizable = SDL_WINDOW_RESIZABLE,
    minimized = SDL_WINDOW_MINIMIZED,
    maximized = SDL_WINDOW_MAXIMIZED,
    inputGrabbed = SDL_WINDOW_INPUT_GRABBED,
    shown = SDL_WINDOW_SHOWN,
}

/**
Window position constants.
*/
enum WindowPos : int
{
    centered = SDL_WINDOWPOS_CENTERED,
    undefined = SDL_WINDOWPOS_UNDEFINED,
}

/**
Create a window.

Params:
    tile = window title.
    x = window position x.
    y = window position y.
    w = window width.
    h = window height.
    flags = window flags.
*/
Window* createWindow(
        scope const(char)* title,
        int x,
        int y,
        int w,
        int h,
        WindowFlags flags) @nogc nothrow
{
    return SDL_CreateWindow(title, x, y, w, h, flags);
}

/**
Destroy window.

Params:
    window = destroy window and clear pointer.
*/
void destroyWindow(scope ref Window* window) @nogc nothrow
{
    SDL_DestroyWindow(window);
    window = null;
}

