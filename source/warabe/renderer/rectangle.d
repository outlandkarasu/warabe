module warabe.renderer.rectangle;

import warabe.color : Color;
import warabe.opengl :
    OpenGLContext,
    VerticesID,
    IndicesID;

struct VertexPosition
{
    float x;
    float y;
    float z;
}

///
class RectangleBuffer
{
    this(OpenGLContext context, uint length)
    {
        this.context_ = context;
        this.vertices_ = context.createVertices!Vertex(length);
        this.indices_ = context.createIndices!ushort(length);
    }

    ~this()
    {
        this.context_.deleteVertices(this.vertices_);
        this.context_.deleteIndices(this.indices_);
    }

private:

    struct Vertex
    {
        VertexPosition position;
        Color color;
    }

    OpenGLContext context_;
    VerticesID vertices_;
    IndicesID indices_;
}

///
unittest
{
    import std.typecons : BlackHole;
    scope context = new BlackHole!OpenGLContext;

    scope buffer = new RectangleBuffer(context, 1024);
}

