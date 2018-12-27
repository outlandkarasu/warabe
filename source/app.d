import warabe.application : ApplicationParameters, run;

/**
entry point.

Params:
    args = command line arguments.
*/
void main(string[] args)
{
    auto params = ApplicationParameters("test");
    run(params);
}

