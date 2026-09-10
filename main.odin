package main

import "Render"

import stbsp "vendor:stb/sprintf"
import "core:log"
import "base:intrinsics"
import "base:runtime"
import "core:c"
import rl "vendor:raylib"
import "AssetLoader"

g_ctx: runtime.Context

Entity :: struct {
    id: uint,    
}

World :: struct {
    entity: [dynamic]Entity
}

GameState :: struct {
    renderState: Render.GlobalRenderState,
    world: ^World,
}

Init :: proc() {
         
}

main :: proc() {
    SetupLog()
    AssetLoader.LoadAsset(AssetLoader.AssetType.Settings)
    settings := AssetLoader.assetmap[AssetLoader.AssetType.Settings]

    rl.InitWindow(settings.width, settings.height, settings.title)
    defer rl.CloseWindow()
    rl.SetWindowState({rl.ConfigFlag.WINDOW_RESIZABLE})

    camera : rl.Camera3D
    
    camera.position = {25, 10, 25}
    camera.fovy = 45
    camera.target = {0, 1, 0}
    camera.up= {0, 1, 0}
    camera.projection = .PERSPECTIVE
    rl.SetTargetFPS(settings.TargetFPS)
    AssetLoader.SaveSettings()

    for !rl.WindowShouldClose() {
        defer free_all(context.temp_allocator)
        rl.UpdateCamera(&camera, .ORBITAL)
        rl.BeginDrawing()
        rl.ClearBackground(rl.RAYWHITE)
        {
            rl.BeginMode3D(camera)
            defer rl.EndMode3D()
            rl.DrawGrid(10, 2)
        }
        rl.DrawFPS(20,20)
        rl.EndDrawing()
    }
}

SetupLog :: proc() {
    context.logger = log.create_console_logger(.Debug)
    g_ctx = context
    rl.SetTraceLogLevel(.ALL)
    rl.SetTraceLogCallback(proc "c" (rl_level: rl.TraceLogLevel, message: cstring, args: ^c.va_list){
        context = g_ctx

        level: log.Level
        switch rl_level {
            case .TRACE, .DEBUG:    level = .Debug
            case .INFO:             level = .Info
            case .WARNING:          level = .Warning
            case .ERROR:            level = .Error
            case .FATAL:            level = .Fatal
            case .ALL, .NONE:       fallthrough
            case:                   log.panicf("unexpected log level %v", rl_level)
        }
        @static buf: [dynamic]byte
        log_len: i32
        for {
            buf_len := i32(len(buf))
            args_copy: c.va_list
            intrinsics.c_va_copy(&args_copy, args)
            log_len = stbsp.vsnprintf(raw_data(buf), buf_len, message, &args_copy)
            intrinsics.c_va_end(&args_copy)
            if log_len < buf_len {
                break
            }
            non_zero_resize(&buf, max(128, log_len+1))
        }
        opts := context.logger.options - log.Location_Header_Opts
        context.logger.procedure(context.logger.data, level, string(buf[:log_len]), opts)
    })
}

