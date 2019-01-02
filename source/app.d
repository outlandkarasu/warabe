import warabe.application : ApplicationParameters, run;
import warabe.event : EventHandler, DefaultEventHandler, EventHandlerResult;

import core.stdc.stdio : printf;

class AppEventHandler : EventHandler
{
    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        printf("FPS: %f\n", cast(double) fps);
        return EventHandlerResult.CONTINUE;
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
    scope eventHandler = new AppEventHandler();
    auto params = ApplicationParameters("test");
    run(params, eventHandler, () {});
}

