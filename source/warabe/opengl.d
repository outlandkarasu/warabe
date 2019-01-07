module warabe.opengl;

import std.exception : assumeUnique;

import bindbc.opengl :
    GL_COMPILE_STATUS,
    GL_FALSE,
    GL_FRAGMENT_SHADER,
    GL_INFO_LOG_LENGTH,
    GL_LINK_STATUS,
    GL_VERTEX_SHADER,
    GLchar,
    GLenum,
    glAttachShader,
    glCompileShader,
    glCreateProgram,
    glCreateShader,
    glDeleteProgram,
    glDeleteShader,
    glDetachShader,
    glGetProgramInfoLog,
    glGetProgramiv,
    glGetShaderInfoLog,
    glGetShaderiv,
    GLint,
    glLinkProgram,
    glShaderSource,
    GLSupport,
    GLuint,
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

private:

/**
compile shader.

Params:
    source = shader souce string.
    shaderType = shader type enum.
Returns:
    shader ID.
Throws:
    OpenGLException throw if failed compile.
*/
GLuint compileShader(const(GLchar)[] source, GLenum shaderType) {
    immutable shaderId = glCreateShader(shaderType);
    scope(failure) glDeleteShader(shaderId);

    immutable length = cast(GLint) source.length;
    const sourcePointer = source.ptr;
    glShaderSource(shaderId, 1, &sourcePointer, &length);
    glCompileShader(shaderId);

    GLint status;
    glGetShaderiv(shaderId, GL_COMPILE_STATUS, &status);
    if(status == GL_FALSE) {
        GLint logLength;
        glGetShaderiv(shaderId, GL_INFO_LOG_LENGTH, &logLength);
        auto log = new GLchar[logLength];
        glGetShaderInfoLog(shaderId, logLength, null, log.ptr);
        throw new OpenGLException(assumeUnique(log));
    }
    return shaderId;
}

/**
Params:
    vertexShaderSource = vertex shader program source.
    fragmentShaderSource = fragment shader program source.
Returns:
    program ID.
Throws:
    OpenGLException throw if failed build.
*/
GLuint createShaderProgram(const(GLchar)[] vertexShaderSource, const(GLchar)[] fragmentShaderSource) {
    immutable vertexShaderId = compileShader(vertexShaderSource, GL_VERTEX_SHADER);
    scope(exit) glDeleteShader(vertexShaderId);
    immutable fragmentShaderId = compileShader(fragmentShaderSource, GL_FRAGMENT_SHADER);
    scope(exit) glDeleteShader(fragmentShaderId);

    auto programId = glCreateProgram();
    scope(failure) glDeleteProgram(programId);
    glAttachShader(programId, vertexShaderId);
    scope(exit) glDetachShader(programId, vertexShaderId);
    glAttachShader(programId, fragmentShaderId);
    scope(exit) glDetachShader(programId, fragmentShaderId);

    glLinkProgram(programId);
    GLint status;
    glGetProgramiv(programId, GL_LINK_STATUS, &status);
    if(status == GL_FALSE) {
        GLint logLength;
        glGetProgramiv(programId, GL_INFO_LOG_LENGTH, &logLength);
        auto log = new GLchar[logLength];
        glGetProgramInfoLog(programId, logLength, null, log.ptr);
        throw new OpenGLException(assumeUnique(log));
    }

    return programId;
}

