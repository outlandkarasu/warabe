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

