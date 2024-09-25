local function print_stuffs(...)
    local args = {...}
    print(table.unpack(args))
end

print_stuffs("tony", "shin", "eren") -- tonyshin
