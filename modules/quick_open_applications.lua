function open(name)
    return function()
        hs.application.launchOrFocus(name)
        if name == "Finder" then
            hs.appfinder.appFromName(name):activate()
        end
    end
end

--- quick open applications
hs.hotkey.bind({"alt"}, "F", open("Finder"))
hs.hotkey.bind({"alt"}, "C", open("Google Chrome"))
hs.hotkey.bind({"alt"}, "I", open("iTerm"))
hs.hotkey.bind({"alt"}, "T", open("Microsoft Teams"))
hs.hotkey.bind({"alt"}, "V", open("Visual Studio Code"))
hs.hotkey.bind({"alt"}, "G", open("ChatGPT"))
hs.hotkey.bind({"alt"}, "N", open("Notion"))
hs.hotkey.bind({"alt"}, "D", open("Figma"))
