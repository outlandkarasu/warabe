module warabe.opengl.context;

import warabe.opengl.exception : checkGLError;

import bindbc.opengl :
    GL_ARRAY_BUFFER,
    GL_ELEMENT_ARRAY_BUFFER,
    glBindBuffer,
    glBufferSubData,
    glDeleteBuffers,
    GLenum,
    glGenBuffers,
    GLuint;

import std.typecons : Typedef;

/// vertex array buffer ID.
alias VerticesID = Typedef!(GLuint, GLuint.init, "VerticesID");

/// index array buffer ID.
alias IndicesID = Typedef!(GLuint, GLuint.init, "IndicesID");

/// vertex type predicate.
enum isVertexType(T) = __traits(isPOD, T);

/// index type predicate.
enum isIndexType(T) = is(T == ubyte) || is(T == ushort);

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

