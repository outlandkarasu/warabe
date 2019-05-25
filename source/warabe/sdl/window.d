/**
SDL window module.
*/
module warabe.sdl.window;

import warabe.opengl : OpenGLContext;
import warabe.primitives : Position, Size;
import warabe.sdl.exception : enforceSDL;
import warabe.window : Window, WindowFactory;

import bindbc.sdl :
    SDL_CreateWindow,
    SDL_DestroyWindow,
    SDL_Window,
    SDL_WINDOW_OPENGL,
    SDL_WINDOW_SHOWN
;

import std.string : toStringz;

/**
SDL window factory.
*/
class SDLWindowFactory : WindowFactory
{
    protected override Window createImpl(
            scope const(char)[] title,
            scope ref const(Position) position,
            scope ref const(Size) size)
    {
        auto windowTitle = toStringz(title);
        auto windowPointer = enforceSDL(SDL_CreateWindow(
                    windowTitle,
                    position.x,
                    position.y,
                    size.width,
                    size.height,
                    SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN));
        scope(failure) SDL_DestroyWindow(windowPointer);
        return new SDLWindow(windowPointer);
    }
}

private:

/**
SDL window.
*/
class SDLWindow : Window
{
    /**
    construct by SDL window.

    Params:
        window = window pointer.
    */
    @nogc nothrow pure @safe this(SDL_Window* window)
    in
    {
        assert(window);
    }
    body
    {
        this.window = window;
    }

    /**
    destruct window.
    */
    ~this() @nogc nothrow
    {
        if (window)
        {
            SDL_DestroyWindow(window);
            window = null;
        }
    }

    override OpenGLContext create(int majorVersion, int minorVersion)
    {
        return null;
    }

private:
    SDL_Window* window;
}

