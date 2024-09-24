local function splitWindow(dir)
    if not dir then
        return
    end

    local win = hs.window.frontmostWindow()

    if not win then
        return
    end

    if dir == "up" then
        win:moveToUnit("[0,0,100,50]", 0)
        return
    end

    if dir == "down" then
        win:moveToUnit("[0,100,100,50]", 0)
        return
    end

    if dir == "left" then
        win:moveToUnit("[0,0,50,100]", 0)
        return
    end

    if dir == "right" then
        win:moveToUnit("[100,0,50,100]", 0)
        return
    end

    if dir == "return" then
        win:moveToUnit("[0,0,100,100]", 0)
        return
    end
end

hs.hotkey.bind(
    {"alt", "ctrl"},
    "up",
    function()
        splitWindow("up")
    end
)
hs.hotkey.bind(
    {"alt", "ctrl"},
    "down",
    function()
        splitWindow("down")
    end
)
hs.hotkey.bind(
    {"alt", "ctrl"},
    "left",
    function()
        splitWindow("left")
    end
)

hs.hotkey.bind(
    {"alt", "ctrl"},
    "right",
    function()
        splitWindow("right")
    end
)

hs.hotkey.bind(
    {"alt", "ctrl"},
    "return",
    function()
        splitWindow("return")
    end
)
