module warabe.opengl.shader;

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
    GLuint;

import warabe.opengl.exception : OpenGLException;

/**
create empty shader program.

Returns:
    empty program ID.
Throws:
    OpenGLException if failed.
*/
GLuint createEmptyProgram()
{
    return createShaderProgram(import("empty.vert"), import("empty.frag"));
}

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
    immutable shaderID = glCreateShader(shaderType);
    scope(failure) glDeleteShader(shaderID);

    immutable length = cast(GLint) source.length;
    const sourcePointer = source.ptr;
    glShaderSource(shaderID, 1, &sourcePointer, &length);
    glCompileShader(shaderID);

    GLint status;
    glGetShaderiv(shaderID, GL_COMPILE_STATUS, &status);
    if(status == GL_FALSE) {
        GLint logLength;
        glGetShaderiv(shaderID, GL_INFO_LOG_LENGTH, &logLength);
        auto log = new GLchar[logLength];
        glGetShaderInfoLog(shaderID, logLength, null, log.ptr);
        throw new OpenGLException(assumeUnique(log));
    }
    return shaderID;
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
    immutable vertexShaderID = compileShader(vertexShaderSource, GL_VERTEX_SHADER);
    scope(exit) glDeleteShader(vertexShaderID);
    immutable fragmentShaderID = compileShader(fragmentShaderSource, GL_FRAGMENT_SHADER);
    scope(exit) glDeleteShader(fragmentShaderID);

    auto programID = glCreateProgram();
    scope(failure) glDeleteProgram(programID);
    glAttachShader(programID, vertexShaderID);
    scope(exit) glDetachShader(programID, vertexShaderID);
    glAttachShader(programID, fragmentShaderID);
    scope(exit) glDetachShader(programID, fragmentShaderID);

    glLinkProgram(programID);
    GLint status;
    glGetProgramiv(programID, GL_LINK_STATUS, &status);
    if(status == GL_FALSE) {
        GLint logLength;
        glGetProgramiv(programID, GL_INFO_LOG_LENGTH, &logLength);
        auto log = new GLchar[logLength];
        glGetProgramInfoLog(programID, logLength, null, log.ptr);
        throw new OpenGLException(assumeUnique(log));
    }

    return programID;
}

