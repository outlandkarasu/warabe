module warabe.renderer.rectangle;

import warabe.color : Color;
import warabe.coodinates : Rectangle;

import warabe.lina.matrix :
    move,
    scale;

import warabe.opengl :
    GLDrawMode,
    IndicesID,
    Mat4,
    OpenGLContext,
    ShaderProgramID,
    UniformLocation,
    VertexArrayID,
    VerticesID;

import std.algorithm : find;
import std.array : empty;

///
struct RectangleBuffer
{
    @disable this();

    this(OpenGLContext context)
    in
    {
        assert(context !is null);
    }
    body
    {
        this.context_ = context;
        this.program_ = context.createShaderProgram(
            import("plane.vert"), import("plane.frag"));
    }

    ~this()
    {
        foreach(ref e; buffers_)
        {
            destroy(e);
        }
        context_.deleteShaderProgram(this.program_);
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    {
        auto found = buffers_.find!((b) => b.hasCapacity);
        if (!found.empty)
        {
            found[0].add(rect, color);
        }
        else
        {
            auto entry = new RectangleBufferEntry(
                context_, program_, CAPACITY);
            scope(failure) destroy(entry);
            buffers_ ~= entry;

            entry.add(rect, color);
        }
    }

    void draw()
    {
        foreach(e; buffers_)
        {
            e.draw();
        }
    }

    void reset()
    {
        foreach(e; buffers_)
        {
            e.reset();
        }
    }

private:

    enum CAPACITY = 4;

    RectangleBufferEntry[] buffers_;
    OpenGLContext context_;
    ShaderProgramID program_;
}

///
unittest
{
    import std.typecons : BlackHole;
    import warabe.coodinates : Point, Size;

    scope context = new BlackHole!OpenGLContext;
    scope buffer = RectangleBuffer(context);
    buffer.add(Rectangle(10, 20, 100, 200), Color(0xff, 0x80, 0x40, 0xff));
    buffer.draw();
    buffer.reset();
}

///
class RectangleBufferEntry
{
    this(OpenGLContext context, ShaderProgramID program, uint capacity)
    {
        this.context_ = context;

        this.vertices_ = context.createVertices!Vertex(
            capacity * VERTICES_PER_RECT);
        scope(failure) context.deleteVertices(this.vertices_);

        this.indices_ = context.createIndices!ushort(
            capacity * INDICES_PER_RECT);
        scope(failure) context.deleteIndices(this.indices_);

        this.vao_ = context.createVAO();
        scope(failure) context.deleteVAO(this.vao_);

        this.capacity_ = capacity;
        this.program_ = program;
        this.mvpLocation_ = context.getUniformLocation(program, MVP_UNIFORM_NAME);

        const viewport = context.getViewport();
        immutable scale = Mat4().scale(2.0f / viewport.width, -2.0f / viewport.height);
        immutable offset = Mat4().move(-1.0f, 1.0f);
        this.mvp_.productAssign(offset, scale);
    }

    @nogc nothrow @property pure @safe bool hasCapacity() const
    {
        return count_ < capacity_;
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    in
    {
        assert(hasCapacity);
    }
    body
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
        context_.copyTo(vertices_, verticesEnd_, vertices);

        // append rect indices.
        scope immutable(ushort)[INDICES_PER_RECT] indices = [
            cast(ushort)(verticesEnd_),
            cast(ushort)(verticesEnd_ + 1),
            cast(ushort)(verticesEnd_ + 2),
            cast(ushort)(verticesEnd_),
            cast(ushort)(verticesEnd_ + 2),
            cast(ushort)(verticesEnd_ + 3),
        ];
        context_.copyTo(indices_, indicesEnd_, indices);

        verticesEnd_ += VERTICES_PER_RECT;
        indicesEnd_ += INDICES_PER_RECT;
        ++count_;
    }

    void draw()
    {
        setUpVAO();
        context_.bind(vao_);
        scope(exit) context_.unbindVAO();

        context_.useProgram(program_);
        scope(exit) context_.unuseProgram();

        context_.uniform(mvpLocation_, mvp_);

        context_.draw!ushort(
            GLDrawMode.triangles,
            cast(uint) indicesEnd_,
            0);
    }

    void reset()
    {
        verticesEnd_ = 0;
        indicesEnd_ = 0;
        count_ = 0;
    }

    ~this()
    {
        this.context_.deleteVertices(this.vertices_);
        this.context_.deleteIndices(this.indices_);
        this.context_.deleteVAO(this.vao_);
    }

private:

    enum
    {
        VERTICES_PER_RECT = 4,
        INDICES_PER_RECT = 6,
        MVP_UNIFORM_NAME = "MVP",
    }

    struct Vertex
    {
        float[3] position;
        ubyte[4] color;
    }

    void setUpVAO()
    {
        context_.bind(vao_);

        context_.bind(vertices_);
        scope(exit) context_.unbindVertices();

        context_.vertexAttributes!(Vertex, float)(
                0, 3, Vertex.init.position.offsetof);
        context_.enableVertexAttributes(0);

        context_.vertexAttributes!(Vertex, ubyte)(
                1, 4, Vertex.init.color.offsetof, true);
        context_.enableVertexAttributes(1);

        context_.bind(indices_);
        scope(exit) context_.unbindIndices();

        context_.unbindVAO();
    }

    OpenGLContext context_;
    VertexArrayID vao_;
    VerticesID vertices_;
    IndicesID indices_;
    ShaderProgramID program_;
    UniformLocation mvpLocation_;
    Mat4 mvp_;
    size_t capacity_;
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

    scope buffer = new RectangleBufferEntry(context, ShaderProgramID(123), 2);
    assert(buffer.hasCapacity);

    buffer.add(
        Rectangle(10, 20, 100, 200),
        Color(0xff, 0x80, 0x40, 0xff));
    assert(buffer.hasCapacity);

    buffer.add(
        Rectangle(10, 20, 100, 200),
        Color(0xff, 0x80, 0x40, 0xff));
    assert(!buffer.hasCapacity);

    buffer.draw();

    buffer.reset();
    assert(buffer.hasCapacity);
}

