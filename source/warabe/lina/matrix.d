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

/**
to scale matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    scales = scale factors.
Returns:
    identity matrix.
*/
@nogc nothrow pure @safe
ref auto scale(E, size_t D, S...)(auto ref return Matrix!(E, D, D) m, S scales)
{
    static assert(D > 1 && S.length < D);
    m.identity();
    static foreach (i, scale; scales)
    {
        m[i, i] = cast(E) scale;
    }
    return m;
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().scale(2.0f);
    assert(approxEqual(m[0, 0], 2.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().scale(2.0f, 3.0f, 4.0f);
    assert(approxEqual(m[0, 0], 2.0f));
    assert(approxEqual(m[1, 1], 3.0f));
    assert(approxEqual(m[2, 2], 4.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to scaling X axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    scale = scale factor.
Returns:
    scaling X axis matrix.
*/
@nogc nothrow pure @safe
ref auto scaleX(E, size_t D)(auto ref return Matrix!(E, D, D) m, E scale)
{
    return m.scale!(E, D)(scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().scaleX(2.0f);
    assert(approxEqual(m[0, 0], 2.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create scaling X axis matrix.

Params:
    E = element type.
    D = row and column count.
    scale = scale factor.
Returns:
    scaling X axis matrix.
*/
@nogc nothrow pure @safe
auto scaleX(E, size_t D)(E scale)
{
    return identity!(E, D).scaleX(scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = scaleX!(float, 4)(2.0f);
    assert(approxEqual(m[0, 0], 2.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to scaling Y axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    scale = scale factor.
Returns:
    scaling Y axis matrix.
*/
@nogc nothrow pure @safe
ref auto scaleY(E, size_t D)(auto ref return Matrix!(E, D, D) m, E scale)
{
    return m.scale!(E, D)(1, scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().scaleY(2.0f);
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 2.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create scaling Y axis matrix.

Params:
    E = element type.
    D = row and column count.
    scale = scale factor.
Returns:
    scaling Y axis matrix.
*/
@nogc nothrow pure @safe
auto scaleY(E, size_t D)(E scale)
{
    return identity!(E, D).scaleY(scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = scaleY!(float, 4)(2.0f);
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 2.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to scaling Z axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    scale = scale factor.
Returns:
    scaling Z axis matrix.
*/
@nogc nothrow pure @safe
ref auto scaleZ(E, size_t D)(auto ref return Matrix!(E, D, D) m, E scale)
{
    return m.scale!(E, D)(1, 1, scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().scaleZ(2.0f);
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 2.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create scaling Z axis matrix.

Params:
    E = element type.
    D = row and column count.
    scale = scale factor.
Returns:
    scaling Z axis matrix.
*/
@nogc nothrow pure @safe
auto scaleZ(E, size_t D)(E scale)
{
    return identity!(E, D).scaleZ(scale);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = scaleZ!(float, 4)(2.0f);
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 2.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to move matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    dists = move distances..
Returns:
    identity matrix.
*/
@nogc nothrow pure @safe
ref auto move(E, size_t D, DS...)(auto ref return Matrix!(E, D, D) m, DS dists)
{
    static assert(D > 1 && DS.length < D);
    m.identity();
    static foreach (i, dist; dists)
    {
        m[i, D - 1] = cast(E) dist;
    }
    return m;
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().move(2.0f);
    assert(approxEqual(m[0, 3], 2.0f));
    assert(approxEqual(m[1, 3], 0.0f));
    assert(approxEqual(m[2, 3], 0.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().move(2.0f, 3.0f, 4.0f);
    assert(approxEqual(m[0, 3], 2.0f));
    assert(approxEqual(m[1, 3], 3.0f));
    assert(approxEqual(m[2, 3], 4.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to move X axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    dist = move distance.
Returns:
    moving X axis matrix.
*/
@nogc nothrow pure @safe
ref auto moveX(E, size_t D)(auto ref return Matrix!(E, D, D) m, E dist)
{
    return m.move!(E, D)(dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().moveX(2.0f);
    assert(approxEqual(m[0, 3], 2.0f));
    assert(approxEqual(m[1, 3], 0.0f));
    assert(approxEqual(m[2, 3], 0.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create moving X axis matrix.

Params:
    E = element type.
    D = row and column count.
    dist = moving distance..
Returns:
    moving X axis matrix.
*/
@nogc nothrow pure @safe
auto moveX(E, size_t D)(E dist)
{
    return identity!(E, D).moveX(dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = moveX!(float, 4)(2.0f);
    assert(approxEqual(m[0, 3], 2.0f));
    assert(approxEqual(m[1, 3], 0.0f));
    assert(approxEqual(m[2, 3], 0.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to move Y axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    dist = move distance.
Returns:
    moving Y axis matrix.
*/
@nogc nothrow pure @safe
ref auto moveY(E, size_t D)(auto ref return Matrix!(E, D, D) m, E dist)
{
    return m.move!(E, D)(0, dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().moveY(2.0f);
    assert(approxEqual(m[0, 3], 0.0f));
    assert(approxEqual(m[1, 3], 2.0f));
    assert(approxEqual(m[2, 3], 0.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create moving Y axis matrix.

Params:
    E = element type.
    D = row and column count.
    dist = moving distance..
Returns:
    moving Y axis matrix.
*/
@nogc nothrow pure @safe
auto moveY(E, size_t D)(E dist)
{
    return identity!(E, D).moveY(dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = moveY!(float, 4)(2.0f);
    assert(approxEqual(m[0, 3], 0.0f));
    assert(approxEqual(m[1, 3], 2.0f));
    assert(approxEqual(m[2, 3], 0.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
to move Z axis matrix.

Params:
    E = element type.
    D = row and column count.
    m = target matrix.
    dist = move distance.
Returns:
    moving Z axis matrix.
*/
@nogc nothrow pure @safe
ref auto moveZ(E, size_t D)(auto ref return Matrix!(E, D, D) m, E dist)
{
    return m.move!(E, D)(0, 0, dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = Matrix!(float, 4, 4)().moveZ(2.0f);
    assert(approxEqual(m[0, 3], 0.0f));
    assert(approxEqual(m[1, 3], 0.0f));
    assert(approxEqual(m[2, 3], 2.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

/**
create moving Z axis matrix.

Params:
    E = element type.
    D = row and column count.
    dist = moving distance..
Returns:
    moving Z axis matrix.
*/
@nogc nothrow pure @safe
auto moveZ(E, size_t D)(E dist)
{
    return identity!(E, D).moveZ(dist);
}

///
@nogc nothrow pure @safe unittest
{
    import std.math : approxEqual;
    auto m = moveZ!(float, 4)(2.0f);
    assert(approxEqual(m[0, 3], 0.0f));
    assert(approxEqual(m[1, 3], 0.0f));
    assert(approxEqual(m[2, 3], 2.0f));
    assert(approxEqual(m[0, 0], 1.0f));
    assert(approxEqual(m[1, 1], 1.0f));
    assert(approxEqual(m[2, 2], 1.0f));
    assert(approxEqual(m[3, 3], 1.0f));
}

