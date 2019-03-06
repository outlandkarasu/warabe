module warabe.renderer.renderer;

import warabe.color : Color;
import warabe.coodinates : Rectangle;
import warabe.lina.matrix :
    move,
    scale;
import warabe.opengl :
    Mat4,
    OpenGLContext,
    ShaderProgramID;
import warabe.renderer.rectangle : RectangleBuffer;

/**
screen renderer.
*/
struct Renderer
{
    @disable this();
    @disable this(this);

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
    render an ellipse.

    Params:
        bounding = ellipse bounding rectangle.
        color = ellipse color.
    Returns:
        this renderer.
    **/
    ref auto ellipse()(
            auto ref const(Rectangle) bounding,
            auto ref const(Color) color)
    {
        return this;
    }

    /**
    render a frame and clear rendering data.
    */
    void flush()
    {
        Mat4 viewportMatrix;
        calculateViewportMatrix(viewportMatrix);
        rectangleBuffer_.draw(viewportMatrix);
        rectangleBuffer_.reset();
    }

private:

    OpenGLContext context_;
    Mat4 viewportMatrix_;
    RectangleBuffer rectangleBuffer_;

    void calculateViewportMatrix(scope out Mat4 dest)
    {
        const viewport = context_.getViewport();
        immutable scale = Mat4().scale(
            2.0f / viewport.width, -2.0f / viewport.height);
        immutable offset = Mat4().move(-1.0f, 1.0f);
        dest.productAssign(offset, scale);
    }
}

