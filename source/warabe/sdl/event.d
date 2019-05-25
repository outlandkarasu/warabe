/**
SDL event module.
*/
module warabe.sdl.event;

import warabe.event : EventLoop, LoopStatus;

import bindbc.sdl :
    SDL_Event,
    SDL_PollEvent,
    SDL_QUIT
;

/**
SDL event loop.
*/
class SDLEventLoop : EventLoop
{
    override void start(scope LoopStatus delegate() loopFunction)
    {
        for(;;)
        {
            for(SDL_Event e; SDL_PollEvent(&e);)
            {
                switch(e.type)
                {
                    case SDL_QUIT:
                        return;
                    default:
                        break;
                }
            }

            if (loopFunction() == LoopStatus.exitLoop)
            {
                return;
            }
        }
    }
}

