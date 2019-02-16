import warabe.application :
    Application,
    ApplicationParameters,
    run;

import warabe.coodinates : Rectangle;
import warabe.color: Color;

import warabe.event :
    DefaultEventHandler,
    EventHandlerResult;

import warabe.opengl :
    OpenGLContext,
    ShaderProgramID;

import warabe.renderer : RectangleBufferEntry;

import core.stdc.stdio : printf;

class App : Application
{
    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        printf("FPS: %f\n", cast(double) fps);
        return EventHandlerResult.CONTINUE;
    }

    override void render(scope OpenGLContext context)
    {
        if (rectangles_ is null)
        {
            program_ = context.createShaderProgram(
                import("plane.vert"),
                import("plane.frag"));
            rectangles_ = new RectangleBufferEntry(context, program_, 4);
            rectangles_.add(Rectangle(0, 0, 5, 5), Color(255, 255, 255, 0));
        }
        rectangles_.draw();
    }

    mixin DefaultEventHandler;

private:

    RectangleBufferEntry rectangles_;
    ShaderProgramID program_;
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

