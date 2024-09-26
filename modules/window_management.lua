local hotkey = require "hs.hotkey"
local window = require "hs.window"
local spaces = require "hs.spaces"

local function getGoodFocusedWindow(nofull)
    local win = window.focusedWindow()

    -- 모달이나 약식 window 가 아닌 standard 형태의 윈도우를 찾는다.
    if not win or not win:isStandard() then
        return
    end

    -- full screen 된 윈도우는 배제한다.
    if nofull and win:isFullScreen() then
        return
    end
    return win
end

local function flashScreen(screen)
    hs.alert.show("No more spaces to that direction!")
    local flash =
        hs.canvas.new(screen:fullFrame()):appendElements(
        {
            action = "fill",
            fillColor = {alpha = 0.25, red = 1},
            type = "rectangle"
        }
    )
    flash:show()
    hs.timer.doAfter(
        .15,
        function()
            flash:delete()
        end
    )
end

local function moveWindowOneSpace(dir, switch)
    -- 현재 포커스된 window 를 찾는다.
    local win = getGoodFocusedWindow(true)
    if not win then
        return
    end

    local screen = win:screen()
    local uuid = screen:getUUID()
    local userSpaces = nil

    local allSpaces = spaces.allSpaces()
    for k, v in pairs(spaces.allSpaces()) do
        -- k 는 스크린(모니터)의 uuid.
        -- v 는 해당 스크린에 존재하는 spaces 들의 모음.
        userSpaces = v
        if k == uuid then
            break
        end
    end

    if not userSpaces then
        return
    end

    local thisSpace = spaces.windowSpaces(win) -- first space win appears on
    if not thisSpace then
        return
    else
        thisSpace = thisSpace[1]
    end
    local last = nil
    local skipSpaces = 0
    for _, spc in ipairs(userSpaces) do
        if spaces.spaceType(spc) ~= "user" then -- skippable space
            skipSpaces = skipSpaces + 1
        else
            if last and ((dir == "left" and spc == thisSpace) or (dir == "right" and last == thisSpace)) then
                local newSpace = (dir == "left" and last or spc)
                spaces.moveWindowToSpace(win, newSpace)
                return
            end
            last = spc -- Haven't found it yet...
            skipSpaces = 0
        end
    end
    flashScreen(screen) -- Shouldn't get here, so no space found
end

hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "l",
    function()
        moveWindowOneSpace("right", false)
    end
)
hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "j",
    function()
        moveWindowOneSpace("left", false)
    end
)
