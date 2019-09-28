module warabe.lina.matrix;

import std.algorithm : min;
import std.conv : to;
import std.traits : isNumeric;
import std.math : sin, cos;

import warabe.lina.vector : Vector;

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

    /**
    initialize matrix by values.

    Params:
        values = matrix elements values.
    */
    this(scope const(E)[][] values)
    {
        foreach (r, row; values[0 .. min(R, $)])
        {
            foreach (c, value; row[0 .. min(C, $)])
            {
                elements_[c][r] = value;
            }
        }
    }

    ///
    @safe unittest
    {
        immutable m = Matrix!(int, 2, 2)([[1, 2], [3, 4]]);
        assert(m[0, 0] == 1);
        assert(m[0, 1] == 2);
        assert(m[1, 0] == 3);
        assert(m[1, 1] == 4);
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

        /**
        apply matrix to column vector.
        result = M * v;

        Params:
            v = target vector.
        Returns:
            result vector.
        */
        Vector!(E, R) opBinary(string op)(scope auto ref const Vector!(E, C) v) const
        if (op == "*")
        {
            Vector!(E, R) result = void;
            foreach (r; 0 .. R)
            {
                auto value = cast(E) 0;
                foreach (c; 0 .. C)
                {
                    value += this[r, c] * v[c];
                }
                result[r] = value;
            }
            return result;
        }

        ///
        unittest
        {
            auto m = Matrix!(float, 2, 2)();
            m[0, 0] = 1.0f;
            m[0, 1] = 2.0f;
            m[1, 0] = 3.0f;
            m[1, 1] = 4.0f;
            auto v = Vector!(float, 2)();
            v[0] = 1.0f;
            v[1] = 2.0f;
            immutable result = m * v;

            import std.math : approxEqual;
            assert(approxEqual(result[0], m[0, 0] * v[0] + m[0, 1] * v[1]));
            assert(approxEqual(result[1], m[1, 0] * v[0] + m[1, 1] * v[1]));
        }

        /**
        apply matrix to row vector.
        result = v * M;

        Params:
            v = target vector.
        Returns:
            result vector.
        */
        Vector!(E, C) opBinaryRight(string op)(scope auto ref const Vector!(E, R) v) const
        if (op == "*")
        {
            Vector!(E, C) result = void;
            foreach (c; 0 .. C)
            {
                auto value = cast(E) 0;
                foreach (r; 0 .. R)
                {
                    value += this[r, c] * v[r];
                }
                result[c] = value;
            }
            return result;
        }

        ///
        unittest
        {
            auto m = Matrix!(float, 2, 2)();
            m[0, 0] = 1.0f;
            m[0, 1] = 2.0f;
            m[1, 0] = 3.0f;
            m[1, 1] = 4.0f;
            auto v = Vector!(float, 2)();
            v[0] = 1.0f;
            v[1] = 2.0f;
            immutable result = v * m;

            import std.math : approxEqual;
            assert(approxEqual(result[0], v[0] * m[0, 0] + v[1] * m[1, 0]));
            assert(approxEqual(result[1], v[0] * m[0, 1] + v[1] * m[1, 1]));
        }

        /**
        assign product of two matrix.

        Params:
            lhs = left hand side matrix.
            rhs = right hand side matrix.
        */
        ref typeof(this) productAssign(size_t COL)(
                scope auto ref const(Matrix!(E, R, COL)) lhs,
                scope auto ref const(Matrix!(E, COL, C)) rhs)
        {
            foreach (r; 0 .. R)
            {
                foreach (rc; 0 .. C)
                {
                    auto value = cast(E) 0;
                    foreach (c; 0 .. COL)
                    {
                        value += lhs[r, c] * rhs[c, rc];
                    }
                    this[r, rc] = value;
                }
            }
            return this;
        }

        ///
        unittest
        {
            auto lhs = Matrix!(int, 2, 1)();
            lhs[0, 0] = 2;
            lhs[1, 0] = 3;
            auto rhs = Matrix!(int, 1, 2)();
            rhs[0, 0] = 4;
            rhs[0, 1] = 5;

            auto m = Matrix!(int, 2, 2)();
            m.productAssign(lhs, rhs);
            assert(m[0, 0] == lhs[0, 0] * rhs[0, 0]); 
            assert(m[0, 1] == lhs[0, 0] * rhs[0, 1]); 
            assert(m[1, 0] == lhs[1, 0] * rhs[0, 0]); 
            assert(m[1, 1] == lhs[1, 0] * rhs[0, 1]); 
        }

        /**
        product two matrix.
        result = this rhs;

        Params:
            rhs = right hand side matrix.
        Returns:
            two matrix product.
        */
        Matrix!(E, R, COL) product(size_t COL)(scope auto ref const Matrix!(E, C, COL) rhs) const
        {
            Matrix!(E, R, COL) result = void;
            return result.productAssign(this, rhs);
        }

        ///
        unittest
        {
            auto lhs = Matrix!(int, 2, 1)();
            lhs[0, 0] = 2;
            lhs[1, 0] = 3;
            auto rhs = Matrix!(int, 1, 2)();
            rhs[0, 0] = 4;
            rhs[0, 1] = 5;

            auto m = lhs.product(rhs);
            assert(m[0, 0] == lhs[0, 0] * rhs[0, 0]); 
            assert(m[0, 1] == lhs[0, 0] * rhs[0, 1]); 
            assert(m[1, 0] == lhs[1, 0] * rhs[0, 0]); 
            assert(m[1, 1] == lhs[1, 0] * rhs[0, 1]); 
        }
    }

    /**
    return internal pointer.
    for low layer operation only.

    Returns:
        internal pointer.
    */
    @nogc nothrow pure const(E)* ptr() const
    out(result)
    {
        assert(result !is null);
    }
    body
    {
        return elements_[0].ptr;
    }

    ///
    nothrow @nogc pure unittest
    {
        auto m = Matrix!(int, 2, 2)();
        m[0, 0] = 1;
        m[0, 1] = 2;
        m[1, 0] = 3;
        m[1, 1] = 4;

        const p = m.ptr;
        assert(p[0] == 1);
        assert(p[1] == 3);
        assert(p[2] == 2);
        assert(p[3] == 4);
    }

    @safe string toString() const
    {
        return elements_.to!string;
    }

    ///
    @safe unittest
    {
        auto m = Matrix!(int, 2, 2)();
        assert(m.toString == "[[0, 0], [0, 0]]", m.toString);
    }

private:

    E[ROWS][COLUMNS] elements_;
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
ref auto identity(E, size_t D)(auto ref Matrix!(E, D, D) m)
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

    immutable v = Vector!(float, 2)([1.0f, 1.0f]);
    immutable leftResult = v * m;
    assert(approxEqual(leftResult[0], 1.0f));
    assert(approxEqual(leftResult[1], 1.0f));
    immutable rightResult = m * v;
    assert(approxEqual(rightResult[0], 1.0f));
    assert(approxEqual(rightResult[1], 1.0f));
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
ref auto scale(E, size_t D, S...)(auto ref Matrix!(E, D, D) m, S scales)
{
    static assert(D > 1 && S.length < D);
    m.identity();
    foreach (i, scale; scales)
    {
        m[i, i] = cast(E) scale;
    }
    return m;
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

    immutable v = Vector!(float, 4)([1.0f, 1.0f, 1.0f, 1.0f]);
    immutable leftResult = v * m;
    assert(approxEqual(leftResult[0], 2.0f));
    assert(approxEqual(leftResult[1], 3.0f));
    assert(approxEqual(leftResult[2], 4.0f));
    assert(approxEqual(leftResult[3], 1.0f));
    immutable rightResult = m * v;
    assert(approxEqual(rightResult[0], 2.0f));
    assert(approxEqual(rightResult[1], 3.0f));
    assert(approxEqual(rightResult[2], 4.0f));
    assert(approxEqual(rightResult[3], 1.0f));
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
ref auto scaleX(E, size_t D)(auto ref Matrix!(E, D, D) m, E scale)
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
ref auto scaleY(E, size_t D)(auto ref Matrix!(E, D, D) m, E scale)
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
ref auto scaleZ(E, size_t D)(auto ref Matrix!(E, D, D) m, E scale)
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
    dists = move distances.
Returns:
    move matrix.
*/
@nogc nothrow pure @safe
ref auto move(E, size_t D, DS...)(auto ref Matrix!(E, D, D) m, DS dists)
{
    static assert(D > 1 && DS.length < D);
    m.identity();
    foreach (i, dist; dists)
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

    immutable v = Vector!(float, 4)([1.0f, 1.0f, 1.0f, 1.0f]);
    immutable resultRight = m * v; 
    assert(approxEqual(resultRight[0], 3.0f));
    assert(approxEqual(resultRight[1], 1.0f));
    assert(approxEqual(resultRight[2], 1.0f));
    assert(approxEqual(resultRight[3], 1.0f));
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

    immutable v = Vector!(float, 4)([1.0f, 1.0f, 1.0f, 1.0f]);
    immutable resultRight = m * v; 
    assert(approxEqual(resultRight[0], 3.0f));
    assert(approxEqual(resultRight[1], 4.0f));
    assert(approxEqual(resultRight[2], 5.0f));
    assert(approxEqual(resultRight[3], 1.0f));
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
ref auto moveX(E, size_t D)(auto ref Matrix!(E, D, D) m, E dist)
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
ref auto moveY(E, size_t D)(auto ref Matrix!(E, D, D) m, E dist)
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
ref auto moveZ(E, size_t D)(auto ref Matrix!(E, D, D) m, E dist)
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
    dist = moving distance.
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

@nogc nothrow pure @safe unittest
{
    immutable scale = Matrix!(float, 4, 4)().scale(2.0f, 3.0f, 4.0f);
    immutable move = Matrix!(float, 4, 4)().move(0.5f, -0.5f, 1.0f);
    immutable v = Vector!(float, 4)([1.0f, 1.0f, 1.0f, 1.0f]);

    immutable scaled = scale * v;

    import std.math : approxEqual;
    assert(approxEqual(scaled[0], 2.0f));
    assert(approxEqual(scaled[1], 3.0f));
    assert(approxEqual(scaled[2], 4.0f));
    assert(approxEqual(scaled[3], 1.0f));

    immutable moved = move * v;
    assert(approxEqual(moved[0], 1.5f));
    assert(approxEqual(moved[1], 0.5f));
    assert(approxEqual(moved[2], 2.0f));
    assert(approxEqual(moved[3], 1.0f));

    immutable scaleAndMove = scale.product(move) * v;
    assert(approxEqual(scaleAndMove[0], 1.5f * 2.0f));
    assert(approxEqual(scaleAndMove[1], 0.5f * 3.0f));
    assert(approxEqual(scaleAndMove[2], 2.0f * 4.0f));
    assert(approxEqual(scaleAndMove[3], 1.0f));

    immutable moveAndScale = move.product(scale) * v;
    assert(approxEqual(moveAndScale[0], 2.0f + 0.5f));
    assert(approxEqual(moveAndScale[1], 3.0f - 0.5f));
    assert(approxEqual(moveAndScale[2], 4.0f + 1.0f));
    assert(approxEqual(moveAndScale[3], 1.0f));
}

/**
to rotate X matrix.

Params:
    E = element type.
    m = target matrix.
    rad = rotation radian.
Returns:
    rotate X matrix.
*/
@nogc nothrow pure @safe
ref auto rotateX(E, R)(auto ref Matrix!(E, 4, 4) m, R rad) if(isNumeric!R)
{
    m.identity();
    immutable sinRad = sin(rad);
    immutable cosRad = cos(rad);
    m[1, 1] = cosRad;
    m[1, 2] = sinRad;
    m[2, 1] = -sinRad;
    m[2, 2] = cosRad;
    return m;
}

///
pure @safe unittest
{
    import std.math : approxEqual, PI, sqrt;

    immutable m = Matrix!(float, 4, 4)().rotateX(PI / 3.0f);
    immutable v = Vector!(float, 4)([1.0f, 0.0f, 1.0f, 1.0f]);
    immutable rotated = m * v;
    assert(approxEqual(rotated[], [1.0f, sqrt(3.0f) / 2.0f, 1.0f / 2.0f, 1.0f]));
}

/**
to rotate Y matrix.

Params:
    E = element type.
    m = target matrix.
    rad = rotation radian.
Returns:
    rotate Y matrix.
*/
@nogc nothrow pure @safe
ref auto rotateY(E, R)(auto ref Matrix!(E, 4, 4) m, R rad) if(isNumeric!R)
{
    m.identity();
    immutable sinRad = sin(rad);
    immutable cosRad = cos(rad);
    m[0, 0] = cosRad;
    m[0, 2] = -sinRad;
    m[2, 0] = sinRad;
    m[2, 2] = cosRad;
    return m;
}

///
pure @safe unittest
{
    import std.math : approxEqual, PI, sqrt;

    immutable m = Matrix!(float, 4, 4)().rotateY(PI / 3.0f);
    immutable v = Vector!(float, 4)([1.0f, 1.0f, 0.0f, 1.0f]);
    immutable rotated = m * v;
    assert(approxEqual(rotated[], [1.0f / 2.0f, 1.0f, sqrt(3.0f) / 2.0f, 1.0f]));
}

/**
to rotate Z matrix.

Params:
    E = element type.
    m = target matrix.
    rad = rotation radian.
Returns:
    rotate Y matrix.
*/
@nogc nothrow pure @safe
ref auto rotateZ(E, R)(auto ref Matrix!(E, 4, 4) m, R rad) if(isNumeric!R)
{
    m.identity();
    immutable sinRad = sin(rad);
    immutable cosRad = cos(rad);
    m[0, 0] = cosRad;
    m[0, 1] = sinRad;
    m[1, 0] = -sinRad;
    m[1, 1] = cosRad;
    return m;
}

///
pure @safe unittest
{
    import std.math : approxEqual, PI, sqrt;

    immutable m = Matrix!(float, 4, 4)().rotateZ(PI / 3.0f);
    immutable v = Vector!(float, 4)([0.0f, 1.0f, 1.0f, 1.0f]);
    immutable rotated = m * v;
    assert(approxEqual(rotated[], [sqrt(3.0f) / 2.0f, 1.0f / 2.0f, 1.0f, 1.0f]));
}

