module warabe.opengl.exception;

import warabe.exception : WarabeException;

import std.conv : to;

import bindbc.opengl :
    GLenum,
    glGetError,
    GL_NO_ERROR,
    GL_INVALID_ENUM,
    GL_INVALID_VALUE,
    GL_INVALID_OPERATION,
    GL_INVALID_FRAMEBUFFER_OPERATION,
    GL_OUT_OF_MEMORY;

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
 *  check glGetError result.
 *
 *  Params:
 *      file = source file name.
 *      line = source line number.
 *  Throws:
 *      OpenGLException if has OpenGL errors.
 */
void checkGLError(string file = __FILE__, size_t line = __LINE__)()
{
    checkGLError!(file, line)(glGetError());
}

/**
 *  check glGetError result.
 *
 *  Params:
 *      file = source file name.
 *      line = source line number.
 *      errorCode = OpenGL error code.
 *  Throws:
 *      OpenGLException if has OpenGL errors.
 */
void checkGLError(string file = __FILE__, size_t line = __LINE__)(GLenum errorCode)
{
    switch(errorCode) {
        case GL_NO_ERROR:
            return;
        case GL_INVALID_ENUM:
            throw new OpenGLException("GL_INVALID_ENUM", file, line);
        case GL_INVALID_VALUE:
            throw new OpenGLException("GL_INVALID_VALUE", file, line);
        case GL_INVALID_OPERATION:
            throw new OpenGLException("GL_INVALID_OPERATION", file, line);
        case GL_INVALID_FRAMEBUFFER_OPERATION:
            throw new OpenGLException("GL_INVALID_FRAMEBUFFER_OPERATION", file, line);
        case GL_OUT_OF_MEMORY:
            throw new OpenGLException("GL_OUT_OF_MEMORY", file, line);
        default:
            throw new OpenGLException("Unknown OpenGL error. " ~ errorCode.to!string, file, line);
    }
}

