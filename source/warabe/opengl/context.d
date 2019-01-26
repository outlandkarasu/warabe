module warabe.opengl.context;

import warabe.opengl.exception : checkGLError;

import bindbc.opengl :
    GL_ARRAY_BUFFER,
    GL_BYTE,
    GL_ELEMENT_ARRAY_BUFFER,
    GL_FLOAT,
    GL_SHORT,
    GL_UNSIGNED_BYTE,
    GL_UNSIGNED_SHORT,
    glBindBuffer,
    glBufferSubData,
    glDeleteBuffers,
    GLenum,
    glGenBuffers,
    GLuint,
    glVertexAttribPointer,
    GLvoid;

import std.traits : isIntegral;
import std.typecons : Typedef;

/// vertex array buffer ID.
alias VerticesID = Typedef!(GLuint, GLuint.init, "VerticesID");

/// index array buffer ID.
alias IndicesID = Typedef!(GLuint, GLuint.init, "IndicesID");

/// vertex type predicate.
enum isVertexType(T) = __traits(isPOD, T);

/// index type predicate.
enum isIndexType(T) = is(T == ubyte) || is(T == ushort);

/// OpenGL element type enum.
template GLTypeEnum(T)
{
    static if (is(T == byte))
    {
        enum GLTypeEnum = GL_BYTE;
    }
    else static if (is(T == ubyte))
    {
        enum GLTypeEnum = GL_UNSIGNED_BYTE;
    }
    else static if (is(T == short))
    {
        enum GLTypeEnum = GL_SHORT;
    }
    else static if (is(T == ushort))
    {
        enum GLTypeEnum = GL_UNSIGNED_SHORT;
    }
    else static if (is(T == float))
    {
        enum GLTypeEnum = GL_FLOAT;
    }
    else
    {
        static assert(false, T.stringof ~ " is not supported.");
    }
}

@nogc nothrow pure @safe unittest
{
    static assert(GLTypeEnum!byte == GL_BYTE);
    static assert(GLTypeEnum!ubyte == GL_UNSIGNED_BYTE);
    static assert(GLTypeEnum!short == GL_SHORT);
    static assert(GLTypeEnum!ushort == GL_UNSIGNED_SHORT);
    static assert(GLTypeEnum!float == GL_FLOAT);
}

/**
OpenGL context for renderer.
*/
interface OpenGLContext
{

    /**
    create vertex array buffer object.

    Params:
        size = buffer byte size.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    VerticesID createVerticesFromBytes(uint size);

    /**
    create vertex array buffer object.

    Params:
        T = vertex type.
        length = vertices length.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    VerticesID createVertices(T)(uint length)
    if (isVertexType!T)
    {
        return createVerticesFromBytes(cast(uint)(length * T.sizeof));
    }

    /**
    copy raw data to an array buffer.

    Params:
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyRawDataTo(VerticesID id, ptrdiff_t offset, const(void)[] data);

    /**
    copy vertices data to an array buffer.

    Params:
        T = vertex type.
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyTo(T)(VerticesID id, ptrdiff_t offset, const(T)[] data)
    if (isVertexType!T)
    {
        copyRawDataTo(id, offset, cast(const(void)[]) data);
    }

    /**
    delete vertices buffer object.

    Params:
        id = array buffer ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void deleteVertices(VerticesID id);

    /**
    create index array buffer object.

    Params:
        size = buffer byte size.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    IndicesID createIndicesFromBytes(uint size);

    /**
    create index array buffer object.

    Params:
        length = indices length.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    IndicesID createIndices(T)(uint length)
    if (isIndexType!T)
    {
        return createIndicesFromBytes(cast(uint)(length * T.sizeof));
    }

    /**
    delete indices buffer object.

    Params:
        id = element array buffer ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void deleteIndices(IndicesID id);

    /**
    copy raw data to an element array buffer.

    Params:
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyRawDataTo(IndicesID id, ptrdiff_t offset, const(void)[] data);

    /**
    copy indices data to an element array buffer.

    Params:
        T = index type.
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyTo(T)(IndicesID id, ptrdiff_t offset, const(T)[] data)
    if (isIndexType!T)
    {
        copyRawDataTo(id, offset, cast(const(void)[]) data);
    }

    /**
    set up vertex attribute.

    Params:
        V = vertex type.
        T = element type.
        index = attribute index.
        length = field length.
        offset = field offset.
    **/
    void vertexAttributes(V, T)(uint index, uint length, uint offset)
    if (isVertexType!V)
    in (length <= 4)
    do
    {
        vertexAttributes(
            index,
            length,
            GLTypeEnum!T,
            false,
            V.sizeof,
            offset);
    }

    /**
    set up vertex attribute.

    Params:
        V = vertex type.
        T = element type.
        index = attribute index.
        length = field length.
        offset = field offset.
        normalize = normalize flag.
    **/
    void vertexAttributes(V, T)(uint index, uint length, uint offset, bool normalize)
    if (isVertexType!V && isIntegral!T)
    in (length <= 4)
    do
    {
        vertexAttributes(
            index,
            length,
            GLTypeEnum!T,
            normalize,
            V.sizeof,
            offset);
    }

    /**
    set up vertex attribute.

    Params:
        index = attribute index.
        size = attribute size.
        type = attribute component type.
        normalize = normalize flag for integer type.
        stride = attribute structure size.
        offset = attribute offset from structure base.
    **/
    void vertexAttributes(uint index, int size, GLenum type, bool normalize, uint stride, uint offset);
}

private:

/**
OpenGL context implementation.
*/
class OpenGLContextImpl : OpenGLContext
{
    override
    {

        VerticesID createVerticesFromBytes(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }
    
        void copyRawDataTo(VerticesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(GL_ARRAY_BUFFER, id, offset,data);
        }

        void deleteVertices(VerticesID id)
        {
            deleteBuffer(id);
        }
    
        IndicesID createIndicesFromBytes(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }
    
        void copyRawDataTo(IndicesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(GL_ELEMENT_ARRAY_BUFFER, id, offset,data);
        }

        void deleteIndices(IndicesID id)
        {
            deleteBuffer(id);
        }

        void vertexAttributes(
            uint index,
            int size,
            GLenum type,
            bool normalize,
            uint stride,
            uint offset)
        {
            glVertexAttribPointer(
                index,
                size,
                type,
                normalize,
                stride,
                cast(const(GLvoid)*) offset);
        }
    }

private:

    T createBuffer(T)(uint size)
    {
        GLuint result;
        glGenBuffers(1, &result);
        checkGLError();
        return T(result);
    }

    void copyToBuffer(T)(
            GLenum target,
            T typedID,
            ptrdiff_t offset,
            const(void)[] data)
    {
        immutable id = cast(GLuint) typedID;
        glBindBuffer(target, id);
        scope(exit) glBindBuffer(target, 0);
        glBufferSubData(target, offset, data.length, data.ptr);
        checkGLError();
    }

    void deleteBuffer(T)(T typedID)
    {
        immutable id = cast(GLuint) typedID;
        glDeleteBuffers(1, &id);
        checkGLError();
    }
}

