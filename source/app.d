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
            rectangles_ = new RectangleBufferEntry(context, program_, 3);
            rectangles_.add(Rectangle(5, 5, 100, 200), Color(255, 0, 0, 0));
            rectangles_.add(Rectangle(10, 25, 10, 20), Color(0, 255, 0, 0));
            rectangles_.add(Rectangle(13, 29, 20, 10), Color(0, 0, 255, 0));
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

