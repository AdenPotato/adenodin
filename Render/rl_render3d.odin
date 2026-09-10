package render
import rl "vendor:raylib"

EntityRenderState :: struct {
    position: rl.Vector3,
    rotation: rl.Vector3,
    scale: f32
     
}

State3D :: struct {
    renderList: [dynamic]EntityRenderState,

}

render3D :: proc(state: State3D) {

}

buildEntityRenderList :: proc() {
    
}
