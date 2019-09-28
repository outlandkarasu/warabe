/**
OpenGL shaders module.
*/
module warabe.opengl.shaders;

import std.typecons : Typedef;

import gl = bindbc.opengl;

/**
Shader type.
*/
enum GLShaderType
{
    vertexShader = gl.GL_VERTEX_SHADER,
    fragmentShader = gl.GL_FRAGMENT_SHADER,
}

/**
OpenGL shader ID type.
*/
alias GLShader = Typedef!(gl.GLuint, gl.GLuint.init, "GLShader");

/**
create shader.

Params:
    shaderType = shader type.
Returns:
    shader ID.
*/
GLShader createShader(GLShaderType shaderType) @nogc nothrow
{
    return GLShader(gl.glCreateShader(shaderType));
}

/**
delete shader.

Params:
    shader = target shader.
*/
void deleteShader(GLShader shader) @nogc nothrow
{
    gl.glDeleteShader(cast(gl.GLuint) shader);
}

