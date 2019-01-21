module warabe.coodinates;

///
struct Point
{
    int x;
    int y;
}

///
struct Size
{
    uint width;
    uint height;
}

///
struct Rectangle
{
    Point position;
    Size size;

    @nogc nothrow @property pure @safe const
    {
        int x() { return position.x; }
        int y() { return position.y; }

        int left() { return x; }
        int top() { return y; }
        int right() { return x + width; }
        int bottom() { return y + height; }

        uint width() { return size.width; }
        uint height() { return size.height; }
    }
}

