module warabe.opengl.initialize;

import bindbc.opengl :
    GLSupport,
    loadOpenGL,
    unloadOpenGL;

import warabe.opengl.exception : OpenGLException;
import warabe.opengl.context: OpenGLContext, OpenGLContextImpl;

/// required OpenGL version.
enum OpenGLVersion
{
    major = 3,
    minor = 3
}

/**
Initialize OpenGL library.

Returns:
    OpenGL context..
*/
OpenGLContext initializeOpenGL()
{
    immutable loaded = loadOpenGL();
    if(loaded == GLSupport.noLibrary) {
        throw new OpenGLException("OpenGL not found.");
    } else if(loaded == GLSupport.badLibrary) {
        throw new OpenGLException("OpenGL bad library.");
    } else if(loaded == GLSupport.noContext) {
        throw new OpenGLException("OpenGL context not yet created.");
    }
    return new OpenGLContextImplBindBC(loaded);
}

private:

class OpenGLContextImplBindBC : OpenGLContextImpl
{
    this(GLSupport support)
    {
        super(support);
    }

    ~this()
    {
        unloadOpenGL();
    }
}

