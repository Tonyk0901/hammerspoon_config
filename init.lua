require("modules.window_management")
require("modules.quick_open_applications")
require("modules.window_resizer")
require("modules.token_chooser")

hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "R",
    function()
        hs.reload()
    end
)

hs.alert.show("Config loaded")
