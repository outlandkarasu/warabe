/**
Warabe exception module.
*/
module warabe.exception;
  
/**
Warabe exception base class.
*/
abstract class WarabeException : Exception
{
    /**
    construct by message.

    Params:
        msg = exception message.
        file = file name.
        line = source line number.
        nextInChain = exception chain.
    */
    @nogc nothrow pure @safe
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

