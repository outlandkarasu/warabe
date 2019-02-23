import warabe.application :
    Application,
    ApplicationParameters,
    run;

import warabe.coodinates : Rectangle;
import warabe.color: Color;

import warabe.event :
    DefaultEventHandler,
    EventHandlerResult;

import warabe.renderer : Renderer;

import core.stdc.stdio : printf;

class App : Application
{
    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        printf("FPS: %f\n", cast(double) fps);
        return EventHandlerResult.CONTINUE;
    }

    override void draw(scope ref Renderer renderer)
    {
        renderer.rectangle(Rectangle(5, 5, 100, 200), Color(255, 0, 0, 0));
        renderer.rectangle(Rectangle(10, 25, 10, 20), Color(0, 255, 0, 0));
        renderer.rectangle(Rectangle(13, 29, 20, 10), Color(0, 0, 255, 0));
    }

    mixin DefaultEventHandler;
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

