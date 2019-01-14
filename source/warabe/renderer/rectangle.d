module warabe.renderer.rectangle;

import warabe.color : Color;

import bindbc.opengl :
    glDeleteBuffers,
    glGenBuffers,
    GLuint;

struct VertexPosition
{
    float x;
    float y;
    float z;
}

///
class RectangleBuffer
{
    this(size_t length)
    {
        glGenBuffers(1, &buffer_);
    }

    ~this()
    {
        glDeleteBuffers(1, &buffer_);
    }

private:

    struct Vertex
    {
        VertexPosition position;
        Color color;
    }

    GLuint buffer_;
}

