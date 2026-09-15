package App

import rl "vendor:raylib"

ActionEvent :: union {
    rl.KeyboardKey,
    rl.MouseButton,
    int
}

GameInput :: struct {
    LoadedActions: [dynamic]string
}

InputState :: struct {
    keymap: map[string]EventButton,
}

//Key/mouse button state
ButtonState :: enum {
    KEY_UP,
    KEY_DOWN,
    KEY_PRESSED,
    KEY_HELD,
    KEY_RELEASE,
}

Init :: proc () {
        
}

HandleInput :: proc () {
    
}
