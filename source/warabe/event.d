/**
Warabe event module.
*/
module warabe.event;

///
enum EventHandlerResult
{

    /// continue main loop.
    CONTINUE,

    /// quit application.
    QUIT
}

/// main loop event handler.
interface EventHandler
{
@nogc nothrow:

    /// application quit handler.
    EventHandlerResult onQuit();

    /// on FPS count timing.
    EventHandlerResult onFPSCount(float fps);
}

/**
event handler default implementation.
*/
mixin template DefaultEventHandler()
{
    @nogc nothrow override EventHandlerResult onQuit()
    {
        return EventHandlerResult.QUIT;
    }

    @nogc nothrow override EventHandlerResult onFPSCount(float fps)
    {
        return EventHandlerResult.CONTINUE;
    }
}

