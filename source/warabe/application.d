module warabe.application;

import warabe.sdl : runSDL;

///
struct ApplicationParameters {
    string windowTitle = "Warabe";
    uint windowPositionX = 0;
    uint windowPositionY = 0;
    uint windowWidth = 800;
    uint windowHeight = 600;
}

/**
running warabe application.

Params:
    params = application parameters.
*/
void run(ref const(ApplicationParameters) params)
{
    runSDL(params);
}

