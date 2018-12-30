import warabe.application : ApplicationParameters, run;
import warabe.event : EventHandler, DefaultEventHandler, EventHandlerResult;

class AppEventHandler : EventHandler
{
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
    run(params, eventHandler);
}

