module warabe.lina.matrix;

import std.conv : to;

/**
column major matrix structure.

Params:
    E = element type.
    R = row count.
    C = column count.
*/
struct Matrix(E, size_t R, size_t C)
{
    alias ElementType = E;

    enum
    {
        ROWS = R,
        COLUMNS = C,
    }

    @nogc nothrow pure @safe
    {
        ref const(E) opIndex(size_t row, size_t col) const
        in
        {
            assert(row < R);
            assert(col < C);
        }
        body
        {
            return elements_[col][row];
        }

        E opIndexAssign(E value, size_t row, size_t col)
        in
        {
            assert(row < R);
            assert(col < C);
        }
        body
        {
            return (elements_[col][row] = value);
        }
    }

    @safe string toString() const
    {
        return elements_.to!string;
    }

private:

    E[ROWS][COLUMNS] elements_;
}

///
@safe unittest
{
    auto m = Matrix!(int, 2, 2)();
    assert(m.toString == "[[0, 0], [0, 0]]", m.toString);
}


///
@safe unittest
{
    auto m = Matrix!(float, 2, 2)();
    m[0, 0] = 1.0f;
    m[0, 1] = 2.0f;
    m[1, 0] = 3.0f;
    m[1, 1] = 4.0f;
    assert(m.toString == "[[1, 3], [2, 4]]", m.toString);
}

