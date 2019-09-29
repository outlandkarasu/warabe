/**
OpenGL draw functions module.
*/
module warabe.opengl.draws;

import gl = bindbc.opengl;

import warabe.opengl.types : GLType;

/**
set viewport.

Params:
    x = left position.
    y = lower position.
    width = viewport width.
    height = viewport height.
*/
void viewport(gl.GLint x, gl.GLint y, gl.GLsizei width, gl.GLsizei height) @nogc nothrow
{
    gl.glViewport(x, y, width, height);
}

/**
OpenGL color mask.
*/
enum GLMask : gl.GLbitfield
{
    colorBufferBit = gl.GL_COLOR_BUFFER_BIT,
    depthBufferBit = gl.GL_DEPTH_BUFFER_BIT,
    stencilBufferBit = gl.GL_STENCIL_BUFFER_BIT,
    all = colorBufferBit | depthBufferBit | stencilBufferBit,
}

/**
Clear viewport.

Params:
    mask = clear mask.
*/
void clear(GLMask mask) @nogc nothrow
{
    gl.glClear(mask);
}

/**
set clear color.

Params:
    red = clear red component.
    green = clear red component.
    blue = clear blue component.
    alpha = clear alpha.
*/
void clearColor(
        gl.GLclampf red,
        gl.GLclampf green,
        gl.GLclampf blue,
        gl.GLclampf alpha) @nogc nothrow
{
    gl.glClearColor(red, green, blue, alpha);
}

/**
Primitive types.
*/
enum GLPrimitive : gl.GLenum
{
    points = gl.GL_POINTS,
    lineStrip = gl.GL_LINE_STRIP,
    lineLoop = gl.GL_LINE_LOOP,
    lines = gl.GL_LINES,
    triangleStrip = gl.GL_TRIANGLE_STRIP,
    triangleFan = gl.GL_TRIANGLE_FAN,
    triangles = gl.GL_TRIANGLES,
}

/**
draw elements.

Params:
    mode = draw primitive mode.
    indices = indices.
*/
void drawElements(T)(GLPrimitive mode, scope const(T)[] indices) @nogc nothrow
in
{
    assert(indices.length > 0);
}
body
{
    gl.glDrawElements(
        mode,
        cast(gl.GLsizei) indices.length,
        GLType!T,
        &indices[0]);
}

