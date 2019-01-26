module warabe.renderer.rectangle;

import warabe.color : Color;
import warabe.coodinates : Rectangle;
import warabe.opengl :
    GLDrawMode,
    OpenGLContext,
    VerticesID,
    IndicesID;

///
class RectangleBufferEntry
{
    this(OpenGLContext context, uint count)
    {
        this.context_ = context;
        this.vertices_ = context.createVertices!Vertex(
            count * VERTICES_PER_RECT);
        this.indices_ = context.createIndices!ushort(
            count * INDICES_PER_RECT);
        this.count_ = count;
    }

    @nogc nothrow @property pure @safe bool hasCapacity() const
    {
        return verticesEnd_ < (count_ * VERTICES_PER_RECT);
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    in(hasCapacity)
    do
    {
        scope immutable(ubyte)[4] colorArray = [
            color.red, color.green, color.blue, color.alpha];
        scope immutable(Vertex)[VERTICES_PER_RECT] vertices = [
            { [rect.left, rect.top, 0.0f], colorArray },
            { [rect.right, rect.top, 0.0f], colorArray },
            { [rect.right, rect.bottom, 0.0f], colorArray },
            { [rect.left, rect.bottom, 0.0f], colorArray },
        ];
        context_.copyTo(vertices_, verticesEnd_, vertices);
        verticesEnd_ += VERTICES_PER_RECT;

        scope immutable(ushort)[INDICES_PER_RECT] indices = [
            cast(ushort)(indicesEnd_),
            cast(ushort)(indicesEnd_ + 1),
            cast(ushort)(indicesEnd_ + 2),
            cast(ushort)(indicesEnd_),
            cast(ushort)(indicesEnd_ + 2),
            cast(ushort)(indicesEnd_ + 3),
        ];
        context_.copyTo(indices_, indicesEnd_, indices);
        indicesEnd_ += INDICES_PER_RECT;
    }

    void draw()
    {
        context_.vertexAttributes!(Vertex, float)(
                0, 3, Vertex.init.position.offsetof);
        context_.enableVertexAttributes(0);
        scope(exit) context_.disableVertexAttributes(0);

        context_.bind(vertices_);
        scope(exit) context_.unbindVertices();

        context_.vertexAttributes!(Vertex, ubyte)(
                1, 4, Vertex.init.color.offsetof, true);
        context_.enableVertexAttributes(1);
        scope(exit) context_.disableVertexAttributes(1);

        context_.bind(indices_);
        scope(exit) context_.unbindIndices();

        context_.draw(GLDrawMode.triangles, 0, cast(uint) indicesEnd_);
    }

    ~this()
    {
        this.context_.deleteVertices(this.vertices_);
        this.context_.deleteIndices(this.indices_);
    }

private:

    enum
    {
        VERTICES_PER_RECT = 4,
        INDICES_PER_RECT = 6,
    }

    struct Vertex
    {
        float[3] position;
        ubyte[4] color;
    }

    OpenGLContext context_;
    VerticesID vertices_;
    IndicesID indices_;
    size_t count_;
    size_t verticesEnd_;
    size_t indicesEnd_;
}

///
unittest
{
    import std.typecons : BlackHole;
    import warabe.coodinates : Point, Size;

    scope context = new BlackHole!OpenGLContext;

    scope buffer = new RectangleBufferEntry(context, 1);
    assert(buffer.hasCapacity);

    buffer.add(
        Rectangle(Point(10, 20), Size(100, 200)),
        Color(0xff, 0x80, 0x40, 0xff));
    assert(!buffer.hasCapacity);

    buffer.draw();
}

