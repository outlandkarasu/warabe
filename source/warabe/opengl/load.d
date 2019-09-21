/**
OpenGL load module.
*/
module warabe.opengl.load;

import std.traits : isCallable;

static import bindbc.opengl;

import warabe.opengl.exception : OpenGLException;

/**
load OpenGL library and using it.

Params:
    F = function using OpenGL.
*/
void usingOpenGL(alias F)() if(isCallable!F)
{
    loadOpenGL();
    scope(exit) unloadOpenGL();

    F();
}

private:

/**
load OpenGL library.
*/
void loadOpenGL() @system
{
    immutable loadedVersion = bindbc.opengl.loadOpenGL();
    if (loadedVersion == bindbc.opengl.GLSupport.noLibrary)
    {
        throw new OpenGLException("OpenGL not found.");
    }
    else if (loadedVersion == bindbc.opengl.GLSupport.badLibrary)
    {
        throw new OpenGLException("OpenGL bad library.");
    }
    else if (loadedVersion == bindbc.opengl.GLSupport.noContext)
    {
        throw new OpenGLException("OpenGL no context.");
    }
}

/**
unload OpenGL library.
*/
void unloadOpenGL() @system
{
    bindbc.opengl.unloadOpenGL();
}

