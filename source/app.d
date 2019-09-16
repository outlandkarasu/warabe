/**
Application module.
*/
module app;

import std.string : toStringz;

import warabe : usingWarabe;
import warabe.sdl :
    createWindow,
    delay,
    destroyWindow,
    enforceSdl,
    WindowFlags,
    WindowPos;

/**
Main function.
*/
void main()
{
    usingWarabe!({
        auto window = createWindow(
            toStringz(""),
            WindowPos.centered,
            WindowPos.centered,
            640,
            480,
            WindowFlags.shown).enforceSdl;
        scope(exit) destroyWindow(window);

        delay(5000);
    });
}

