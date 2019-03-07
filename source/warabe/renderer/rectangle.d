module warabe.renderer.rectangle;

import warabe.color : Color;
import warabe.coodinates : Rectangle;

import warabe.opengl :
    Mat4,
    OpenGLContext;

import warabe.renderer.buffer : PrimitiveBuffer;

package:

///
struct RectangleBuffer
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
        scope immutable(Vertex)[VERTICES_PER_RECT] vertices = [
            { [rect.left, rect.top, 0.0f], colorArray },
            { [rect.right, rect.top, 0.0f], colorArray },
            { [rect.right, rect.bottom, 0.0f], colorArray },
            { [rect.left, rect.bottom, 0.0f], colorArray },
        ];

        // append rect indices.
        scope immutable(uint)[INDICES_PER_RECT] indices = [
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

    enum
    {
        CAPACITY = 4,
        VERTICES_PER_RECT = 4,
        INDICES_PER_RECT = 6,
    }

    struct Vertex
    {
        float[3] position;
        ubyte[4] color;
    }

    alias Buffer = PrimitiveBuffer!(
            Vertex, VERTICES_PER_RECT, INDICES_PER_RECT);

    Buffer buffer_;
}

///
unittest
{
    import std.typecons : BlackHole;
    import warabe.coodinates : Point, Size;

    scope context = new BlackHole!OpenGLContext;
    scope buffer = RectangleBuffer(context);
    immutable viewport = Mat4();
    buffer.add(Rectangle(10, 20, 100, 200), Color(0xff, 0x80, 0x40, 0xff));
    buffer.draw(viewport);
    buffer.reset();
}

