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

/**
OpenGL context for renderer.
*/
interface OpenGLContext {

    /**
    create vertex array buffer object.

    Params:
        size = buffer size.
    Returns:
        buffer object name.
    Throws:
        OpenGLException if failed.
    */
    VerticesID createVertices(uint size);

    /**
    copy data to an array buffer.

    Params:
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        OpenGLException if failed.
    */
    void copyTo(VerticesID id, ptrdiff_t offset, const(void)[] data);

    /**
    create index array buffer object.

    Params:
        size = buffer size.
    Returns:
        buffer object name.
    Throws:
        OpenGLException if failed.
    */
    IndicesID createIndices(uint size);

    /**
    copy data to an array buffer.

    Params:
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        OpenGLException if failed.
    */
    void copyTo(IndicesID id, ptrdiff_t offset, const(void)[] data);
}

private:

/**
OpenGL context implementation.
*/
class OpenGLContextImpl : OpenGLContext
{
    override {

        VerticesID createVertices(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }
    
        void copyTo(VerticesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(GL_ARRAY_BUFFER, id, offset,data);
        }
    
        IndicesID createIndices(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }
    
        void copyTo(IndicesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(GL_ELEMENT_ARRAY_BUFFER, id, offset,data);
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
}

