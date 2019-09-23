/**
Warabe OpenGL exception.
*/
module warabe.opengl.exception;

import std.typecons : Nullable;

import gl = bindbc.opengl;

import bindbc.opengl :
    GLenum,
    glGetError;

import warabe.exception : WarabeException;

/**
OpenGL related exception.
*/
class OpenGLException : WarabeException
{
    /**
    construct by message.

    Params:
        msg = exception message.
        file = file name.
        line = source line number.
        nextInChain = exception chain.
    */
    @nogc nothrow pure @safe
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

/**
OpenGL error code.
*/
enum GLError : GLenum
{
    noError = gl.GL_NO_ERROR,
    invalidEnum = gl.GL_INVALID_ENUM,
    invalidValue = gl.GL_INVALID_VALUE,
    invalidOperation = gl.GL_INVALID_OPERATION,
    outOfMemory = gl.GL_OUT_OF_MEMORY,
}

/**
OpenGL error to string.

Params:
    error = OpenGL error.
Returns:
    error message.
*/
string errorToString(GLError error) @nogc nothrow pure @safe
{
    final switch (error)
    {
        case GLError.noError:
            return "GL_NO_ERROR";
        case GLError.invalidEnum:
            return "GL_INVALID_ENUM";
        case GLError.invalidValue:
            return "GL_INVALID_VALUE";
        case GLError.invalidOperation:
            return "GL_INVALID_OPERATION";
        case GLError.outOfMemory:
            return "GL_OUT_OF_MEMORY";
    }
}

///
@nogc nothrow pure @safe unittest
{
    assert(errorToString(GLError.noError) == "GL_NO_ERROR");
    assert(errorToString(GLError.invalidEnum) == "GL_INVALID_ENUM");
    assert(errorToString(GLError.invalidValue) == "GL_INVALID_VALUE");
    assert(errorToString(GLError.invalidOperation) == "GL_INVALID_OPERATION");
    assert(errorToString(GLError.outOfMemory) == "GL_OUT_OF_MEMORY");
}

/**
get last OpenGL error.

Returns:
    last OpenGL error or null.
*/
GLError getGLError() @nogc nothrow
{
    return cast(GLError) glGetError();
}

/**
check OpenGL error.

Throws:
    OpenGLException if exists any OpenGL error.
*/
void checkGLError()
{
    immutable error = getGLError();
    if (error != GLError.noError)
    {
        throw new OpenGLException(errorToString(error));
    }
}

