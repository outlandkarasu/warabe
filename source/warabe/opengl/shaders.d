/**
OpenGL shaders module.
*/
module warabe.opengl.shaders;

import std.typecons : Typedef;

import gl = bindbc.opengl;

/**
Shader type.
*/
enum GLShaderType
{
    vertexShader = gl.GL_VERTEX_SHADER,
    fragmentShader = gl.GL_FRAGMENT_SHADER,
}

/**
OpenGL shader ID type.
*/
alias GLShader = Typedef!(gl.GLuint, gl.GLuint.init, "GLShader");

/**
create shader.

Params:
    shaderType = shader type.
Returns:
    shader ID.
*/
GLShader createShader(GLShaderType shaderType) @nogc nothrow
{
    return GLShader(gl.glCreateShader(shaderType));
}

/**
delete shader.

Params:
    shader = target shader.
*/
void deleteShader(GLShader shader) @nogc nothrow
{
    gl.glDeleteShader(cast(gl.GLuint) shader);
}

/**
read shader source.

Params:
    shader = target shader.
    source = shader source string.
*/
void shaderSource(GLShader shader, scope const(char)[] source) @nogc nothrow
{
    const(gl.GLchar)*[1] sources = [
        source.length > 0 ? &source[0] : null
    ];
    immutable gl.GLint[1] length = [cast(gl.GLint) source.length];
    gl.glShaderSource(
        cast(gl.GLuint) shader, 1, &sources[0], &length[0]);
}

/**
compile shader.

Params:
    shader = target shader.
*/
void compileShader(GLShader shader) @nogc nothrow
{
    gl.glCompileShader(cast(gl.GLuint) shader);
}

/**
Shader parameter type.
*/
enum GLShaderParameter
{
    shaderType = gl.GL_SHADER_TYPE,
    deleteStatus = gl.GL_DELETE_STATUS,
    compileStatus = gl.GL_COMPILE_STATUS,
    infoLogLength = gl.GL_INFO_LOG_LENGTH,
    shaderSourceLength = gl.GL_SHADER_SOURCE_LENGTH,
}

/**
get shader parameter.

Params:
    shader = target shader.
    parameter = parameter type.
Returns:
    shader parameter.
*/
gl.GLint getShaderParameter(GLShader shader, GLShaderParameter parameter) @nogc nothrow
{
    gl.GLint result;
    gl.glGetShaderiv(cast(gl.GLuint) shader, parameter, &result);
    return result;
}

/**
get shader info log.

Params:
    shader = target shader.
    buffer = destination buffer.
*/
void getShaderInfoLog(GLShader shader, scope char[] buffer) @nogc nothrow
{
    gl.glGetShaderInfoLog(
        cast(gl.GLuint) shader,
        cast(gl.GLsizei) buffer.length,
        null,
        (buffer.length > 0) ? &buffer[0] : null);
}

/**
OpenGL program type.
*/
alias GLProgram = Typedef!(gl.GLuint, gl.GLuint.init, "GLProgram");

/**
create OpenGL program.

Returns:
    OpenGL program.
*/
GLProgram createProgram() @nogc nothrow
{
    return GLProgram(gl.glCreateProgram());
}

/**
delete OpenGL program.

Params:
    program = OpenGL program.
*/
void deleteProgram(GLProgram program) @nogc nothrow
{
    gl.glDeleteProgram(cast(gl.GLuint) program);
}

/**
use OpenGL program.

Params:
    program = OpenGL program.
*/
void useProgram(GLProgram program) @nogc nothrow
{
    gl.glUseProgram(cast(gl.GLuint) program);
}

/**
Attach shader to program.

Params:
    program = target program.
    shader = attach shader.
*/
void attachShader(GLProgram program, GLShader shader) @nogc nothrow
{
    gl.glAttachShader(cast(gl.GLuint) program, cast(gl.GLuint) shader);
}

/**
Detach shader to program.

Params:
    program = target program.
    shader = detach shader.
*/
void detachShader(GLProgram program, GLShader shader) @nogc nothrow
{
    gl.glDetachShader(cast(gl.GLuint) program, cast(gl.GLuint) shader);
}

/**
Link program.

Params:
    program = target program.
*/
void linkProgram(GLProgram program) @nogc nothrow
{
    gl.glLinkProgram(cast(gl.GLuint) program);
}

/**
Program parameter type.
*/
enum GLProgramParameter
{
    deleteStatus = gl.GL_DELETE_STATUS,
    linkStatus = gl.GL_LINK_STATUS,
    validateStatus = gl.GL_VALIDATE_STATUS,
    infoLogLength = gl.GL_INFO_LOG_LENGTH,
    attachedShaders = gl.GL_ATTACHED_SHADERS,
    activeAttributes = gl.GL_ACTIVE_ATTRIBUTES,
    activeAttributeMaxLength = gl.GL_ACTIVE_ATTRIBUTE_MAX_LENGTH,
    activeUniforms = gl.GL_ACTIVE_UNIFORMS,
    activeUniformMaxLength = gl.GL_ACTIVE_UNIFORM_MAX_LENGTH,
    transformFeedbackBufferMode = gl.GL_TRANSFORM_FEEDBACK_BUFFER_MODE,
    transformFeedbackVaryings = gl.GL_TRANSFORM_FEEDBACK_VARYINGS,
    transformFeedbackVaryingMaxLength = gl.GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH,
}

/**
Get a program parameter.

Params:
    program = target program.
    parameter = target parameter.
Returns:
    program parameter.
*/
gl.GLint getProgramParameter(GLProgram program, GLProgramParameter parameter) @nogc nothrow
{
    gl.GLint result;
    gl.glGetProgramiv(cast(gl.GLuint) program, parameter, &result);
    return result;
}

