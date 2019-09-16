/**
SDL initialize module.
*/
module warabe.sdl.initialize;

import bindbc.sdl :
    SDL_Init,
    SDL_Quit;

import bindbc.sdl :
    SDL_INIT_TIMER,
    SDL_INIT_AUDIO,
    SDL_INIT_VIDEO,
    SDL_INIT_JOYSTICK,
    SDL_INIT_HAPTIC,
    SDL_INIT_GAMECONTROLLER,
    SDL_INIT_EVENTS,
    SDL_INIT_EVERYTHING,
    SDL_INIT_NOPARACHUTE;

import bindbc.sdl : Uint32;

import warabe.sdl.types : SdlResult;

/**
SDL initialize flags.
*/
enum SdlInit : Uint32
{
    nothing = 0,
    timer = SDL_INIT_TIMER,
    audio = SDL_INIT_AUDIO,
    video = SDL_INIT_VIDEO,
    joystick = SDL_INIT_JOYSTICK,
    haptic = SDL_INIT_HAPTIC,
    gameController = SDL_INIT_GAMECONTROLLER,
    events = SDL_INIT_EVENTS,
    everything = SDL_INIT_EVERYTHING,
}

/**
Initialize SDL subsystems.

Params:
    flags = subsystem flags.
Returns:
    initialized status.
*/
SdlResult init(SdlInit flags) @nogc nothrow
{
    return SdlResult(SDL_Init(flags));
}

/**
Quit SDL.
*/
void quit() @nogc nothrow
{
    SDL_Quit();
}
