/**
Window module.
*/
module warabe.window;

import warabe.opengl : OpenGLContext;
import warabe.primitives : Position, Size;

/**
Window interface.
*/
interface Window
{
    /**
    create OpenGL context.

    Params:
        majorVersion = OpenGL major version.
        minorVersion = OpenGL minor version.
    Returns:
        OpenGL context.
    */
    OpenGLContext create(int majorVersion, int minorVersion)
    out(context)
    {
        assert(context);
    }
}

/**
Window factory interface.
*/
interface WindowFactory
{
    /**
    create a window.

    Params:
        title = window title.
        size = window size.
    */
    Window create(
            scope const(char)[] title,
            scope ref const(Position) position,
            scope ref const(Size) size)
    out(window)
    {
        assert(window);
    }
}

