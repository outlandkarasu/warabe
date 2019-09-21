/**
Events module.
*/
module warabe.sdl.events;

import sdl = bindbc.sdl;

alias Event = sdl.SDL_Event;
alias CommonEvent = sdl.SDL_CommonEvent;
alias WindowEvent = sdl.SDL_WindowEvent;
alias KeyboardEvent = sdl.SDL_KeyboardEvent;
alias TextEditingEvent = sdl.SDL_TextEditingEvent;
alias TextInputEvent = sdl.SDL_TextInputEvent;
alias MouseMotionEvent = sdl.SDL_MouseMotionEvent;
alias MouseButtonEvent = sdl.SDL_MouseButtonEvent;
alias MouseWheelEvent = sdl.SDL_MouseWheelEvent;
alias JoyAxisEvent = sdl.SDL_JoyAxisEvent;
alias JoyBallEvent = sdl.SDL_JoyBallEvent;
alias JoyHatEvent = sdl.SDL_JoyHatEvent;
alias JoyButtonEvent = sdl.SDL_JoyButtonEvent;
alias JoyDeviceEvent = sdl.SDL_JoyDeviceEvent;
alias ControllerAxisEvent = sdl.SDL_ControllerAxisEvent;
alias ControllerButtonEvent = sdl.SDL_ControllerButtonEvent;
alias ControllerDeviceEvent = sdl.SDL_ControllerDeviceEvent;
alias QuitEvent = sdl.SDL_QuitEvent;
alias UserEvent = sdl.SDL_UserEvent;
alias SysWMEvent = sdl.SDL_SysWMEvent;
alias TouchFingerEvent = sdl.SDL_TouchFingerEvent;
alias MultiGestureEvent = sdl.SDL_MultiGestureEvent;
alias DollarGestureEvent = sdl.SDL_DollarGestureEvent;

/**
SDL event type enum.
*/
enum EventType : sdl.SDL_EventType
{
    firstEvent = sdl.SDL_FIRSTEVENT,
    quit = sdl.SDL_QUIT,

    appTerminating = sdl.SDL_APP_TERMINATING,
    appLowMemory = sdl.SDL_APP_LOWMEMORY,
    appWillEnterBackground = sdl.SDL_APP_WILLENTERBACKGROUND,
    appDidEnterBackground = sdl.SDL_APP_DIDENTERBACKGROUND,
    appWillEnterForeground = sdl.SDL_APP_WILLENTERFOREGROUND,
    appDidEnterForeground = sdl.SDL_APP_DIDENTERFOREGROUND,

    windowEvent = sdl.SDL_WINDOWEVENT,
    sysWMEvent = sdl.SDL_SYSWMEVENT,

    keyDown = sdl.SDL_KEYDOWN,
    keyUp = sdl.SDL_KEYUP,
    textEditing = sdl.SDL_TEXTEDITING,
    textInput = sdl.SDL_TEXTINPUT,

    mouseMotion = sdl.SDL_MOUSEMOTION,
    mouseButtonDown = sdl.SDL_MOUSEBUTTONDOWN,
    mouseButtonUp = sdl.SDL_MOUSEBUTTONUP,
    mouseWheel = sdl.SDL_MOUSEWHEEL,

    joyAxisMotion = sdl.SDL_JOYAXISMOTION,
    joyBallMotion = sdl.SDL_JOYBALLMOTION,
    joyHatMotion = sdl.SDL_JOYHATMOTION,
    joyButtonDown = sdl.SDL_JOYBUTTONDOWN,
    joyButtonUp = sdl.SDL_JOYBUTTONUP,
    joyDeviceAdded = sdl.SDL_JOYDEVICEADDED,
    joyDeviceRemoved = sdl.SDL_JOYDEVICEREMOVED,

    controllerAxisMotion = sdl.SDL_CONTROLLERAXISMOTION,
    controllerButtonDown = sdl.SDL_CONTROLLERBUTTONDOWN,
    controllerButtonUp = sdl.SDL_CONTROLLERBUTTONUP,
    controllerDeviceAdded = sdl.SDL_CONTROLLERDEVICEADDED,
    controllerDeviceRemoved = sdl.SDL_CONTROLLERDEVICEREMOVED,
    controllerDeviceRemapped = sdl.SDL_CONTROLLERDEVICEREMAPPED,
    fingerDown = sdl.SDL_FINGERDOWN,
    fingerUp = sdl.SDL_FINGERUP,
    fingerMotion = sdl.SDL_FINGERMOTION,

    dollarGesture = sdl.SDL_DOLLARGESTURE,
    dollarRecord = sdl.SDL_DOLLARRECORD,
    multiGesture = sdl.SDL_MULTIGESTURE,

    clipBoardUpdate = sdl.SDL_CLIPBOARDUPDATE,

    userEvent = sdl.SDL_USEREVENT,
    lastEvent = sdl.SDL_LASTEVENT,
}

