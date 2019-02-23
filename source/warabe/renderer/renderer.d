module warabe.renderer.renderer;

import warabe.color : Color;
import warabe.coodinates : Rectangle;
import warabe.opengl :
    OpenGLContext,
    ShaderProgramID;
import warabe.renderer.rectangle : RectangleBuffer;

/**
screen renderer.
*/
struct Renderer
{
    /**
    Params:
        context = OpenGL context.
    */
    this(OpenGLContext context)
    in
    {
        assert(context !is null);
    }
    body
    {
        this.context_ = context;
        this.rectangleBuffer_ = RectangleBuffer(context);
    }

    /**
    render a rectangle.

    Params:
        rect = rectangle.
        color = rectangle color.
    Returns:
        this renderer.
    **/
    ref auto rectangle()(
            auto ref const(Rectangle) rect,
            auto ref const(Color) color)
    {
        rectangleBuffer_.add(rect, color);
        return this;
    }

    /**
    render a frame and clear rendering data.
    */
    void flush()
    {
        rectangleBuffer_.draw();
        rectangleBuffer_.reset();
    }

private:

    OpenGLContext context_;
    ShaderProgramID rectangleProgram_;
    RectangleBuffer rectangleBuffer_;
}

