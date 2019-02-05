module warabe.lina.matrix;

import std.conv : to;
import std.traits : isNumeric;

/**
column major matrix structure.

Params:
    E = element type.
    R = row count.
    C = column count.
*/
struct Matrix(E, size_t R, size_t C)
{
    static assert(R > 0 && C > 0);
    static assert(isNumeric!E);

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

        ref typeof(this) fill(E value)
        {
            foreach (ref col; elements_)
            {
                col[] = value;
            }
            return this;
        }

        ///
        unittest
        {
            auto m = Matrix!(int, 2, 2)();
            m.fill(999);
            assert(m[0, 0] == 999);
            assert(m[1, 0] == 999);
            assert(m[0, 1] == 999);
            assert(m[1, 1] == 999);
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

/**
to identity matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
Returns:
    identity matrix.
*/
@nogc nothrow pure @safe
ref auto identity(E, size_t D)(auto ref return Matrix!(E, D, D) m)
{
    m.fill(cast(E) 0);
    for (size_t i = 0; i < D; ++i)
    {
        m[i, i] = cast(E) 1;
    }
    return m;
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 2, 2)().identity;
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 0], 0.0f));
    assert(approxEqual(m[0, 1], 0.0f));
    assert(approxEqual(m[1, 1], 1.0f));
}

/**
create identity matrix.

Params:
    E = element type.
    D = row and column count.
Returns:
    identity matrix.
*/
@nogc nothrow pure @safe
auto identity(E, size_t D)()
{
    Matrix!(E, D, D) m = void;
    return m.identity;
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = identity!(float, 2);
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 0], 0.0f));
    assert(approxEqual(m[0, 1], 0.0f));
    assert(approxEqual(m[1, 1], 1.0f));
}

