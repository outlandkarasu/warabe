module warabe.application;

import warabe.event : EventHandler;
import warabe.sdl : runSDL;

///
struct ApplicationParameters
{
    string windowTitle = "Warabe";
    uint windowPositionX = 0;
    uint windowPositionY = 0;
    uint windowWidth = 800;
    uint windowHeight = 600;
    uint fps = 60;
}

/**
running warabe application.

Params:
    params = application parameters.
    eventHandler = main loop event handler.
*/
void run(ref const(ApplicationParameters) params, scope EventHandler eventHandler)
{
    runSDL(params, eventHandler);
}

/// FPS counter.
struct FrameCounter {
@nogc @safe nothrow:

    /**
    reset clock and counter.

    Params:
        clock = current clock.
    */
    void reset(ulong clock)
    {
        clock_ = clock;
        count_ = 0;
    }

    /**
    increment frame count.
    */
    void increment()
    {
        ++count_;
    }

    /**
    calculate frame count.

    Params:
        clock = current clock.
    Returns:
        frame per clock.
    */
    double calculateFramesPerClock(ulong clock) const pure
    {
        return (clock <= clock_) ? 0.0 : (cast(double) count_) / (clock - clock_);
    }

private:
    ulong clock_;
    size_t count_;
}

///
@nogc nothrow @safe unittest
{
    import std.math : approxEqual;

    auto counter = FrameCounter();
    assert(approxEqual(counter.calculateFramesPerClock(0), 0.0));
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.0));

    counter.increment();
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.1));
    counter.increment();
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.2));
    counter.increment();
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.3));

    counter.reset(10);
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.0));
    assert(approxEqual(counter.calculateFramesPerClock(1), 0.0));
    assert(approxEqual(counter.calculateFramesPerClock(20), 0.0));

    counter.increment();
    assert(approxEqual(counter.calculateFramesPerClock(10), 0.0));
    assert(approxEqual(counter.calculateFramesPerClock(1), 0.0));
    assert(approxEqual(counter.calculateFramesPerClock(20), 0.1));
}
