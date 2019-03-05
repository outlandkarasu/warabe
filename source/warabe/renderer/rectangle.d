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
        this.context_ = context;
        this.program_ = context.createShaderProgram(
            import("plane.vert"), import("plane.frag"));
    }

    ~this()
    {
        foreach (ref e; buffers_)
        {
            e.destroy(context_);
        }
        context_.deleteShaderProgram(program_);
    }

    void add()(auto ref const(Rectangle) rect, auto ref const(Color) color)
    {
        foreach (ref e; buffers_)
        {
            if (e.hasCapacity)
            {
                e.add(context_, rect, color);
                return;
            }
        }

        auto entry = RectangleBufferEntry(context_, program_, CAPACITY);
        scope (failure) entry.destroy(context_);
        buffers_ ~= entry;
        entry.add(context_, rect, color);
    }

    void draw()
    {
        foreach (ref e; buffers_)
        {
            e.draw(context_, program_);
        }
    }

    @nogc nothrow @safe void reset()
    {
        foreach (ref e; buffers_)
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

private:

///
struct RectangleBufferEntry
{
    this(scope OpenGLContext context, ShaderProgramID program, uint capacity)
    in
    {
        assert(context !is null);
        assert(capacity > 0);
    }
    body
    {
        this.vertices_ = context.createVertices!Vertex(
            capacity * VERTICES_PER_RECT);
        scope (failure) context.deleteVertices(this.vertices_);

        this.indices_ = context.createIndices!ushort(
            capacity * INDICES_PER_RECT);
        scope (failure) context.deleteIndices(this.indices_);

        this.vao_ = context.createVAO();
        scope (failure) context.deleteVAO(this.vao_);

        this.capacity_ = capacity;
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

    void add(
            scope OpenGLContext context,
            ref const(Rectangle) rect,
            ref const(Color) color)
    in
    {
        assert(context !is null);
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
        context.copyTo(vertices_, verticesEnd_, vertices);

        // append rect indices.
        scope immutable(ushort)[INDICES_PER_RECT] indices = [
            cast(ushort)(verticesEnd_),
            cast(ushort)(verticesEnd_ + 1),
            cast(ushort)(verticesEnd_ + 2),
            cast(ushort)(verticesEnd_),
            cast(ushort)(verticesEnd_ + 2),
            cast(ushort)(verticesEnd_ + 3),
        ];
        context.copyTo(indices_, indicesEnd_, indices);

        verticesEnd_ += VERTICES_PER_RECT;
        indicesEnd_ += INDICES_PER_RECT;
        ++count_;
    }

    void draw(scope OpenGLContext context, ShaderProgramID program)
    in
    {
        assert(context !is null);
    }
    body
    {
        setUpVAO(context);
        context.bind(vao_);
        scope (exit) context.unbindVAO();

        context.useProgram(program);
        scope (exit) context.unuseProgram();

        context.uniform(mvpLocation_, mvp_);

        context.draw!ushort(
            GLDrawMode.triangles,
            cast(uint) indicesEnd_,
            0);
    }

    @nogc nothrow @safe void reset()
    {
        verticesEnd_ = 0;
        indicesEnd_ = 0;
        count_ = 0;
    }

    void destroy(scope OpenGLContext context)
    in
    {
        assert(context !is null);
    }
    body
    {
        if (vertices_)
        {
            context.deleteVertices(vertices_);
            vertices_ = 0;
        }

        if (indices_)
        {
            context.deleteIndices(indices_);
            indices_ = 0;
        }

        if (vao_)
        {
            context.deleteVAO(vao_);
            vao_ = 0;
        }
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

    void setUpVAO(scope OpenGLContext context)
    {
        context.bind(vao_);

        context.bind(vertices_);
        scope (exit) context.unbindVertices();

        context.vertexAttributes!(Vertex, float)(
                0, 3, Vertex.init.position.offsetof);
        context.enableVertexAttributes(0);

        context.vertexAttributes!(Vertex, ubyte)(
                1, 4, Vertex.init.color.offsetof, true);
        context.enableVertexAttributes(1);

        context.bind(indices_);
        scope (exit) context.unbindIndices();

        context.unbindVAO();
    }

    VertexArrayID vao_;
    VerticesID vertices_;
    IndicesID indices_;
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
    immutable program = ShaderProgramID(123);

    scope buffer = new RectangleBufferEntry(context, program, 2);
    assert(buffer.hasCapacity);

    immutable rect1 = Rectangle(10, 20, 100, 200);
    immutable color1 = Color(0xff, 0x80, 0x40, 0xff);
    buffer.add(context, rect1, color1);
    assert(buffer.hasCapacity);

    immutable rect2 = Rectangle(10, 20, 100, 200);
    immutable color2 = Color(0xff, 0x80, 0x40, 0xff);
    buffer.add(context, rect2, color2);
    assert(!buffer.hasCapacity);

    buffer.draw(context, program);

    buffer.reset();
    assert(buffer.hasCapacity);

    buffer.destroy(context);
}

