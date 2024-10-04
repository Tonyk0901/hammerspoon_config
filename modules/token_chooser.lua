local COOKIE_MAPS = {
    walkerhill = {
        label = "token:walkerhill",
        token = "ca20a8c5423bcbc85bd11f5faa5f60ece0b256a5",
        type = "set_cookie"
    },
    shilla = {
        label = "token:shilla",
        token = "de2c90ac427c71f4167e3448c6b0404e282030f9",
        type = "set_cookie"
    },
    shilla_old = {
        label = "token:shilla_old",
        token = "d4c022cdad8349e5069a0afe0c8b73d0b5631470",
        type = "set_cookie"
    },
    shilla_mario = {
        label = "token:shilla_mario",
        token = "047c77954680a6c138347ace2384aef192ccafb0",
        type = "set_cookie"
    },
    fadu = {
        label = "token:fadu",
        token = "d861426c61d135ae544ba99b933896f42ca5af6c",
        type = "set_cookie"
    },
    survey = {
        label = "token:survey",
        token = "7286148196db404485c525ac0b9e9ffae22467d9",
        type = "set_cookie"
    },
    ispark = {
        label = "token:ispark",
        token = "dc4da2f6502f160df84c4ed8a592a715ba8c9308",
        type = "set_cookie"
    },
    gmarket = {
        label = "token:gmarket",
        token = "51437af4eced2b39ec48bb707af40b769ddf4c0d",
        type = "set_cookie"
    },
    wonik = {
        label = "token:wonik",
        token = "05fb5f39854675ff22edc05f1faa13f9a7eacf1c",
        type = "set_cookie"
    },
    hyundai_marine_fire = {
        label = "token:hyundai_marine_fire",
        token = "96509380a320e8ee2190b4df370d8db8763aa3bc",
        type = "set_cookie"
    },
    shinhancard = {
        label = "token:shinhan_card",
        token = "d2e78b4ba6e83d670ffa688d6f11178a7baecc32",
        type = "set_cookie"
    },
    hansol = {
        label = "token:hansol",
        token = "b42a43f8bf4fb88a7be566abbb8e7797d92e1d84",
        type = "set_cookie"
    },
    hdc = {
        label = "token:hdc",
        token = "bcf2ba6fc8445a60c2122c7f3ec77a9a6155cf3e",
        type = "set_cookie"
    },
    carrot = {
        label = "token:carrot",
        token = "849f65a70587c97a5b945125bdd1b4a438190e61",
        type = "set_cookie"
    },
    survey_password = {
        label = "password:survey",
        token = "Gz,u;jwxWu%xr]wDANgfjyzp^7c68q",
        type = "copy_to_clipboard"
    }
}

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
