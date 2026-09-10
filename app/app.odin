package app

import "../AssetLoader"
import rl "vendor:raylib"

Settings: ^AssetLoader.AppSettings

InitApp :: proc() {
    AssetLoader.LoadAsset(AssetLoader.AssetType.Settings)
    Settings = AssetLoader.assetmap[AssetLoader.AssetType.Settings]
    rl.InitWindow(Settings.width, Settings.height, Settings.title)
    rl.SetWindowState({rl.ConfigFlag.WINDOW_RESIZABLE})
}

close_app :: proc() {
    rl.CloseWindow()
}


