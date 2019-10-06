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

import gl = warabe.opengl;

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
            gl.viewport(0, 0, 640, 480);
            gl.enable(gl.GLCapability.depthTest);

            gl.clearColor(0.0f, 0.0f, 0.0f, 0.0f);
            gl.clear(gl.GLMask.all);

            struct Vertex {
                float[3] position;
                ubyte[3] color;
            }

            immutable Vertex[3] vertices = [
                { [-0.5f, -0.5f,  0.0f], [255,   0,   0] },
                { [ 0.0f,  0.5f,  0.0f], [  0, 255,   0] },
                { [ 0.5f, -0.5f,  0.0f], [  0,   0, 255] },
            ];

            immutable ushort[3] indices = [0, 1, 2];

            immutable verticesBuffer = gl.generateBuffer!(gl.GLBufferType.arrayBuffer);
            scope(exit) gl.deleteBuffer(verticesBuffer);

            gl.bindBuffer(verticesBuffer);
            gl.bufferData(verticesBuffer, vertices[], gl.GLBufferUsage.dynamicDraw);
            gl.unbindBuffer(verticesBuffer.type);

            immutable indicesBuffer = gl.generateBuffer!(gl.GLBufferType.elementArrayBuffer);
            scope(exit) gl.deleteBuffer(indicesBuffer);

            gl.bindBuffer(indicesBuffer);
            gl.bufferData(indicesBuffer, indices[], gl.GLBufferUsage.dynamicDraw);
            gl.unbindBuffer(indicesBuffer.type);

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

