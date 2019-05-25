/**
Window module.
*/
module warabe.window;

import warabe.primitives : Size;

/**
Window interface.
*/
interface Window
{
}

/**
Window factory interface.
*/
interface WindowFactory
{
    Window create(
            scope const(char)[] title,
            scope ref const(Size) size);
}

