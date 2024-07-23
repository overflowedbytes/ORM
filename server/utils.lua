function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end

    return false
end

function ORM:logging(type, message)
    if not Config.logging then return end

    if type == "success" then
        return print(("%s[SUCCESS]:%s %s"):format(Colors.Green, Colors.White, message))
    elseif type == "info" then
        return print(("%s[INFO]:%s %s"):format(Colors.Blue, Colors.White, message))
    elseif type == "warn" then
        return print(("%s[WARN]:%s %s"):format(Colors.Yellow, Colors.White, message))
    elseif type == "error" then
        return print(("%s[ERROR]:%s %s"):format(Colors.Red, Colors.White, message))
    end
end