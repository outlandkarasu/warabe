/**
Application module.
*/
module app;

import warabe.primitives : Position, Size;
import warabe.sdl : runApplication;

/**
Main function.
*/
void main()
{
    runApplication((scope windowFactory) {
        auto window = windowFactory.create(
                "test window",
                Position(100, 100),
                Size(640, 480));
        scope(exit) destroy(window);
    });
}

