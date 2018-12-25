module warabe.application;

import warabe.sdl : initializeSDL, finalizeSDL;

/**
running warabe application.

Params:
    args = command line arguments.
*/
void run(string[] args)
{
    initializeSDL();
    scope(exit) finalizeSDL();
}

