/**
Application module.
*/
module app;

import warabe.sdl : runApplication;

/**
Main function.
*/
void main()
{
    runApplication(() {
        import std.stdio : writeln;
        writeln("hello, SDL world!");
    });
}

