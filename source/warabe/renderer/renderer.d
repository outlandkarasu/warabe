module warabe.renderer.renderer;

import warabe.color : Color;
import warabe.coodinates :
    Rectangle;

/**
screen renderer.
*/
struct Renderer
{
    /**
    render a rectangle.

    Params:
        rect = rectangle.
        color = rectangle color.
    Returns:
        this renderer.
    **/
    ref auto rectangle()(auto ref const(Rectangle) rect, Color color)
    {
        return this;
    }

    /**
    render a frame and clear rendering data.
    */
    @nogc nothrow void flush() const
    {
    }
}

