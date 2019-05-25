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
    Window create()(
            scope const(char)[] title,
            scope auto ref const(Position) position,
            scope auto ref const(Size) size)
    out(window)
    {
        assert(window);
    }
    body
    {
        return createImpl(title, position, size);
    }

    /**
    create a window.

    Params:
        title = window title.
        size = window size.
    */
    protected Window createImpl(
            scope const(char)[] title,
            scope ref const(Position) position,
            scope ref const(Size) size)
    out(window)
    {
        assert(window);
    }
}

