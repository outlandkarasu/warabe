module warabe.renderer.buffer;

import std.traits :
    FieldNameTuple,
    ForeachType,
    hasUDA,
    isArray, 
    isIntegral,
    Unqual;

import warabe.color : Color;

import warabe.opengl :
    GLDrawMode,
    GLTextureUnit,
    GLTextureParameterTarget,
    IndicesID,
    Mat4,
    OpenGLContext,
    ShaderProgramID,
    TextureID,
    UniformLocation,
    VertexArrayID,
    VerticesID;

package:

enum VIEWPORT_MATRIX_UNIFORM_NAME = "viewport";

enum VertexAttributeType
{
    normalized
}

/**
 *  primitives buffer structure template.
 *
 *  Params:
 *      Vertex = vetex type.
 *      verticesCount = vertices count par a primitive.
 *      indicesCount = indices count par a primitive.
 */
struct PrimitiveBuffer(Vertex, uint verticesCount, uint indicesCount)
{
    @disable this();
    @disable this(this);

    this(
        OpenGLContext context,
        scope const(char)[] vertexShader,
        scope const(char)[] fragmentShader,
        size_t capacity)
    in
    {
        assert(context !is null);
    }
    body
    {
        this.context_ = context;
        this.program_ = context.createShaderProgram(
            vertexShader, fragmentShader);
        this.capacity_ = capacity;
        this.viewportMatrixLocation_ = context.getUniformLocation(
            this.program_, VIEWPORT_MATRIX_UNIFORM_NAME);
    }

    ~this()
    {
        foreach (ref e; buffers_)
        {
            e.destroy(context_);
        }
        context_.deleteShaderProgram(program_);
    }

    void setTexture(TextureID texture)
    {
        if (texture_ != texture && buffers_.length > 0)
        {
            texture_ = texture;
            addBuffer();
        }
        else
        {
            texture_ = texture;
        }
    }

    void clearTexture()
    {
        setTexture(TextureID(0));
    }

    void add(
            scope const(Vertex)[] vertices,
            scope const(uint)[] indices)
    in
    {
        assert(vertices.length == verticesCount);
        assert(indices.length == indicesCount);
    }
    body
    {
        if (buffers_.length == 0 || !buffers_[$ - 1].hasCapacity)
        {
            addBuffer();
        }
        buffers_[$ - 1].add(context_, vertices, indices);
    }

    void draw(ref const(Mat4) viewportMatrix)
    {
        foreach (ref e; buffers_)
        {
            e.draw(context_,
                    program_,
                    viewportMatrix,
                    viewportMatrixLocation_);
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

    alias BufferEntry = PrimitiveBufferEntry!(
            Vertex, verticesCount, indicesCount);

    void addBuffer()
    out
    {
        assert(buffers_.length > 0);
        assert(buffers_[$ - 1].hasCapacity);
    }
    body
    {
        buffers_.length += 1;
        scope(failure) buffers_.length -= 1;
        buffers_[$ - 1] = BufferEntry(context_, texture_, capacity_);
    }

    OpenGLContext context_;
    ShaderProgramID program_;
    TextureID texture_;
    size_t capacity_;
    UniformLocation viewportMatrixLocation_;
    BufferEntry[] buffers_;
}

private:

///
struct PrimitiveBufferEntry(Vertex, uint verticesCount, uint indicesCount)
{
    this(
        scope OpenGLContext context,
        TextureID texture,
        size_t capacity)
    in
    {
        assert(context !is null);
        assert(capacity > 0);
    }
    body
    {
        this.vertices_ = context.createVertices!Vertex(
            cast(uint)(capacity * verticesCount));
        scope (failure) context.deleteVertices(this.vertices_);

        this.indices_ = context.createIndices!ushort(
            cast(uint)(capacity * indicesCount));
        scope (failure) context.deleteIndices(this.indices_);

        this.vao_ = context.createVAO();
        scope (failure) context.deleteVAO(this.vao_);

        this.texture_ = texture;
        this.capacity_ = capacity;
    }

    @nogc nothrow @property pure @safe bool hasCapacity() const
    {
        return count_ < capacity_;
    }

    void add(
            scope OpenGLContext context,
            scope const(Vertex)[] vertices,
            scope const(uint)[] indices)
    in
    {
        assert(context !is null);
        assert(hasCapacity);
        assert(vertices.length == verticesCount);
        assert(indices.length == indicesCount);
    }
    body
    {
        context.copyTo(vertices_, verticesEnd_, vertices);

        ushort[indicesCount] ushortIndices;
        foreach(i, ref e; ushortIndices) {
            e = cast(ushort)(verticesEnd_ + indices[i]);
        }
        context.copyTo(indices_, indicesEnd_, ushortIndices);

        verticesEnd_ += verticesCount;
        indicesEnd_ += indicesCount;
        ++count_;
    }

    void draw(
            scope OpenGLContext context,
            ShaderProgramID program,
            ref const(Mat4) viewportMatrix,
            UniformLocation viewportMatrixLocation)
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

        context.uniform(viewportMatrixLocation, viewportMatrix);

        context.draw!ushort(
            GLDrawMode.triangles, cast(uint) indicesEnd_, 0);
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

    void setUpVAO(scope OpenGLContext context)
    {
        context.bind(vao_);

        context.bind(vertices_);
        scope (exit) context.unbindVertices();

        foreach(i, fieldName; FieldNameTuple!Vertex)
        {
            enum initField = "Vertex.init." ~ fieldName;
            enum fieldOffset = mixin(initField ~ ".offsetof");
            alias FieldType = typeof(mixin(initField));
            static if (isArray!FieldType)
            {
                alias ElementType = Unqual!(ForeachType!FieldType);
                enum length = mixin(initField ~ ".length");
            }
            else
            {
                alias ElementType = FieldType;
                enum length = 1;
            }

            static if (isIntegral!ElementType)
            {
                enum normalized = hasUDA!(
                        mixin("Vertex." ~ fieldName),
                        VertexAttributeType.normalized);
                context.vertexAttributes!(Vertex, ElementType)(
                        i, length, fieldOffset, normalized);
            }
            else
            {
                context.vertexAttributes!(Vertex, ElementType)(i, length, fieldOffset);
            }

            context.enableVertexAttributes(i);
        }

        context.bind(indices_);
        scope (exit) context.unbindIndices();

        context.activeTexture(GLTextureUnit.texture0);
        context.bind(GLTextureParameterTarget.texture2D, texture_);
        scope (exit) context.unbindTexture(GLTextureParameterTarget.texture2D);

        context.unbindVAO();
    }

    VertexArrayID vao_;
    VerticesID vertices_;
    IndicesID indices_;
    TextureID texture_;
    size_t capacity_;
    size_t count_;
    size_t verticesEnd_;
    size_t indicesEnd_;
}

