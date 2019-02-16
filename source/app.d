import warabe.application :
    Application,
    ApplicationParameters,
    run;

/+
import warabe.coodinates : Rectangle;
import warabe.color: Color;
+/
import warabe.lina.matrix : identity;

import warabe.event :
    DefaultEventHandler,
    EventHandlerResult;

import warabe.opengl :
    GLBufferBit,
    GLDrawMode,
    IndicesID,
    Mat4,
    OpenGLContext,
    ShaderProgramID,
    UniformLocation,
    VertexArrayID,
    VerticesID;

import warabe.renderer : RectangleBufferEntry;

import core.stdc.stdio : printf;

struct Position
{
    float x;
    float y;
    float z;
}

struct Color
{
    ubyte r;
    ubyte g;
    ubyte b;
    ubyte a;
}

struct Vertex
{
    Position position;
    Color color;
}

immutable(Vertex)[] TRIANGLE = [
    { Position(-0.5f, -0.5f, 0.0f), Color(255,   0,   0, 1) },
    { Position( 0.5f, -0.5f, 0.0f), Color(  0, 255,   0, 1) },
    { Position( 0.0f,  0.5f, 0.0f), Color(  0,   0, 255, 1) },
];

immutable ushort[] INDICES = [0, 1, 2];

class App : Application
{
    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        printf("FPS: %f\n", cast(double) fps);
        return EventHandlerResult.CONTINUE;
    }

    override void render(scope OpenGLContext context)
    {
        if (program_ == 0)
        {
            program_ = context.createShaderProgram(
                import("plane.vert"),
                import("plane.frag"));
            vertices_ = context.createVertices!Vertex(3);
            context.copyTo!Vertex(vertices_, 0, TRIANGLE);
            indices_ = context.createIndices!ushort(3);
            context.copyTo!ushort(indices_, 0, INDICES);

            vao_ = context.createVAO();
            context.bind(vao_);
            context.bind(vertices_);
            context.vertexAttributes!(Vertex, float)(0, 3, 0);
            context.enableVertexAttributes(0);
            context.vertexAttributes!(Vertex, ubyte)(1, 3, Vertex.color.offsetof, false);
            context.enableVertexAttributes(1);
            context.bind(indices_);
            context.unbindVAO();
            identity(mvp_);
            mvpLocation_ = context.getUniformLocation(program_, "mvp");
        }
        /+
        if (rectangles_ is null)
        {
            program_ = context.createShaderProgram(
                import("plane.vert"),
                import("plane.frag"));
            rectangles_ = new RectangleBufferEntry(context, program_, 4);
            rectangles_.add(Rectangle(0, 0, 5, 5), Color(255, 255, 255, 0));
        }
        rectangles_.draw();
        +/

        context.clearColor(0.0f, 0.0f, 0.0f, 0.0f);
        context.clear(GLBufferBit.color | GLBufferBit.depth);
        context.useProgram(program_);
        context.bind(vao_);
        context.uniform(mvpLocation_, mvp_);
        context.draw!ushort(GLDrawMode.triangles, 3, 0);
        context.flush();
    }

    mixin DefaultEventHandler;

private:

    RectangleBufferEntry rectangles_;
    VertexArrayID vao_;
    VerticesID vertices_;
    IndicesID indices_;
    ShaderProgramID program_;
    UniformLocation mvpLocation_;
    Mat4 mvp_;
}

/**
entry point.

Params:
    args = command line arguments.
*/
void main(string[] args)
{
    scope app = new App();
    auto params = ApplicationParameters("test");
    run(params, app);
}

