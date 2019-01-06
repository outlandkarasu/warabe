module warabe.opengl;

import warabe.exception : WarabeException;

///
enum OpenGLVersion {
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

