/**
Application module.
*/
module app;

import std.string : toStringz;

import warabe : usingWarabe;

import warabe.sdl : delay, pollEvent, Event, EventType;

import warabe.sdl : enforceSdl;
import warabe.sdl :
    createWindow,
    destroyWindow,
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

        while (processEvent())
        {
            delay(16);
        }
    });
}

bool processEvent() @nogc nothrow
{
    Event event;
    if (!pollEvent(event))
    {
        return true;
    }

    switch (event.type)
    {
    case EventType.quit:
        return false;
    default:
        break;
    }

    return true;
}

