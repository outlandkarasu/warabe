module warabe.opengl;

import bindbc.opengl :
    GLSupport,
    loadOpenGL,
    unloadOpenGL;

import warabe.exception : WarabeException;

/// required OpenGL version.
enum OpenGLVersion
{
    major = 3,
    minor = 3
}

/**
OpenGL related exception.
*/
class OpenGLException : WarabeException
{
    /// constructor from super class.
    pure nothrow @nogc @safe this(
            string msg,
            string file = __FILE__,
            size_t line = __LINE__,
            Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

/**
Initialize OpenGL library.

Returns:
    loaded version.
**/
GLSupport initializeOpenGL()
{
    immutable loaded = loadOpenGL();
    if(loaded == GLSupport.noLibrary) {
        throw new OpenGLException("OpenGL not found.");
    } else if(loaded == GLSupport.badLibrary) {
        throw new OpenGLException("OpenGL bad library.");
    } else if(loaded == GLSupport.noContext) {
        throw new OpenGLException("OpenGL context not yet created.");
    }
    return loaded;
}

/**
finalize OpenGL libraries.
*/
void finalizeOpenGL()
{
    unloadOpenGL();
}

