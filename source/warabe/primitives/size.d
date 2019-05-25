/**
Size module.
*/
module warabe.primitives.size;

/**
Size structure.
*/
struct Size
{
    /**
    width size.
    */
    uint width;

    /**
    height size.
    */
    uint height;

    /**
    Calculate size.
    */
    @property uint size() const @nogc nothrow pure @safe
    {
        return width * height;
    }
}

///
@nogc nothrow pure @safe unittest
{
    auto s = Size();
    assert(s.width == 0);
    assert(s.height == 0);
    assert(s.size == 0);
}

///
@nogc nothrow pure @safe unittest
{
    auto s = Size(100, 200);
    assert(s.width == 100);
    assert(s.height == 200);
    assert(s.size == 100 * 200);
}

