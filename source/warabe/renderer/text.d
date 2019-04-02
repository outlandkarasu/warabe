module warabe.renderer.text;

import warabe.color : Color;

import warabe.opengl :
    Mat4,
    OpenGLContext;

import warabe.renderer.buffer :
    PrimitiveBuffer,
    VertexAttributeType;

package:

///
struct TextBuffer
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
                import("ellipse.vert"),
                import("ellipse.frag"),
                CAPACITY);
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    {
        // append rect vertices.
        scope immutable(ubyte)[4] colorArray = [
            color.red, color.green, color.blue, color.alpha];
        scope immutable(Vertex)[VERTICES_PER_TEXT] vertices = [
            { [rect.left, rect.top, 0.0f], colorArray, [0, 0] },
            { [rect.right, rect.top, 0.0f], colorArray, [ubyte.max, 0] },
            { [rect.right, rect.bottom, 0.0f], colorArray, [ubyte.max, ubyte.max] },
            { [rect.left, rect.bottom, 0.0f], colorArray, [0, ubyte.max] },
        ];

        // append rect indices.
        scope immutable(uint)[INDICES_PER_TEXT] indices = [
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
        VERTICES_PER_TEXT = 4,
        INDICES_PER_TEXT = 6,
    }

    struct Vertex
    {
        float[3] position;

        @(VertexAttributeType.normalized)
        ubyte[4] color;

        @(VertexAttributeType.normalized)
        ubyte[2] localPosition;
    }

    alias Buffer = PrimitiveBuffer!(
            Vertex, VERTICES_PER_TEXT, INDICES_PER_TEXT);

    Buffer buffer_;
}

