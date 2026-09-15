package AssetLoader

import "core:os"
import "core:encoding/json"
import "core:fmt"

//testing a workflow

assetmap: map[AssetType]^AppSettings

AssetType :: enum {
    Settings,

}

AppSettings :: struct {
    width: i32,
    height: i32,
    title: cstring,
    TargetFPS: i32,
    keymap: map[string]i32,
    isDebug: bool,
}

DevelopSettings :: struct {
    Actions: [dynamic] string,
}

LoadAsset :: proc(type: AssetType) {
    switch(type) {
    case AssetType.Settings:
       LoadSettings() 
    case:
        fmt.println("NON-VALID type passed")
    }
    
}

LoadSettings::proc () {
    data, err := os.read_entire_file("testSettings.json", context.allocator)
    if err != nil {
        fmt.println("ERROR: failed to load json")
        return
    }
    defer delete(data)
    settings := new(AppSettings)
    if uerr := json.unmarshal(data, settings); uerr != nil {
        fmt.eprintfln("ERROR: failed to unmarshal settings: %v", uerr)
        free(settings)
        return
    }
    fmt.printfln("Data: %v\n", settings)
    assetmap[AssetType.Settings] = settings
}

DeleteAssets :: proc () {
    delete(assetmap)
}

SaveSettings :: proc () {
    fmt.printfln("%#v", assetmap[AssetType.Settings])
    json_data, err := json.marshal(assetmap[AssetType.Settings]^, {
        pretty = true, 
        use_enum_names = true,
    })
    if err != nil {
        fmt.eprintf("Unable to marshal JSON: %v", err)
        os.exit(1)
    }
    defer delete(json_data)
    if werr := os.write_entire_file("testSave.json", json_data); werr != nil {
        fmt.eprintfln("Unable to write JSON: %v", werr)
        return
    }
    fmt.println("Saved File")
}
