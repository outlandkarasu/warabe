/**
Application module.
*/
module app;

import std.string : toStringz;
import std.exception : assumeUnique;

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

            immutable program = buildProgram(import("plane.vert"), import("plane.frag"));
            scope(exit) gl.deleteProgram(program);

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

/// build program.
gl.GLProgram buildProgram(
        scope const(char)[] vertexShaderSource,
        scope const(char)[] fragmentShaderSource)
{
    immutable vertexShader = compileShader!(gl.GLShaderType.vertexShader)(
            vertexShaderSource);
    scope(exit) gl.deleteShader(vertexShader);

    immutable fragmentShader = compileShader!(gl.GLShaderType.fragmentShader)(
            fragmentShaderSource);
    scope(exit) gl.deleteShader(fragmentShader);

    immutable program = gl.createProgram();
    scope(failure) gl.deleteProgram(program);

    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    immutable linkStatus = gl.getProgramParameter(
            program, gl.GLProgramParameter.linkStatus);

    if (!linkStatus)
    {
        immutable length = gl.getProgramParameter(
                program, gl.GLProgramParameter.infoLogLength);
        if (length > 0)
        {
            auto log = new char[length];
            throw new gl.OpenGLException(assumeUnique(log[]));
        }
        else
        {
            throw new gl.OpenGLException("link error");
        }
    }

    return program;
}

/// compile shader.
gl.GLShader!type compileShader(gl.GLShaderType type)(
        scope const(char)[] source)
{
    immutable shader = gl.createShader!type();
    scope(failure) gl.deleteShader(shader);

    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    immutable compileStatus = gl.getShaderParameter(
            shader, gl.GLShaderParameter.compileStatus);
    if (!compileStatus)
    {
        immutable length = gl.getShaderParameter(
                shader, gl.GLShaderParameter.infoLogLength);
        if (length > 0)
        {
            auto log = new char[length];
            gl.getShaderInfoLog(shader, log[]);
            throw new gl.OpenGLException(assumeUnique(log[]));
        }
        else
        {
            throw new gl.OpenGLException("compile error");
        }
    }

    return shader;
}

