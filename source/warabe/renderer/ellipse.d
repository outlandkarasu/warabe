module warabe.renderer.ellipse;

import warabe.color : Color;
import warabe.coodinates : Rectangle;

import warabe.opengl :
    Mat4,
    OpenGLContext;

import warabe.renderer.buffer :
    PrimitiveBuffer,
    VertexAttributeType;

package:

///
struct EllipseBuffer
{
    @disable this();
    @disable this(this);

    this(OpenGLContext context)
    in
    {
        assert(context !is null);
    }
    body
    {
        buffer_ = Buffer(
                context,
                import("plane.vert"),
                import("plane.frag"),
                CAPACITY);
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    {
        // append rect vertices.
        scope immutable(ubyte)[4] colorArray = [
            color.red, color.green, color.blue, color.alpha];
        scope immutable(Vertex)[VERTICES_PER_ELLIPSE] vertices = [
            { [rect.left, rect.top, 0.0f], colorArray },
            { [rect.right, rect.top, 0.0f], colorArray },
            { [rect.right, rect.bottom, 0.0f], colorArray },
            { [rect.left, rect.bottom, 0.0f], colorArray },
        ];

        // append rect indices.
        scope immutable(uint)[INDICES_PER_ELLIPSE] indices = [
            0, 1, 2,
            0, 2, 3,
        ];

        buffer_.add(vertices, indices);
    }

    void draw(ref const(Mat4) viewportMatrix)
    {
        buffer_.draw(viewportMatrix);
    }

    @nogc nothrow @safe void reset()
    {
        buffer_.reset();
    }

private:

    enum {
        CAPACITY = 4,
        VERTICES_PER_ELLIPSE = 4,
        INDICES_PER_ELLIPSE = 6,
    }

    struct Vertex
    {
        float[3] position;

        @(VertexAttributeType.normalized)
        ubyte[4] color;
    }

    alias Buffer = PrimitiveBuffer!(
            Vertex, VERTICES_PER_ELLIPSE, INDICES_PER_ELLIPSE);

    Buffer buffer_;
}

