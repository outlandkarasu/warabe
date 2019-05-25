/**
OpenGL screen module.
*/
module warabe.opengl.screen;

import warabe.primitives : Position, Size;

/**
OpenGL screen options interface.
*/
interface OpenGLScreen
{
    /**
    set screen viewport.

    Params:
        position = viewport offset position.
        size = viewport size.
    */
    void setViewport(
            scope ref const(Position) position,
            scope ref const(Size) size);
}

