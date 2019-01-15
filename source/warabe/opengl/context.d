module warabe.opengl.context;

import bindbc.opengl :
    glDeleteBuffers,
    glGenBuffers,
    GLintptr,
    GLsizeiptr,
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
    VerticesID createVertices(GLsizeiptr size);

    /**
    copy data to an array buffer.

    Params:
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        OpenGLException if failed.
    */
    void copyTo(VerticesID id, GLintptr offset, const(void)[] data);

    /**
    create index array buffer object.

    Params:
        size = buffer size.
    Returns:
        buffer object name.
    Throws:
        OpenGLException if failed.
    */
    IndicesID createIndices(GLsizeiptr size);

    /**
    copy data to an array buffer.

    Params:
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        OpenGLException if failed.
    */
    void copyTo(IndicesID id, GLintptr offset, const(void)[] data);
}

