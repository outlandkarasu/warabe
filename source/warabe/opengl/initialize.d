module warabe.opengl.initialize;

import bindbc.opengl :
    GLSupport,
    loadOpenGL,
    unloadOpenGL;

import warabe.opengl.exception : OpenGLException;

/// required OpenGL version.
enum OpenGLVersion
{
    major = 3,
    minor = 3
}

/**
Initialize OpenGL library.

Returns:
    loaded version.
*/
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

