/**
Warabe exception module.
*/
module warabe.exception;
  
/**
Warabe exception base class.
*/
abstract class WarabeException : Exception
{
    @nogc nothrow pure @safe
    this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

