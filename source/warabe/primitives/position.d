/**
Position module.  
*/
module warabe.primitives.position;

/**
Position structure.
*/
struct Position
{
    /**
    x position.
    */
    int x;

    /**
    y position.
    */
    int y;
}

///
@nogc nothrow pure @safe unittest
{
    auto p = Position();
    assert(p.x == 0);
    assert(p.y == 0);
}

///
@nogc nothrow pure @safe unittest
{
    auto p = Position(100, 200);
    assert(p.x == 100);
    assert(p.y == 200);
}

///
@nogc nothrow pure @safe unittest
{
    auto p = Position(-100, -200);
    assert(p.x == -100);
    assert(p.y == -200);
}

