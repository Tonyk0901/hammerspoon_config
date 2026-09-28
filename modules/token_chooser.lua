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
            if not choice then
                return
            end

            if (choice.type == "set_cookie") then
                local window = hs.window.frontmostWindow()
                local app = window and window:application()

                if not app then
                    hs.alert.show("no application found.")
                    return
                end

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
    for _, value in pairs(COOKIE_MAPS) do
        if (value.type == "set_cookie") then
            table.insert(
                list,
                {
                    text = value.label .. " · 쿠키 설정 후 새로고침",
                    subText = "Chrome의 token 쿠키를 설정하고 새로고침합니다.",
                    token = value.token,
                    type = "set_cookie"
                }
            )
        end

        table.insert(
            list,
            {
                text = value.label .. " · 클립보드 복사",
                subText = "토큰 값을 클립보드에 복사합니다.",
                token = value.token,
                type = "copy_to_clipboard"
            }
        )
    end

    chooser:choices(list)
    chooser:show()
end

hs.hotkey.bind({"option"}, "1", show_chooser)
