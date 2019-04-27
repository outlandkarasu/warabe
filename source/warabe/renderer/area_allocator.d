module warabe.renderer.area_allocator;

import std.typecons : Nullable, nullable;
import std.container : DList;

import warabe.coordinates :
    Point,
    Rectangle,
    Size;

/**
 *  Rectangle area allocator.
 */
struct AreaAllocator
{
    @disable this();
    @disable this(this);

    /**
    Params:
        size = allocation size.
    */
    this()(auto scope ref const(Size) size)
    {
        list_.insertFront(Rectangle(0, 0, size.width, size.height));
    }

    /**
    Params:
        requiredSize = allocating size.
    Returns:
        allocated point if has space.
    */
    Nullable!(immutable(Point)) add()(auto scope ref const(Size) requiredSize)
    {
        for (auto r = list_[]; !r.empty;)
        {
            if (requiredSize.width <= r.front.size.width
                    && requiredSize.height <= r.front.size.height)
            {
                // found space.
                immutable position = r.front.position;
                splitRectangle(r, r.front, requiredSize);
                return position.nullable;
            }
        }

        // space not found.
        return typeof(return).init;
    }

private:

    void splitRectangle(R)(ref R r, ref Rectangle rect, ref const(Size) size)
    {
        if (rect.size.height > size.height)
        {
            // insert rest piece.
            list_.insertAfter(r, Rectangle(
                 rect.position.x,
                 rect.position.y + size.height,
                 rect.size.width,
                 rect.size.height - size.height));
            rect.size.height = size.height;
        }

        // shrink current piece.
        rect.size.width -= size.width;
        rect.position.x += size.width;

        if (rect.size.width == 0)
        {
            list_.popFirstOf(r);
        }
    }

    DList!(Rectangle) list_;
}

///
unittest
{
    import std.conv : to;
    auto allocator = AreaAllocator(Size(50, 30));
    immutable pos1 = allocator.add(Size(20, 20));
    assert(!pos1.isNull);
    assert(pos1.x == 0, pos1.x.to!string);
    assert(pos1.y == 0);

    immutable pos2 = allocator.add(Size(30, 20));
    assert(!pos2.isNull);
    assert(pos2.x == 20);
    assert(pos2.y == 0);

    immutable pos3 = allocator.add(Size(50, 10));
    assert(!pos3.isNull);
    assert(pos3.x == 0);
    assert(pos3.y == 20);

    immutable pos4 = allocator.add(Size(1, 1));
    assert(pos4.isNull);
}

