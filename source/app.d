/**
Application module.
*/
module app;

import warabe.primitives : Position, Size;
import warabe.sdl : runApplication;
import warabe.event : LoopStatus;

/**
Main function.
*/
void main()
{
    runApplication((application) {
        auto window = application.windowFactory.create(
                "test window",
                Position(100, 100),
                Size(640, 480));
        scope(exit) destroy(window);

        application.eventLoop.start(() => LoopStatus.continueLoop);
    });
}

