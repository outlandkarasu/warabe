/**
OpenGL vertices module.
*/
module warabe.opengl.vertices;

import std.typecons : Typedef;

import gl = bindbc.opengl;

import warabe.opengl.shaders : GLProgram;
import warabe.opengl.types : GLType;

/**
Enable vertex attribute.

Params:
    index = vertex attribute index.
*/
void enableVertexAttribute(gl.GLuint index) @nogc nothrow
{
    gl.glEnableVertexAttribArray(index);
}

/**
Disable vertex attribute.

Params:
    index = vertex attribute index.
*/
void disableVertexAttribute(gl.GLuint index) @nogc nothrow
{
    gl.glDisableVertexAttribArray(index);
}

/**
OpenGL vertex attribute index.
*/
alias GLAttribute = Typedef!(gl.GLuint, gl.GLuint.init, "GLAttribute");

/**
Get attribute location.

Params:
    program = target program.
    name = attribute name.
Returns:
    attribute location.
*/
GLAttribute getAttributeLocation(
        GLProgram program,
        scope const(char)[] name) @nogc nothrow
in
{
    assert(name.length > 0);
}
body
{
    return GLAttribute(gl.glGetAttribLocation(
        cast(gl.GLuint) program, &name[0]));
}

/**
Define vertex attribute pointer.

Params:
    index = attribute index.
    size = attribute component count.
    type = attribute component type.
    normalized = attribute normalized.
    stride = struct size.
    offset = struct field offset.
*/
void vertexAttributePointer(T)(
        GLAttribute index,
        gl.GLint size,
        GLType!T type,
        bool normalized,
        gl.GLsizei stride,
        gl.GLsizei offset) @nogc nothrow
{
    gl.glVertexAttribPointer(
        cast(gl.GLuint) index,
        size,
        type,
        normalized ? gl.GL_TRUE : gl.GL_FALSE,
        stride,
        cast(const(gl.GLvoid)*) offset);
}

