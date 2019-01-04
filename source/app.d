import warabe.application :
    Application,
    ApplicationParameters,
    run;

import warabe.event :
    DefaultEventHandler,
    EventHandlerResult;

import core.stdc.stdio : printf;

class App : Application
{
    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        printf("FPS: %f\n", cast(double) fps);
        return EventHandlerResult.CONTINUE;
    }

    @nogc nothrow override void render()
    {
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

