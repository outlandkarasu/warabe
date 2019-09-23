/**
Application module.
*/
module app;

import std.string : toStringz;

import warabe : usingWarabe;

import warabe.opengl :
    checkGLError,
    usingOpenGL;

import warabe.sdl : delay, pollEvent, Event, EventType;

import warabe.sdl : enforceSDL;
import warabe.sdl :
    createWindow,
    destroyWindow,
    WindowFlags,
    WindowPos;
import warabe.sdl.opengl :
    GLAttr,
    GLCreateContext,
    GLDeleteContext,
    GLProfile,
    GLSetAttribute,
    GLSetSwapInterval,
    GLSwapInterval,
    GLSwapWindow;

/**
Main function.
*/
void main()
{
    usingWarabe!({
        GLSetAttribute(GLAttr.contextMajorVersion, 2);
        GLSetAttribute(GLAttr.contextMinorVersion, 0);
        GLSetAttribute(GLAttr.contextProfileMask, GLProfile.core);
        GLSetSwapInterval(GLSwapInterval.adaptiveVsync);

        auto window = createWindow(
            toStringz(""),
            WindowPos.centered,
            WindowPos.centered,
            640,
            480,
            WindowFlags.shown | WindowFlags.openGL).enforceSDL;
        scope(exit) destroyWindow(window);

        auto glContext = GLCreateContext(window);
        scope(exit) GLDeleteContext(glContext);

        usingOpenGL!({
            while (processEvent())
            {
                delay(16);
                GLSwapWindow(window);
                checkGLError();
            }
        });
    });
}

bool processEvent() @nogc nothrow
{
    Event event;
    if (!pollEvent(event))
    {
        return true;
    }

    switch (event.type)
    {
    case EventType.quit:
        return false;
    default:
        break;
    }

    return true;
}

