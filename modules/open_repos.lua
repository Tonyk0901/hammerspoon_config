local REPO_COMMANDS = {
    {
        text = "pocketsurvey-react-app",
        subText = "Open in VS Code",
        command = "code ~/repos/pocketsurvey-react-app"
    },
    {
        text = "earlysloth-fe-scripts2",
        subText = "Open in VS Code",
        command = "code ~/repos/earlysloth-fe-scripts2"
    },
    {
        text = "haevichi-voc-frontend",
        subText = "Open in VS Code",
        command = "code ~/repos/haevichi-voc-frontend"
    },
    {
        text = "pocketsurvey-ui-components",
        subText = "Open in VS Code",
        command = "code ~/repos/pocketsurvey-ui-components"
    },
    {
        text = "pocketsurvey-web-crawler-fe",
        subText = "Open in VS Code",
        command = "code ~/repos/pocketsurvey-web-crawler-fe"
    },
    {
        text = "pocketsurvey-websurvey",
        subText = "Open in VS Code",
        command = "code ~/repos/pocketsurvey-websurvey"
    },
    {
        text = "RewardProcessor",
        subText = "Open in VS Code",
        command = "code ~/repos/RewardProcessor"
    },
    {
        text = "runjs",
        subText = "Open in VS Code",
        command = "code ~/repos/runjs"
    },
    {
        text = "yg-entertainment",
        subText = "Open in VS Code",
        command = "code ~/repos/yg-entertainment"
    },
    {
        text = "report-monitor",
        subText = "Open in VS Code",
        command = "code ~/repos/report-monitor"
    }
}

local function run_shell_command(command)
    local output, ok, _, rc = hs.execute(command, true)

    if ok then
        hs.alert.show("executed: " .. command)
        return
    end

    local message = "failed (" .. tostring(rc) .. "): " .. command
    if output and output ~= "" then
        message = message .. "\n" .. output
    end
    hs.alert.show(message)
end

local function show_repo_chooser()
    local chooser =
        hs.chooser.new(
        function(choice)
            if not choice then
                return
            end

            run_shell_command(choice.command)
        end
    )

    chooser:choices(REPO_COMMANDS)
    chooser:show()
end

hs.hotkey.bind({"option"}, "2", show_repo_chooser)
