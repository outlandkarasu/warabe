/**
OpenGL buffers module.
*/
module warabe.opengl.buffers;

import gl = bindbc.opengl;

/**
Buffer type.
*/
enum GLBufferType
{
    arrayBuffer = gl.GL_ARRAY_BUFFER,
    copyWriteBuffer = gl.GL_COPY_WRITE_BUFFER,
    elementArrayBuffer = gl.GL_ELEMENT_ARRAY_BUFFER,
    pixelPackBuffer = gl.GL_PIXEL_PACK_BUFFER,
    pixelUnpackBuffer = gl.GL_PIXEL_UNPACK_BUFFER,
}

/**
OpenGL buffer type.
*/
struct GLBuffer(GLBufferType type)
{
    /**
    Buffer type.
    */
    enum TYPE = type;

    /**
    cast value.
    Returns:
        buffer value.
    */
    gl.GLuint opCast(T)() const @nogc nothrow pure @safe
    if(is(T == gl.GLuint))
    {
        return buffer_;
    }

private:
    gl.GLuint buffer_;
}

///
@nogc nothrow pure @safe unittest
{
    immutable buffer = GLBuffer!(GLBufferType.arrayBuffer)(123);
    assert(cast(gl.GLuint) buffer == 123);
}

alias GLArrayBuffer = GLBuffer!(GLBufferType.arrayBuffer);
alias GLCopyWriteBuffer = GLBuffer!(GLBufferType.copyWriteBuffer);
alias GLElementArrayBuffer = GLBuffer!(GLBufferType.elementArrayBuffer);
alias GLPixelPackBuffer = GLBuffer!(GLBufferType.pixelPackBuffer);
alias GLPixelUnpackBuffer = GLBuffer!(GLBufferType.pixelUnpackBuffer);

/**
Generate a buffer.

Params:
    type = buffer type.
Returns:
    buffer name.
*/
GLBuffer!type generateBuffer(GLBufferType type)() @nogc nothrow
{
    gl.GLuint buffer;
    gl.glGenBuffers(1, &buffer);
    return GLBuffer!type(buffer);
}

/**
Delete a buffer.

Params:
    type = buffer type.
    buffer = target buffer.
*/
void deleteBuffer(GLBufferType type)(GLBuffer!type buffer) @nogc nothrow
{
    immutable name = cast(gl.GLuint) buffer;
    gl.glDeleteBuffers(1, &name);
}

/**
Bind a buffer.

Params:
    type = buffer type.
    buffer = target buffer.
*/
void bindBuffer(GLBufferType type)(GLBuffer!type buffer) @nogc nothrow
{
    gl.glBindBuffer(type, cast(gl.GLuint) buffer);
}

/**
Unbind a buffer.

Params:
    type = buffer type.
*/
void unbindBuffer(GLBufferType type) @nogc nothrow
{
    gl.glBindBuffer(type, 0);
}

