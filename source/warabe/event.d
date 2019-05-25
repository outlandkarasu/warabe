/**
Event module.
*/
module warabe.event;

/**
Loop status.
*/
enum LoopStatus
{
    /**
    continue event loop.
    */
    continueLoop,

    /**
    exit loop.
    */
    exitLoop,
}

/**
Event loop interface.
*/
interface EventLoop
{
    /**
    start event loop.

    Params:
        loopFunction = event loop function.
    */
    void start(scope LoopStatus delegate() loopFunction)
    in
    {
        assert(loopFunction);
    }
}

