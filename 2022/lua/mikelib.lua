-- Mike's lua utilities
-- Mike Beller, 2022
-- Borrowing liberally from microlight (Steve Donovan, 2012; License MIT)

local unpack = table.unpack or unpack -- 5.1 compatibility

--- split a delimited string into an array of strings.
-- @param s The input string
-- @param re A Lua string pattern; defaults to '%s+'
-- @param n optional maximum number of splits
-- @return an array of strings
local function split(s,re,n)
    local find,sub,append = string.find, string.sub, table.insert
    local i1,ls = 1,{}
    if not re then re = '%s+' end
    if re == '' then return {s} end
    while true do
        local i2,i3 = find(s,re,i1)
        if not i2 then
            local last = sub(s,i1)
            if last ~= '' then append(ls,last) end
            if #ls == 1 and ls[1] == '' then
                return {}
            else
                return ls
            end
        end
        append(ls,sub(s,i1,i2-1))
        if n and #ls == n then
            ls[#ls] = sub(s,i1)
            return ls
        end
        i1 = i3+1
    end
end


local function quote (v)
    if type(v) == 'string' then
        return ('%q'):format(v)
    else
        return tostring(v)
    end
end

local lua_keyword = {
    ["and"] = true, ["break"] = true,  ["do"] = true,
    ["else"] = true, ["elseif"] = true, ["end"] = true,
    ["false"] = true, ["for"] = true, ["function"] = true,
    ["if"] = true, ["in"] = true,  ["local"] = true, ["nil"] = true,
    ["not"] = true, ["or"] = true, ["repeat"] = true,
    ["return"] = true, ["then"] = true, ["true"] = true,
    ["until"] = true,  ["while"] = true, ["goto"] = true,
}

local function is_iden (key)
    return key:match '^[%a_][%w_]*$' and not lua_keyword[key]
end


local tbuff
function tbuff (t,buff,k,start_indent,indent)
    local start_indent2, indent2
    if start_indent then
        start_indent2 = indent
        indent2 = indent .. indent
    end
    local function append (v)
        if not v then return end
        buff[k] = v
        k = k + 1
    end
    local function put_item(value)
        if type(value) == 'table' then
            if not buff.tables[value] then
                buff.tables[value] = true
                k = tbuff(value,buff,k,start_indent2,indent2)
            else
                append("<cycle>")
            end
        else
            value = quote(value)
            append(value)
        end
        append ","
        if start_indent then append '\n' end
    end
    append "{"
    if start_indent then append '\n' end
    -- array part -------
    local array = {}
    for i,value in ipairs(t) do
        append(indent)
        put_item(value)
        array[i] = true
    end
    -- 'map' part ------
    for key,value in pairs(t) do if not array[key] then
        append(indent)
        -- non-identifiers need ["key"]
        if type(key)~='string' or not is_iden(key) then
            if type(key)=='table' then
                key = ml.tstring(key)
            else
                key = quote(key)
            end
            key = "["..key.."]"
        end
        append(key..'=')
        put_item(value)
    end end
    -- removing trailing comma is done for prettiness, but this implementation
    -- is not pretty at all!
    local last = start_indent and buff[k-2] or buff[k-1]
    if start_indent then
        if last == '{' then -- empty table
            k = k - 1
        else
            if last == ',' then -- get rid of trailing comma
                k = k - 2
                append '\n'
            end
            append(start_indent)
        end
    elseif last == "," then -- get rid of trailing comma
        k = k - 1
    end
    append "}"
    return k
end

--- return a string representation of a Lua value.
-- Cycles are detected, and the result can be optionally indented nicely.
-- @param t the table
-- @param how (optional) a table with fields `spacing' and 'indent', or a string corresponding
-- to `indent`.
-- @return a string
local function tstring (t,how)
    if type(t) == 'table' and not (getmetatable(t) and getmetatable(t).__tostring) then
        local buff = {tables={[t]=true}}
        how = how or {}
        if type(how) == 'string' then how = {indent = how} end
        pcall(tbuff,t,buff,1,how.spacing or how.indent,how.indent)
        return table.concat(buff)
    else
        return quote(t)
    end
end

local String = {
    split = split,
    tostring=tstring,
}

local List = {}
setmetatable(List, List)

local function is_list(obj)
    return getmetatable(obj) == List
end

local function tolist(obj)
    if is_list(obj) then
        return obj
    end

    obj = obj or {}

    if type(obj) == "function" then
        return iter_to_list(obj)
    elseif type(obj) == "table" then
        lst = obj
    end

    setmetatable(lst, List)
    return lst
end

local function imap(tbl, fcn)
    local res = List({})
    for k,v in ipairs(tbl) do
        res[k] = fcn(v)
    end
    return res
end

local function identity(x)
    return x
end

local function count(tbl, fcn)
    fcn = fcn or identity
    count = 0
    for k,v in ipairs(tbl) do
        if fcn(v) then
            count = count + 1
        end
    end
    return count
end

List.__call = tolist
List.__tostring = tstring
List.map = imap
List.count = count

local ml = {
    List=List,
    Map=Map,
    String=String,
}

local inspect = require('inspect')
function test()
    local t1 = tolist({1,2,3})
    print(tstring(t1))
end

test()


return ml