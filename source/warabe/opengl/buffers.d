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

