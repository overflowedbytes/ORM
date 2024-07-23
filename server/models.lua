ORM = setmetatable({}, { __index = ORM})

---@param name string - The name of the table created
---@param args table - The column names
function ORM:createMethods(name, args)
    if type(name) ~= "string" or type(args) ~= "table" then
        return error("Invalid arguments. Expected string 'name' and table 'args'.")
    end

    local self = setmetatable({}, { __index = ORM })

    ---@param columns table - The data to create must be valid columns
    ---@return boolean | nil
    function self:create(columns)
        if type(columns) ~= "table" then
            return error("Invalid argument 'columns'. Expected a table.")
        end

        local template = ("INSERT INTO %s"):format(name)
        local formattedColumns = {}

        local placeholders = {}
        local params = {}

        for k, v in pairs(columns) do
            if not table.contains(args, k) then
                return error(("Invalid column '%s'. Please provide a valid column name."):format(k))
            end

            table.insert(formattedColumns, k)
            table.insert(placeholders, "?")
            table.insert(params, v)
        end

        local columnsStr = table.concat(formattedColumns, ",")
        local placeholdersStr = table.concat(placeholders, ",")

        local queryString = ("%s (%s) VALUES (%s)"):format(template, columnsStr, placeholdersStr)

        local success = MySQL.insert.await(queryString, params)


        if not success then
            return error("Failed to execute INSERT query")
        end

        return true
    end

    ---@param where table - Where to update
    ---@param update table - What we are updating
    function self:update(where, update)
        if type(where) ~= "table" or type(update) ~= "table" then
            return error("Invalid Argument types expected where as 'table and update as 'table")
        end

        local template = ("UPDATE %s"):format(name)

        for k, v in pairs(where) do
            if not table.contains(args, k) then
                return error(("Invalid column '%s'. Please provide a valid column name."):format(k))
            end
        end
    end

    -- TODO: Finish Methods
    function self:delete()
        
    end

    function self:exists()

    end

    function self:findOne()
        
    end

    return self
end

---@param name string - The table name
---@param schema table - The schema of the model
function ORM:model(name, schema)
    if not name or not schema then 
        return error(("Missing Arguments - name: %s, schema: %s"):format(tostring(name), tostring(schema))) 
    end

    local template = ("CREATE TABLE IF NOT EXISTS %s"):format(name)
    local columns = {}
    local args = {}

    for key, value in pairs(schema) do
        if type(value) == "table" then
            if not value.type or not value.size then
                return error(("Missing Arguments - id: %s, type: %s"):format(value.type, value.size))
            end
            
            if not table.contains(Datatypes, value.type) then
                return error(("Provided datatype seems to not exist: datatype: %s"):format(value.type))
            end

            local columnDef = ("%s %s(%s)"):format(key, value.type, value.size)
            table.insert(columns, columnDef)
        else
            local columnDef = ("%s %s"):format(key, value)
            table.insert(columns, columnDef)
        end

        table.insert(args, key)
    end

    local columnsString = table.concat(columns, ", ")
    local formattedQuery = ("%s(%s)"):format(template, columnsString)

    local query = MySQL.rawExecute.await(formattedQuery)
    
    if query then
        ORM:logging("success", "Successful query")
        return self:createMethods(name, args)
    end
end