module warabe.exception;

/**
Warabe related exception.
*/
class WarabeException : Exception
{
    /// constructor from super class.
    pure nothrow @nogc @safe this(
            string msg,
            string file = __FILE__,
            size_t line = __LINE__,
            Throwable nextInChain = null)
    {
        super(msg, file, line, nextInChain);
    }
}

