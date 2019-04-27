module warabe.opengl.context;

import warabe.lina.matrix : Matrix;
import warabe.opengl.exception : checkGLError;
import warabe.opengl.shader : createShaderProgram;

import bindbc.opengl :
    GL_ALPHA,
    GL_ARRAY_BUFFER,
    GL_BLEND,
    GL_BYTE,
    GL_COLOR_BUFFER_BIT,
    GL_CLAMP_TO_EDGE,
    GL_DEPTH_BUFFER_BIT,
    GL_ELEMENT_ARRAY_BUFFER,
    GL_FLOAT,
    GL_LINE_LOOP,
    GL_LINE_STRIP,
    GL_LINEAR,
    GL_LINEAR_MIPMAP_LINEAR,
    GL_LINEAR_MIPMAP_NEAREST,
    GL_LINES,
    GL_MIRRORED_REPEAT,
    GL_NEAREST,
    GL_NEAREST_MIPMAP_LINEAR,
    GL_NEAREST_MIPMAP_NEAREST,
    GL_MAX_TEXTURE_SIZE,
    GL_PACK_ALIGNMENT,
    GL_POINTS,
    GL_REPEAT,
    GL_RGB,
    GL_RGBA,
    GL_SHORT,
    GL_STENCIL_BUFFER_BIT,
    GL_STREAM_DRAW,
    GL_TEXTURE_2D,
    GL_TEXTURE_CUBE_MAP,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
    GL_TEXTURE_CUBE_MAP_POSITIVE_X,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
    GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,
    GL_TEXTURE_CUBE_MAP_POSITIVE_Z,
    GL_TEXTURE_MIN_FILTER,
    GL_TEXTURE_MAG_FILTER,
    GL_TEXTURE_WRAP_S,
    GL_TEXTURE_WRAP_T,
    GL_TEXTURE0,
    GL_TEXTURE1,
    GL_TEXTURE2,
    GL_TEXTURE3,
    GL_TEXTURE4,
    GL_TEXTURE5,
    GL_TEXTURE6,
    GL_TEXTURE7,
    GL_TEXTURE8,
    GL_TRIANGLE_STRIP,
    GL_TRIANGLE_FAN,
    GL_TRIANGLES,
    GL_UNPACK_ALIGNMENT,
    GL_UNSIGNED_BYTE,
    GL_UNSIGNED_SHORT,
    GL_UNSIGNED_SHORT_5_6_5,
    GL_UNSIGNED_SHORT_4_4_4_4,
    GL_UNSIGNED_SHORT_5_5_5_1,
    GL_VIEWPORT,
    glActiveTexture,
    glBindBuffer,
    glBindTexture,
    glBindVertexArray,
    glBlendFunc,
    glBufferData,
    glBufferSubData,
    glClear,
    glClearColor,
    glDeleteBuffers,
    glDeleteProgram,
    glDeleteTextures,
    glDeleteVertexArrays,
    glDisable,
    glDisableVertexAttribArray,
    glDrawElements,
    glEnableVertexAttribArray,
    GLenum,
    glEnable,
    glFlush,
    glGenBuffers,
    glGenTextures,
    glGetFloatv,
    glGetIntegerv,
    glGenVertexArrays,
    glGetUniformLocation,
    GLint,
    glPixelStorei,
    GLSupport,
    glTexImage2D,
    glTexParameteri,
    glTexSubImage2D,
    GLuint,
    glUniformMatrix4fv,
    glUseProgram,
    glVertexAttribPointer,
    glViewport,
    GLvoid;

import bindbc.opengl :
    GL_ZERO,
    GL_ONE,
    GL_SRC_COLOR,
    GL_ONE_MINUS_SRC_COLOR,
    GL_DST_COLOR,
    GL_ONE_MINUS_DST_COLOR,
    GL_SRC_ALPHA,
    GL_ONE_MINUS_SRC_ALPHA,
    GL_DST_ALPHA,
    GL_ONE_MINUS_DST_ALPHA,
    GL_CONSTANT_COLOR,
    GL_ONE_MINUS_CONSTANT_COLOR,
    GL_CONSTANT_ALPHA,
    GL_ONE_MINUS_CONSTANT_ALPHA,
    GL_SRC_ALPHA_SATURATE;

import std.traits : isIntegral;
import std.typecons : Typedef;
import std.string : toStringz;

/// vertex array buffer ID.
alias VerticesID = Typedef!(GLuint, GLuint.init, "VerticesID");

/// index array buffer ID.
alias IndicesID = Typedef!(GLuint, GLuint.init, "IndicesID");

/// shader program ID.
alias ShaderProgramID = Typedef!(GLuint, GLuint.init, "ShaderProgramID");

/// vertex array ID.
alias VertexArrayID = Typedef!(GLuint, GLuint.init, "VertexArrayID");

/// texture ID.
alias TextureID = Typedef!(GLuint, GLuint.init, "TextureID");

/// uniform location.
alias UniformLocation = Typedef!(GLint, GLint.init, "UniformLocation");

/// matrix type.
alias Mat4 = Matrix!(float, 4, 4);

/// vertex type predicate.
enum isVertexType(T) = __traits(isPOD, T);

/// index type predicate.
enum isIndexType(T) = is(T == ubyte) || is(T == ushort);

/// OpenGL buffer type enum.
template GLBufferTypeEnum(T)
{
    static if (is(T == VerticesID))
    {
        enum GLBufferTypeEnum = GL_ARRAY_BUFFER;
    }
    else static if (is(T == IndicesID))
    {
        enum GLBufferTypeEnum = GL_ELEMENT_ARRAY_BUFFER;
    }
    else
    {
        static assert(false, T.stringof ~ " is not supported.");
    }
}

/// OpenGL element type enum.
template GLTypeEnum(T)
{
    static if (is(T == byte))
    {
        enum GLTypeEnum = GL_BYTE;
    }
    else static if (is(T == ubyte))
    {
        enum GLTypeEnum = GL_UNSIGNED_BYTE;
    }
    else static if (is(T == short))
    {
        enum GLTypeEnum = GL_SHORT;
    }
    else static if (is(T == ushort))
    {
        enum GLTypeEnum = GL_UNSIGNED_SHORT;
    }
    else static if (is(T == float))
    {
        enum GLTypeEnum = GL_FLOAT;
    }
    else
    {
        static assert(false, T.stringof ~ " is not supported.");
    }
}

/// OpenGL buffer bit.
enum GLBufferBit
{
    color = GL_COLOR_BUFFER_BIT,
    depth = GL_DEPTH_BUFFER_BIT,
    stencil = GL_STENCIL_BUFFER_BIT,
}

/// OpenGL draw mode.
enum GLDrawMode
{
    points = GL_POINTS,
    lineStrip = GL_LINE_STRIP,
    lineLoop = GL_LINE_LOOP,
    lines = GL_LINES,
    triangleStrip = GL_TRIANGLE_STRIP,
    triangleFan = GL_TRIANGLE_FAN,
    triangles = GL_TRIANGLES,
}

/// OpenGL blend mode.
enum GLBlendMode
{
    zero = GL_ZERO,
    one = GL_ONE,
    src = GL_SRC_COLOR,
    oneMinusSrc = GL_ONE_MINUS_SRC_COLOR,
    dst = GL_DST_COLOR,
    oneMinusDst = GL_ONE_MINUS_DST_COLOR,
    srcAlpha = GL_SRC_ALPHA,
    oneMinusSrcAlpha = GL_ONE_MINUS_SRC_ALPHA,
    dstAlpha = GL_DST_ALPHA,
    oneMinusDstAlpha = GL_ONE_MINUS_DST_ALPHA,
    constant = GL_CONSTANT_COLOR,
    oneMinusConstant = GL_ONE_MINUS_CONSTANT_COLOR,
    constantAlpha = GL_CONSTANT_ALPHA,
    oneMinusConstantAlpha = GL_ONE_MINUS_CONSTANT_ALPHA,
    srcAlphaSaturate = GL_SRC_ALPHA_SATURATE
}

/// OpenGL texture parameter target.
enum GLTextureParameterTarget
{
    texture2D = GL_TEXTURE_2D,
    cubeMap = GL_TEXTURE_CUBE_MAP
}

/// OpenGL texture image target
enum GLTextureImageTarget
{
    texture2D = GL_TEXTURE_2D,
    cubeMapNegativeX = GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
    cubeMapPositiveX = GL_TEXTURE_CUBE_MAP_POSITIVE_X,
    cubeMapNegativeY = GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
    cubeMapPositiveY = GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
    cubeMapNegativeZ = GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,
    cubeMapPositiveZ = GL_TEXTURE_CUBE_MAP_POSITIVE_Z
}

/// OpenGL texture minify filter functions.
enum GLTextureMinFilter
{
    nearest = GL_NEAREST,
    linear = GL_LINEAR,
    nearestMipmapNearest = GL_NEAREST_MIPMAP_NEAREST,
    linearMipmapNearest = GL_LINEAR_MIPMAP_NEAREST,
    nearestMipmapLinear = GL_NEAREST_MIPMAP_LINEAR,
    linearMipmapLinear = GL_LINEAR_MIPMAP_LINEAR
}

/// OpenGL texture magnify filter functions.
enum GLTextureMagFilter
{
    nearest = GL_NEAREST,
    linear = GL_LINEAR
}

/// OpenGL texture wrap functions.
enum GLTextureWrap
{
    clampToEdge = GL_CLAMP_TO_EDGE,
    mirroredRepeat = GL_MIRRORED_REPEAT,
    repeat = GL_REPEAT
}

/// OpenGL texture format.
enum GLTextureFormat
{
    alpha = GL_ALPHA,
    rgb = GL_RGB,
    rgba = GL_RGBA
}

/// Texture texel type.
enum GLTextureType
{
    unsignedByte = GL_UNSIGNED_BYTE,
    unsignedShort565 = GL_UNSIGNED_SHORT_5_6_5,
    unsignedShort4444 = GL_UNSIGNED_SHORT_4_4_4_4,
    unsignedShort5551 = GL_UNSIGNED_SHORT_5_5_5_1
}

/// pixel store type.
enum GLPixelStoreType
{
    unpack = GL_UNPACK_ALIGNMENT,
    pack = GL_PACK_ALIGNMENT,
}

/// pixel store alignment type.
enum GLPixelStoreAlignment
{
    align1 = 1,
    align2 = 2,
    align4 = 4,
    align8 = 8
}

/// texture unit number.
enum GLTextureUnit
{
    texture0 = GL_TEXTURE0,
    texture1 = GL_TEXTURE1,
    texture2 = GL_TEXTURE2,
    texture3 = GL_TEXTURE3,
    texture4 = GL_TEXTURE4,
    texture5 = GL_TEXTURE5,
    texture6 = GL_TEXTURE6,
    texture7 = GL_TEXTURE7,
    texture8 = GL_TEXTURE8,
}

@nogc nothrow pure @safe unittest
{
    static assert(GLTypeEnum!byte == GL_BYTE);
    static assert(GLTypeEnum!ubyte == GL_UNSIGNED_BYTE);
    static assert(GLTypeEnum!short == GL_SHORT);
    static assert(GLTypeEnum!ushort == GL_UNSIGNED_SHORT);
    static assert(GLTypeEnum!float == GL_FLOAT);
}

struct Viewport
{
    @nogc nothrow pure @safe const
    {
        @property float x() { return values[0]; }
        @property float y() { return values[1]; }
        @property float width() { return values[2]; }
        @property float height() { return values[3]; }
    }

    private float[4] values;
}

/**
OpenGL context for renderer.
*/
interface OpenGLContext
{
    /**
    enable color buffer blend
    **/
    void enableBlend();

    /**
    disable color buffer blend.
    **/
    void disableBlend();

    /**
    set color buffer blend

    Params:
        srcFactor = source factor.
        dstFactor = destination factor.
    **/
    void setBlendFunc(GLBlendMode srcFactor, GLBlendMode dstFactor);

    /**
    create vertex array buffer object.

    Params:
        size = buffer byte size.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    VerticesID createVerticesFromBytes(uint size);

    /**
    create vertex array buffer object.

    Params:
        T = vertex type.
        length = vertices length.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    VerticesID createVertices(T)(uint length)
    if (isVertexType!T)
    {
        return createVerticesFromBytes(cast(uint)(length * T.sizeof));
    }

    /**
    copy raw data to an array buffer.

    Params:
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyRawDataTo(VerticesID id, ptrdiff_t offset, const(void)[] data);

    /**
    copy vertices data to an array buffer.

    Params:
        T = vertex type.
        id = destination array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyTo(T)(VerticesID id, ptrdiff_t offset, const(T)[] data)
    if (isVertexType!T)
    {
        copyRawDataTo(id, offset * T.sizeof, cast(const(void)[]) data);
    }

    /**
    delete vertices buffer object.

    Params:
        id = array buffer ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void deleteVertices(VerticesID id);

    /**
    bind vertices buffer.

    Params:
        id = array buffer ID.
    */
    void bind(VerticesID id);

    /**
    unbind vertices buffer.
    */
    void unbindVertices();

    /**
    create index array buffer object.

    Params:
        size = buffer byte size.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    IndicesID createIndicesFromBytes(uint size);

    /**
    create index array buffer object.

    Params:
        length = indices length.
    Returns:
        buffer object name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    IndicesID createIndices(T)(uint length)
    if (isIndexType!T)
    {
        return createIndicesFromBytes(cast(uint)(length * T.sizeof));
    }

    /**
    delete indices buffer object.

    Params:
        id = element array buffer ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void deleteIndices(IndicesID id);

    /**
    bind indices buffer.

    Params:
        id = array buffer ID.
    */
    void bind(IndicesID id);

    /**
    unbind indices buffer.
    */
    void unbindIndices();

    /**
    copy raw data to an element array buffer.

    Params:
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyRawDataTo(IndicesID id, ptrdiff_t offset, const(void)[] data);

    /**
    copy indices data to an element array buffer.

    Params:
        T = index type.
        id = destination element array buffer ID.
        offset = copy start offset from buffer origin.
        data = source data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void copyTo(T)(IndicesID id, ptrdiff_t offset, const(T)[] data)
    if (isIndexType!T)
    {
        copyRawDataTo(id, offset * T.sizeof, cast(const(void)[]) data);
    }

    /**
    set up vertex attribute.

    Params:
        V = vertex type.
        T = element type.
        index = attribute index.
        length = field length.
        offset = field offset.
    **/
    void vertexAttributes(V, T)(uint index, uint length, uint offset)
    if (isVertexType!V)
    in
    {
        assert(length <= 4);
    }
    body
    {
        vertexAttributes(
            index,
            length,
            GLTypeEnum!T,
            false,
            V.sizeof,
            offset);
    }

    /**
    set up vertex attribute.

    Params:
        V = vertex type.
        T = element type.
        index = attribute index.
        length = field length.
        offset = field offset.
        normalize = normalize flag.
    **/
    void vertexAttributes(V, T)(uint index, uint length, uint offset, bool normalize)
    if (isVertexType!V && isIntegral!T)
    in
    {
        assert(length <= 4);
    }
    body
    {
        vertexAttributes(
            index,
            length,
            GLTypeEnum!T,
            normalize,
            V.sizeof,
            offset);
    }

    /**
    set up vertex attribute.

    Params:
        index = attribute index.
        size = attribute size.
        type = attribute component type.
        normalize = normalize flag for integer type.
        stride = attribute structure size.
        offset = attribute offset from structure base.
    **/
    void vertexAttributes(uint index, int size, GLenum type, bool normalize, uint stride, uint offset);

    /**
    enable vertex attributes.

    Params:
        index = attributes index.
    */
    void enableVertexAttributes(uint index);

    /**
    disable vertex attributes.

    Params:
        index = attributes index.
    */
    void disableVertexAttributes(uint index);

    /**
    draw elements.

    Params:
        T = index type.
        mode = OpenGL draw mode.
        count = indices count.
        offset = indices offset.
    */
    void draw(T)(GLDrawMode mode, uint count, uint offset)
    if (isIndexType!T)
    {
        draw(mode, count, GLTypeEnum!T, offset);
    }

    /**
    draw elements.

    Params:
        mode = OpenGL draw mode.
        type = index type.
        count = indices count.
        offset = indices offset.
    */
    void draw(GLDrawMode mode, uint count, GLenum type, uint offset);

    /**
    create shader program.

    Params:
        vertexShaderSource = vertex shader source string.
        fragmentShaderSource = fragment shader source string.
    Returns:
        shader program ID.
    */
    ShaderProgramID createShaderProgram(const(char)[] vertexShaderSource, const(char)[] fragmentShaderSource);

    /**
    delete shader program.

    Params:
        id = delete program ID.
    */
    void deleteShaderProgram(ShaderProgramID id);

    /**
    use shader program.

    Params:
        id = shader program ID.
    */
    void useProgram(ShaderProgramID id);

    /**
    unuse shader program.
    */
    void unuseProgram();

    /**
      create vertex array object.

    Returns:
        vertex array object ID.
    */
    VertexArrayID createVAO();

    /**
    delete vertex array object ID.

    Params:
        delete vertex array object.
    */
    void deleteVAO(VertexArrayID id);

    /**
    bind vertex array object.

    Params:
        id = vertex array object ID.
    */
    void bind(VertexArrayID id);

    /**
    unbind vertex array object.
    */
    void unbindVAO();

    /**
    get uniform location number.

    Params:
        program = program ID.
        name = uniform variable name.
    Returns:
        uniform location.
    */
    UniformLocation getUniformLocation(ShaderProgramID program, const(char)[] name);

    /**
    set an uniform variable.

    Params:
        location = uniform location.
        m = matrix.
    */
    void uniform(UniformLocation location, scope ref const(Mat4) m);

    /**
    Returns:
        max texture size.
    */
    uint getMaxTextureSize();

    /**
    create a texture.

    Returns:
        texture name.
    Throws:
        `OpenGLException` thrown if failed.
    */
    TextureID createTexture();

    /**
    bind a texture.

    Params:
        target = texture target.
        id = texture ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void bind(GLTextureParameterTarget target, TextureID);

    /**
    unbind a texture.

    Params:
        target = texture target.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void unbindTexture(GLTextureParameterTarget target);

    /**
    delete texture object.

    Params:
        id = texture ID.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void deleteTexture(TextureID id);

    /**
    activate texture.

    Params:
        texture = activate texture.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void activeTexture(GLTextureUnit texture);

    /**
    set texture pixel storage alignment.

    Params:
        type = pixel store type.
        alignment = pixel row alignment
    Throws:
        `OpenGLException` thrown if failed.
    */
    void pixelStore(GLPixelStoreType type, GLPixelStoreAlignment alignment);

    /**
    set texture minify filter.

    Params:
        target = target texture type.
        filter = texture minify filter type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void textureMinFilter(GLTextureParameterTarget target, GLTextureMinFilter filter);

    /**
    set texture magnify filter.

    Params:
        target = target texture type.
        filter = texture magnify filter type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void textureMagFilter(GLTextureParameterTarget target, GLTextureMagFilter filter);

    /**
    set texture wrap.

    Params:
        target = target texture type.
        wrapType = texture wrap type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void textureWrapS(GLTextureParameterTarget target, GLTextureWrap wrapType);

    /**
    set texture wrap.

    Params:
        target = target texture type.
        wrapType = texture wrap type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void textureWrapT(GLTextureParameterTarget target, GLTextureWrap wrapType);

    /**
    specify texture image.

    Params:
        T = texel type.
        target = target texture.
        level = mipmap level.
        width = texture width.
        height = texture height.
        format = texel format.
        type = texel type.
        data = texture data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    void textureImage(T)(
            GLTextureImageTarget target,
            uint level,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(T)[] data)
    if (is(T == ubyte) || is(T == ushort))
    in
    {
        assert(data.length == width * height);
        static if(is(T == ubyte))
        {
            assert(type == GLTextureType.unsignedByte);
        }
        else
        {
            assert(type == GLTextureType.unsignedShort565
                || type == GLTextureType.unsignedShort4444
                || type == GLTextureType.unsignedShort5551);
        }
    }
    body
    {
        textureImageVoid(target, level, width, height, format, type, data);
    }

    /**
    specify texture sub image.

    Params:
        target = target texture.
        level = mipmap level.
        offsetX = X axis offset.
        offsetY = Y axis offset.
        width = texture width.
        height = texture height.
        format = texel format.
        type = texel type.
        data = texture data.
    Throws:
        `OpenGLException` thrown if failed.
    */
    private void textureImage(T)(
            GLTextureImageTarget target,
            uint level,
            uint offsetX,
            uint offsetY,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(T)[] data)
    if (is(T == ubyte) || is(T == ushort))
    in
    {
        assert(data.length == width * height);
        static if(is(T == ubyte))
        {
            assert(type == GLTextureType.unsignedByte);
        }
        else
        {
            assert(type == GLTextureType.unsignedShort565
                || type == GLTextureType.unsignedShort4444
                || type == GLTextureType.unsignedShort5551);
        }
    }
    body
    {
        textureImageVoid(
            target, level, offsetX, offsetY, width, height, format, type, data);
    }

    /**
    specify texture image.

    Params:
        target = target texture.
        level = mipmap level.
        width = texture width.
        height = texture height.
        format = texel format.
        type = texel type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    private void textureImageVoid(
            GLTextureImageTarget target,
            uint level,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(void)[] data)
    in
    {
        if (type == GLTextureType.unsignedByte)
        {
            assert(data.length == width * height);
        }
        else
        {
            assert(data.length * 2 == width * height);
        }
    }

    /**
    specify texture sub image.

    Params:
        target = target texture.
        level = mipmap level.
        offsetX = X axis offset.
        offsetY = Y axis offset.
        width = texture width.
        height = texture height.
        format = texel format.
        type = texel type.
    Throws:
        `OpenGLException` thrown if failed.
    */
    private void textureImageVoid(
            GLTextureImageTarget target,
            uint level,
            uint offsetX,
            uint offsetY,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(void)[] data)
    in
    {
        if (type == GLTextureType.unsignedByte)
        {
            assert(data.length == width * height);
        }
        else
        {
            assert(data.length * 2 == width * height);
        }
    }

    /**
    set up OpenGL viewport.

    Params:
        x = lower left position x.
        y = lower left position y.
        width = viewport width.
        height = viewport height.
    */
    void viewport(int x, int y, uint width, uint height);

    /**
    get viewport.

    Returns:
        viewport values.
    */
    Viewport getViewport();

    /**
    set clear color.

    Params:
        red = red value. [0.0, 1.0]
        blue = blue value. [0.0, 1.0]
        green = green value. [0.0, 1.0]
        alpha = alpha value. [0.0, 1.0]
    */
    void clearColor(float red, float blue, float green, float alpha);

    /**
    clear buffer.

    Params:
        bits = clear buffer bits.
    */
    void clear(GLBufferBit bits);

    /**
    flush OpenGL state.
    */
    void flush();

    /**
    Returns:
        OpenGL supported version.
    */
    @property GLSupport support() const @nogc nothrow pure @safe;
}

package:

/**
OpenGL context implementation.
*/
class OpenGLContextImpl : OpenGLContext
{
    /**
    construct with support version.

    Params:
        support = OpenGL support version.
    */
    this(GLSupport support)
    {
        this.support_ = support;
    }

    override
    {

        void enableBlend()
        {
            glEnable(GL_BLEND);
            checkGLError();
        }

        void disableBlend()
        {
            glDisable(GL_BLEND);
            checkGLError();
        }

        void setBlendFunc(GLBlendMode srcFactor, GLBlendMode dstFactor)
        {
            glBlendFunc(srcFactor, dstFactor);
            checkGLError();
        }


        VerticesID createVerticesFromBytes(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }

        void copyRawDataTo(VerticesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(id, offset, data);
        }

        void deleteVertices(VerticesID id)
        {
            deleteBuffer(id);
        }

        void bind(VerticesID id)
        {
            bindBuffer(id);
        }

        void unbindVertices()
        {
            unbindBuffer!VerticesID();
        }
    
        IndicesID createIndicesFromBytes(uint size)
        {
            return createBuffer!(typeof(return))(size);
        }
    
        void copyRawDataTo(IndicesID id, ptrdiff_t offset, const(void)[] data)
        {
            copyToBuffer(id, offset, data);
        }

        void deleteIndices(IndicesID id)
        {
            deleteBuffer(id);
        }

        void vertexAttributes(
            uint index,
            int size,
            GLenum type,
            bool normalize,
            uint stride,
            uint offset)
        {
            glVertexAttribPointer(
                index,
                size,
                type,
                normalize,
                stride,
                cast(const(GLvoid)*) offset);
            checkGLError();
        }

        void enableVertexAttributes(uint index)
        {
            glEnableVertexAttribArray(index);
            checkGLError();
        }

        void disableVertexAttributes(uint index)
        {
            glDisableVertexAttribArray(index);
            checkGLError();
        }

        void bind(IndicesID id)
        {
            bindBuffer(id);
        }

        void unbindIndices()
        {
            unbindBuffer!IndicesID();
        }

        void draw(GLDrawMode mode, uint count, GLenum type, uint offset)
        {
            glDrawElements(mode, count, type, cast(const(GLvoid)*) offset);
            checkGLError();
        }

        ShaderProgramID createShaderProgram(
                const(char)[] vertexShaderSource,
                const(char)[] fragmentShaderSource)
        {
            return ShaderProgramID(.createShaderProgram(vertexShaderSource, fragmentShaderSource));
        }

        void useProgram(ShaderProgramID id)
        {
            glUseProgram(cast(GLuint) id);
            checkGLError();
        }

        void unuseProgram()
        {
            glUseProgram(0);
            checkGLError();
        }

        void deleteShaderProgram(ShaderProgramID id)
        {
            glDeleteProgram(cast(GLuint) id);
            checkGLError();
        }

        VertexArrayID createVAO()
        {
            GLuint id;
            glGenVertexArrays(1, &id);
            checkGLError();
            return VertexArrayID(id);
        }

        void deleteVAO(VertexArrayID id)
        {
            immutable iid = cast(GLuint) id;
            glDeleteVertexArrays(1, &iid);
            checkGLError();
        }

        void bind(VertexArrayID id)
        {
            glBindVertexArray(cast(GLuint) id);
        }

        void unbindVAO()
        {
            glBindVertexArray(0);
        }

        UniformLocation getUniformLocation(ShaderProgramID program, const(char)[] name)
        {
            immutable result = glGetUniformLocation(cast(GLuint) program, name.toStringz);
            checkGLError();
            return UniformLocation(result);
        }

        void uniform(UniformLocation location, scope ref const(Mat4) m)
        {
            glUniformMatrix4fv(cast(GLint) location, 1, false, m.ptr);
            checkGLError();
        }

        void viewport(int x, int y, uint width, uint height)
        {
            glViewport(x, y, width, height);
            checkGLError();
        }

        Viewport getViewport()
        {
            Viewport result = void;
            glGetFloatv(GL_VIEWPORT, result.values.ptr);
            checkGLError();
            return result;
        }

        uint getMaxTextureSize()
        {
            GLint result = void;
            glGetIntegerv(GL_MAX_TEXTURE_SIZE, &result);
            checkGLError();
            return result;
        }

        TextureID createTexture()
        {
            GLuint id;
            glGenTextures(1, &id);
            checkGLError();
            return TextureID(id);
        }

        void bind(GLTextureParameterTarget target, TextureID id)
        {
            glBindTexture(target, cast(GLuint) id);
        }

        void unbindTexture(GLTextureParameterTarget target)
        {
            glBindTexture(target, 0);
        }

        void deleteTexture(TextureID id)
        {
            immutable value = cast(GLuint) id;
            glDeleteTextures(1, &value);
            checkGLError();
        }

        void activeTexture(GLTextureUnit texture)
        {
            glActiveTexture(texture);
            checkGLError();
        }

        void pixelStore(GLPixelStoreType type, GLPixelStoreAlignment alignment)
        {
            glPixelStorei(type, alignment);
            checkGLError();
        }
    
        void textureMinFilter(GLTextureParameterTarget target, GLTextureMinFilter filter)
        {
            textureParameter(target, GL_TEXTURE_MIN_FILTER, filter);
        }

        void textureMagFilter(GLTextureParameterTarget target, GLTextureMagFilter filter)
        {
            textureParameter(target, GL_TEXTURE_MAG_FILTER, filter);
        }

        void textureWrapS(GLTextureParameterTarget target, GLTextureWrap wrapType)
        {
            textureParameter(target, GL_TEXTURE_WRAP_S, wrapType);
        }

        void textureWrapT(GLTextureParameterTarget target, GLTextureWrap wrapType)
        {
            textureParameter(target, GL_TEXTURE_WRAP_T, wrapType);
        }

        void clearColor(float red, float blue, float green, float alpha)
        {
            glClearColor(red, blue, green, alpha);
            checkGLError();
        }

        void clear(GLBufferBit bits)
        {
            glClear(bits);
            checkGLError();
        }

        void flush()
        {
            glFlush();
        }

        @property GLSupport support() const @nogc nothrow pure @safe
        {
            return support_;
        }
    }

private:

    /// OpenGL support version.
    GLSupport support_;

    T createBuffer(T)(uint size)
    {
        GLuint result;
        glGenBuffers(1, &result);
        checkGLError();

        enum target = GLBufferTypeEnum!T;
        glBindBuffer(target, result);
        scope(exit) glBindBuffer(target, 0);
        glBufferData(target, size, null, GL_STREAM_DRAW);
        checkGLError();
        return T(result);
    }

    void copyToBuffer(T)(
            T typedID,
            ptrdiff_t offset,
            const(void)[] data)
    in
    {
        assert(cast(GLuint) typedID != 0);
    }
    body
    {
        enum target = GLBufferTypeEnum!T;
        immutable id = cast(GLuint) typedID;
        glBindBuffer(target, id);
        scope(exit) glBindBuffer(target, 0);
        glBufferSubData(GLBufferTypeEnum!T, offset, data.length, data.ptr);
        checkGLError();
    }

    void deleteBuffer(T)(T typedID)
    {
        immutable id = cast(GLuint) typedID;
        glDeleteBuffers(1, &id);
        checkGLError();
    }

    void bindBuffer(T)(T typedID)
    {
        immutable id = cast(GLuint) typedID;
        glBindBuffer(GLBufferTypeEnum!T, id);
        checkGLError();
    }

    void unbindBuffer(T)()
    {
        glBindBuffer(GLBufferTypeEnum!T, 0);
        checkGLError();
    }

    void textureParameter(GLenum target, GLenum pname, GLint param)
    {
        glTexParameteri(target, pname, param);
        checkGLError();
    }

    void textureImageVoid(
            GLTextureImageTarget target,
            uint level,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(void)[] data)
    {
        glTexImage2D(
            target,
            level,
            format,
            width,
            height,
            0,
            format,
            type,
            data.ptr);
        checkGLError();
    }

    void textureImageVoid(
            GLTextureImageTarget target,
            uint level,
            uint offsetX,
            uint offsetY,
            uint width,
            uint height,
            GLTextureFormat format,
            GLTextureType type,
            scope const(void)[] data)
    {
        glTexSubImage2D(
            target,
            level,
            offsetX,
            offsetY,
            width,
            height,
            format,
            type,
            data.ptr);
        checkGLError();
    }
}

