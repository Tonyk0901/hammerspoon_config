local Info = debug.getinfo(1, "S")
local ScriptPath = Info.source:match [[^@?(.*[\/])[^\/]-$]]
package.path = ScriptPath .. "../constants/?.lua;" .. package.path
local COOKIE_MAPS = require("constants").COOKIE_MAPS

local function setChromeCookie(cookie)
    local script =
        [[
    tell application "Google Chrome" to execute front window's active tab javascript "
    document.cookie = 'token=]] ..
        cookie .. [[;';
    window.location.reload();
    "
    ]]
    hs.osascript.applescript(script)
end

local function copyToClipboard(text)
    local result = hs.pasteboard.setContents(text)
    if result then
        hs.alert.show("copied to clipboard!")
    else
        hs.alert.show("failed to copy.")
    end
end

local function show_chooser()
    local chooser =
        hs.chooser.new(
        function(choice)
            local app = hs.window.frontmostWindow():application()

            if not app then
                hs.alert.show("no application found.")
                return
            end

            if (choice.type == "set_cookie") then
                local app_name = string.lower(app:name())

                if not string.find(app_name, "chrome") then
                    hs.alert.show("is not chrome.")
                    return
                end

                hs.alert.show(choice.text)
                setChromeCookie(choice.token)
                return
            elseif (choice.type == "copy_to_clipboard") then
                copyToClipboard(choice.token)
                return
            end
        end
    )

    local list = {}
    for key, value in pairs(COOKIE_MAPS) do
        local subText = ""
        if (value.type == "copy_to_clipboard") then
            subText = "클립보드에 복사 합니다."
        elseif (value.type == "set_cookie") then
            subText = "토큰을 쿠키에 설정합니다."
        end

        table.insert(
            list,
            {
                text = value.label,
                subText = subText,
                token = value.token,
                type = value.type
            }
        )
    end

    chooser:choices(list)
    chooser:show()
end

hs.hotkey.bind({"option"}, "1", show_chooser)
