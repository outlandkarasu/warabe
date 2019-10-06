/**
OpenGL type module.
*/
module warabe.opengl.types;

import gl = bindbc.opengl;

/**
OpenGL type enum.
*/
template GLType(T) if(is(T == byte))
{
    enum GLType = gl.GL_BYTE;
}

/// ditto
template GLType(T) if(is(T == ubyte))
{
    enum GLType = gl.GL_UNSIGNED_BYTE;
}

/// ditto
template GLType(T) if(is(T == short))
{
    enum GLType = gl.GL_SHORT;
}

/// ditto
template GLType(T) if(is(T == ushort))
{
    enum GLType = gl.GL_UNSIGNED_SHORT;
}

/// ditto
template GLType(T) if(is(T == float))
{
    enum GLType = gl.GL_FLOAT;
}

/**
OpenGL typed name value.
*/
struct GLTypedName(E, E nameType)
{
    static assert(is(E == enum));

    /**
    Name type.
    */
    enum TYPE = nameType;

    /**
    cast value.
    Returns:
        buffer value.
    */
    gl.GLuint opCast(T)() const @nogc nothrow pure @safe
    if(is(T == gl.GLuint))
    {
        return name_;
    }

    /**
    Returns:
        buffer type.
    */
    @property E type() const @nogc nothrow pure @safe
    {
        return nameType;
    }

private:
    gl.GLuint name_;
}

