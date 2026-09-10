package render

import rl "vendor:raylib"

GlobalRenderState :: struct {
    camera3d: rl.Camera3D,
    cameraMode: rl.CameraMode, 
}

renderState: ^GlobalRenderState



InitRenderState :: proc () {
    renderState = new(GlobalRenderState)
    renderState.camera3d.position = {25, 10, 25}
    renderState.camera3d.fovy = 45
    renderState.camera3d.target = {0, 1, 0}
    renderState.camera3d.up = {0,1,0}
    renderState.camera3d.projection = .PERSPECTIVE    
}
