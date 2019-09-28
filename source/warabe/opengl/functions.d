/**
OpenGL functions module.
*/
module warabe.opengl.functions;

import gl = bindbc.opengl;

import bindbc.opengl :
    GLint,
    GLsizei
    ;

/**
set viewport.

Params:
    x = left position.
    y = lower position.
    width = viewport width.
    height = viewport height.
*/
void viewport(GLint x, GLint y, GLsizei width, GLsizei height) @nogc nothrow
{
    gl.glViewport(x, y, width, height);
}

/**
OpenGL capabilities.
*/
enum GLCapability
{
    blend = gl.GL_BLEND,
    colorLogicOp = gl.GL_COLOR_LOGIC_OP,
    cullFace = gl.GL_CULL_FACE,
    depthClamp = gl.GL_DEPTH_CLAMP,
    depthTest = gl.GL_DEPTH_TEST,
    dither = gl.GL_DITHER,
    lineSmooth = gl.GL_LINE_SMOOTH,
    multiSample = gl.GL_MULTISAMPLE,
    polygonOffsetFill = gl.GL_POLYGON_OFFSET_FILL,
    polygonOffsetLine = gl.GL_POLYGON_OFFSET_LINE,
    polygonOffsetPoint = gl.GL_POLYGON_OFFSET_POINT,
    polygonSmooth = gl.GL_POLYGON_SMOOTH,
    rastarizerDiscard = gl.GL_RASTERIZER_DISCARD,
    sampleAlphaToCoverage = gl.GL_SAMPLE_ALPHA_TO_COVERAGE,
    sampleAlphaToOne = gl.GL_SAMPLE_ALPHA_TO_ONE,
    sampleCoverage = gl.GL_SAMPLE_COVERAGE,
    sampleMask = gl.GL_SAMPLE_MASK,
    scissorTest = gl.GL_SCISSOR_TEST,
    stencilTest = gl.GL_STENCIL_TEST,
    programPointSize = gl.GL_PROGRAM_POINT_SIZE,
}

/**
enable a capability.

Params:
    cap = capability.
*/
void enable(GLCapability cap) @nogc nothrow
{
    gl.glEnable(cap);
}

/**
disable a capability.

Params:
    cap = capability.
*/
void disable(GLCapability cap) @nogc nothrow
{
    gl.glDisable(cap);
}

