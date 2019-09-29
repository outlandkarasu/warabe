/**
OpenGL type module.
*/
module warabe.opengl.types;

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

