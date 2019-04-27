import warabe.application :
    Application,
    ApplicationParameters,
    run;

import warabe.coordinates : Rectangle;
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

    ubyte n = 0;

    override void draw(scope ref Renderer renderer)
    {
        renderer.ellipse(Rectangle(5, 5, 100, 200), Color(n, 0, 0, n));
        renderer.ellipse(Rectangle(13, 29, 20, 10), Color(128, 128, 128, n));
        renderer.ellipse(Rectangle(10, 25, 10, 20), Color(0, 255, 255, n));
        ++n;
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

