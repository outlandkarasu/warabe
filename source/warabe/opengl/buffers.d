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
struct GLBuffer(GLBufferType bufferType)
{
    /**
    Buffer type.
    */
    enum TYPE = bufferType;

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

    /**
    Returns:
        buffer type.
    */
    @property GLBufferType type() const @nogc nothrow pure @safe
    {
        return bufferType;
    }

private:
    gl.GLuint buffer_;
}

///
@nogc nothrow pure @safe unittest
{
    immutable buffer = GLBuffer!(GLBufferType.arrayBuffer)(123);
    assert(cast(gl.GLuint) buffer == 123);
    assert(buffer.type == GLBufferType.arrayBuffer);
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

/**
OpenGL buffer usage.
*/
enum GLBufferUsage
{
    streamDraw = gl.GL_STREAM_DRAW,
    streamRead = gl.GL_STREAM_READ,
    streamCopy = gl.GL_STREAM_COPY,
    staticDraw = gl.GL_STATIC_DRAW,
    staticRead = gl.GL_STATIC_READ,
    staticCopy = gl.GL_STATIC_COPY,
    dynamicDraw = gl.GL_DYNAMIC_DRAW,
    dynamicRead = gl.GL_DYNAMIC_READ,
    dynamicCopy = gl.GL_DYNAMIC_COPY,
}

/**
initialize buffer data.

Params:
    type = buffer type.
    buffer = target buffer.
    data = initialize data.
    usage = buffer usage.
*/
void bufferData(GLBufferType type)(
        GLBuffer!type buffer,
        const(void)[] data,
        GLBufferUsage usage) @nogc nothrow
{
    gl.glBufferData(
        type,
        cast(gl.GLsizeiptr) data.length,
        (data.length > 0) ? &data[0] : null,
        usage);
}

/**
allocate buffer data.

Params:
    type = buffer type.
    buffer = target buffer.
    size = buffer size.
    usage = buffer usage.
*/
void allocateBuffer(GLBufferType type)(
        GLBuffer!type buffer,
        gl.GLsizeptri size,
        GLBufferUsage usage) @nogc nothrow
{
    gl.glBufferData(type, size, null, usage);
}

