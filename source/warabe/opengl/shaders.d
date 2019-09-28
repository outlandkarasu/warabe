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

/**
read shader source.

Params:
    shader = target shader.
    source = shader source string.
*/
void shaderSource(GLShader shader, scope const(char)[] source) @nogc nothrow
{
    const(gl.GLchar)*[1] sources = [
        source.length > 0 ? &source[0] : null
    ];
    immutable gl.GLint[1] length = [cast(gl.GLint) source.length];
    gl.glShaderSource(
        cast(gl.GLuint) shader, 1, &sources[0], &length[0]);
}

