/**
OpenGL functions module.
*/
module warabe.opengl.functions;

import gl = bindbc.opengl;

import bindbc.opengl :
    GLint,
    GLsizei
    ;

/**
set viewport.

Params:
    x = left position.
    y = lower position.
    width = viewport width.
    height = viewport height.
*/
void viewport(GLint x, GLint y, GLsizei width, GLsizei height) @nogc nothrow
{
    gl.glViewport(x, y, width, height);
}

