module warabe.coordinates;

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

    /**
    create from parameters.

    Params:
        x = x position.
        y = y position.
        w = width.
        h = height.
    */
    @nogc nothrow pure @safe this(int x, int y, uint w, uint h)
    {
        this.position = Point(x, y);
        this.size = Size(w, h);
    }

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

