require("modules.inputsource_aurora")
require("modules.window_management")

hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "R",
    function()
        hs.reload()
    end
)

hs.alert.show("Config loaded")
