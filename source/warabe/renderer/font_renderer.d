module warabe.renderer.font_renderer;

import std.exception : enforce;
import std.string : fromStringz, toStringz;

import bindbc.sdl :
    SDL_Color,
    SDL_FreeSurface,
    SDL_Surface;

import bindbc.sdl.ttf :
    TTF_CloseFont,
    TTF_Font,
    TTF_GetError,
    TTF_OpenFontIndex,
    TTF_RenderUTF8_Blended;

import std.experimental.allocator.mallocator : Mallocator;
import std.experimental.allocator : TypedAllocator;

import warabe.exception : WarabeException;
import warabe.opengl :
    GLTextureFormat,
    GLTextureImageTarget,
    GLTextureType,
    OpenGLContext,
    TextureID;

package:

///
struct FontRenderer
{
    @disable this();
    @disable this(this);

    /**
    construct font renderer. 

    Params:
        context = OpenGL context.
        fontPath = font file path.
        pointSize = render point size.
        index = font face index.
    */
    this(
            scope OpenGLContext context,
            scope const(char)[] fontPath,
            int pointSize,
            long index)
    in
    {
        assert(context !is null);
        assert(fontPath !is null);
    }
    body
    {
        this.font_ = ttfEnforce(TTF_OpenFontIndex(
            toStringz(fontPath), pointSize, index));
        this.allocator_ = Allocator();
    }

    /**
    render text and call delegater.

    Params:
        text = render text.
        dg = surface action.
    */
    void duringRender(
            scope const(char)[] text,
            scope void delegate(scope SDL_Surface*) dg)
    in
    {
        assert(text !is null);
        assert(dg !is null);
    }
    body
    {
        immutable color = SDL_Color(0, 0, 0);
        auto surface = ttfEnforce(TTF_RenderUTF8_Blended(font_, toStringz(text), color));
        scope(exit) SDL_FreeSurface(surface);

        assert(surface.format.BytesPerPixel == 4);
        assert(surface.pitch % 4 == 0);

        dg(surface);
    }

    /**
    render text to texture.

    Params:
        text = render text.
        texture = render target texture.
        offsetX = render offset X.
        offsetY = render offset Y.
    */
    void renderToTexture(
            scope const(char)[] text,
            scope OpenGLContext context,
            TextureID texture,
            int offsetX,
            int offsetY)
    in
    {
        assert(text !is null);
        assert(cast(int) texture);
    }
    body
    {
        duringRender(text, (scope surface)
        {
            immutable dataPitch = ((surface.w + 3) / 4) * 4;
            immutable dataSize = dataPitch * surface.h;
            auto data = allocator_.makeArray!ubyte(dataSize);
            scope(exit) allocator_.dispose(data);

            foreach (row; 0 .. surface.h)
            {
                immutable rowBegin = (row * surface.pitch) / 4;
                immutable rowEnd = rowBegin + surface.w;
                const rowPixels = (cast(const(uint)*)surface.pixels)[rowBegin .. rowEnd];
                foreach(col, pixel; rowPixels)
                {
                    immutable alpha = (pixel & surface.format.Amask) >> surface.format.Ashift;
                    data[row * dataPitch + col] = cast(ubyte) alpha;
                }
            }

            context.textureImage(
                GLTextureImageTarget.texture2D,
                0,
                offsetX,
                offsetY,
                surface.w,
                surface.h,
                GLTextureFormat.alpha,
                GLTextureType.unsignedByte,
                data);
        });
    }

    /**
    destruct font renderer.
    */
    ~this()
    {
        TTF_CloseFont(font_);
        font_ = null;
    }

private:

    alias Allocator = TypedAllocator!Mallocator;

    Allocator allocator_;
    TTF_Font* font_;
}

private:

/**
SDL_ttf related exception.
*/
class TTFException : WarabeException
{
    /// constructor from super class.
    pure nothrow @nogc @safe this(
            string msg,
            string file = __FILE__,
            size_t line = __LINE__,
            Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

/**
Returns:
    last SDL_ttf error string.
*/
nothrow @nogc @system const(char)[] ttfGetError()
{
    return fromStringz(TTF_GetError());
}

/// enforce function for SDL_ttf.
T ttfEnforce(T)(T value, lazy const(char)[] msg, string file = __FILE__, size_t line = __LINE__)
{
    return enforce!TTFException(value, msg, file, line);
}

/// ditto
T ttfEnforce(T)(T value, string file = __FILE__, size_t line = __LINE__)
{
    return ttfEnforce(value, ttfGetError, file, line);
}

