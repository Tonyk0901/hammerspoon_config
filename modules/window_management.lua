local hotkey = require "hs.hotkey"
local window = require "hs.window"
local spaces = require "hs.spaces"

-- local function getGoodFocusedWindow(nofull)
--     local win = window.focusedWindow()

--     -- 모달이나 약식 window 가 아닌 standard 형태의 윈도우를 찾는다.
--     if not win or not win:isStandard() then
--         return
--     end

--     -- full screen 된 윈도우는 배제한다.
--     if nofull and win:isFullScreen() then
--         return
--     end
--     return win
-- end

-- local function flashScreen(screen)
--     hs.alert.show("No more spaces to that direction!")
--     local flash =
--         hs.canvas.new(screen:fullFrame()):appendElements(
--         {
--             action = "fill",
--             fillColor = {alpha = 0.25, red = 1},
--             type = "rectangle"
--         }
--     )
--     flash:show()
--     hs.timer.doAfter(
--         .15,
--         function()
--             flash:delete()
--         end
--     )
-- end

-- local function moveWindowOneSpace(dir, switch)
--     -- 현재 포커스된 window 를 찾는다.
--     local win = getGoodFocusedWindow(true)
--     if not win then
--         return
--     end

--     local screen = win:screen()
--     local uuid = screen:getUUID()
--     local userSpaces = nil

--     local allSpaces = spaces.allSpaces()
--     for k, v in pairs(spaces.allSpaces()) do
--         -- k 는 스크린(모니터)의 uuid.
--         -- v 는 해당 스크린에 존재하는 spaces 들의 모음.
--         userSpaces = v
--         if k == uuid then
--             break
--         end
--     end

--     if not userSpaces then
--         return
--     end

--     local thisSpace = spaces.windowSpaces(win) -- first space win appears on
--     if not thisSpace then
--         return
--     else
--         thisSpace = thisSpace[1]
--     end
--     local last = nil
--     local skipSpaces = 0
--     for _, spc in ipairs(userSpaces) do
--         if spaces.spaceType(spc) ~= "user" then -- skippable space
--             skipSpaces = skipSpaces + 1
--         else
--             if last and ((dir == "left" and spc == thisSpace) or (dir == "right" and last == thisSpace)) then
--                 local newSpace = (dir == "left" and last or spc)
--                 print("tony")
--                 print(newSpace)
--                 local result = spaces.moveWindowToSpace(win, newSpace)
--                 print(result)
--                 return
--             end
--             last = spc -- Haven't found it yet...
--             skipSpaces = 0
--         end
--     end
--     flashScreen(screen) -- Shouldn't get here, so no space found
-- end

local obj = {}
obj.__index = obj
obj.hs = hs

-- Module state
obj.isMoving = false

-- Constants
local MOUSE_OFFSET_X = 5
local MOUSE_OFFSET_Y = 12
local SWITCH_DELAY = 0.2
local RELEASE_DELAY = 0.5

local function simulateKeyEvent(modifier, key)
    obj.hs.eventtap.event.newKeyEvent(modifier, true):post()
    obj.hs.eventtap.event.newKeyEvent(key, true):post()
    obj.hs.timer.doAfter(
        0.1,
        function()
            obj.hs.eventtap.event.newKeyEvent(modifier, false):post()
            obj.hs.eventtap.event.newKeyEvent(key, false):post()
        end
    )
end

function obj:move_window_to_next_desktop()
    if self.isMoving then
        return
    end
    self.isMoving = true

    -- Get current active window and make it frontmost
    local win = self.hs.window.focusedWindow()
    if not win then
        self.isMoving = false
        return
    end
    win:unminimize()
    win:raise()

    -- Check if we're on the rightmost desktop
    local spaces = self.hs.spaces.spacesForScreen()
    local currentSpace = self.hs.spaces.focusedSpace()

    if currentSpace == spaces[#spaces] then
        self.hs.alert.show("Already at the rightmost desktop.")
        self.isMoving = false
        return
    end

    -- Get window frame and calculate positions
    local frame = win:frame()
    local clickPos = self.hs.geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
    local centerPos = self.hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

    -- Move mouse to click position
    self.hs.mouse.absolutePosition(clickPos)

    -- Simulate mouse press and desktop switch
    self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseDown, clickPos):post()

    self.hs.timer.doAfter(
        SWITCH_DELAY,
        function()
            simulateKeyEvent("ctrl", "right")
        end
    )

    -- Release mouse and restore position
    self.hs.timer.doAfter(
        RELEASE_DELAY,
        function()
            self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseUp, clickPos):post()
            self.hs.mouse.absolutePosition(centerPos)
            win:raise()
            win:focus()
            self.isMoving = false
        end
    )
end

function obj:move_window_to_previous_desktop()
    if self.isMoving then
        return
    end
    self.isMoving = true

    -- Check if we're on the leftmost desktop
    local spaces = self.hs.spaces.spacesForScreen()
    local currentSpace = self.hs.spaces.focusedSpace()

    if currentSpace == spaces[1] then
        self.hs.alert.show("Already at the leftmost desktop.")
        self.isMoving = false
        return
    end

    -- Get current active window and make it frontmost
    local win = self.hs.window.focusedWindow()
    if not win then
        self.isMoving = false
        return
    end
    win:unminimize()
    win:raise()

    -- Get window frame and calculate positions
    local frame = win:frame()
    local clickPos = self.hs.geometry.point(frame.x + MOUSE_OFFSET_X, frame.y + MOUSE_OFFSET_Y)
    local centerPos = self.hs.geometry.point(frame.x + frame.w / 2, frame.y + frame.h / 2)

    -- Move mouse to click position
    self.hs.mouse.absolutePosition(clickPos)

    -- Simulate mouse press and desktop switch
    self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseDown, clickPos):post()

    self.hs.timer.doAfter(
        SWITCH_DELAY,
        function()
            simulateKeyEvent("ctrl", "left")
        end
    )

    -- Release mouse and restore position
    self.hs.timer.doAfter(
        RELEASE_DELAY,
        function()
            self.hs.eventtap.event.newMouseEvent(self.hs.eventtap.event.types.leftMouseUp, clickPos):post()
            self.hs.mouse.absolutePosition(centerPos)
            win:raise()
            win:focus()
            self.isMoving = false
        end
    )
end

hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "l",
    function()
        obj:move_window_to_next_desktop()
    end
)
hs.hotkey.bind(
    {"cmd", "alt", "ctrl"},
    "j",
    function()
        obj:move_window_to_previous_desktop()
    end
)
