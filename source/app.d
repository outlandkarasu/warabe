/**
Application module.
*/
module app;

import std.stdio : writeln;

import warabe : usingWarabe;

/**
Main function.
*/
void main()
{
    usingWarabe!({
        writeln("Warabe!");
    });
}

