module warabe.lina.vector;

import std.conv : to;
import std.traits : isNumeric;

/**
vector structure.

Params:
    E = element type.
    D = dimention.
*/
struct Vector(E, size_t D)
{
    static assert(D > 0);
    static assert(isNumeric!E);

    alias ElementType = E;

    enum
    {
        DIMENTIONS = D,
    }

    @nogc nothrow pure @safe
    {
        ref const(E) opIndex(size_t i) const
        in
        {
            assert(i < D);
        }
        body
        {
            return elements_[i];
        }

        E opIndexAssign(E value, size_t i)
        in
        {
            assert(i < D);
        }
        body
        {
            return (elements_[i] = value);
        }

        ref typeof(this) fill(E value)
        {
            foreach (ref col; elements_)
            {
                col = value;
            }
            return this;
        }

        ///
        unittest
        {
            auto m = Vector!(int, 4)();
            m.fill(999);
            assert(m[0] == 999);
            assert(m[1] == 999);
            assert(m[2] == 999);
            assert(m[3] == 999);
        }
    }

    @safe string toString() const
    {
        return elements_.to!string;
    }


private:

    E[D] elements_;
}

///
@safe unittest
{
    auto m = Vector!(int, 2)();
    assert(m.toString == "[0, 0]", m.toString);
}

///
@safe unittest
{
    auto m = Vector!(float, 2)();
    m[0] = 1.0f;
    m[1] = 2.0f;
    assert(m.toString == "[1, 2]");
}

