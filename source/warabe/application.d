/**
Application module.
*/
module warabe.application;

import warabe.window : WindowFactory;
import warabe.event : EventLoop;

/**
Application structure..
*/
struct Application
{
    @disable this();

    /**
    construct by instances.

    Params:
        windowFactory = window factory.
        eventLoop = main event loop.
    */
    @nogc nothrow pure @safe this(WindowFactory windowFactory, EventLoop eventLoop)
    in
    {
        assert(windowFactory);
        assert(eventLoop);
    }
    body
    {
        this.windowFactory = windowFactory;
        this.eventLoop = eventLoop;
    }

    /**
    window factory.
    */
    WindowFactory windowFactory;

    /**
    event loop.
    */
    EventLoop eventLoop;
}

