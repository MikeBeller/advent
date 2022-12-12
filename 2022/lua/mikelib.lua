-- Mike's lua utilities
-- Mike Beller, 2022
-- Inspired by microlight and penlight

-- parameter type naming guide
-- lst -- must be a List (its metatable is List)
-- itbl -- can be any list-like table (we consider only the keys 1..#itbl)
-- tbl -- any table -- we consider all keys
-- mp -- must be a Map (it's metatable is Map)
-- itr -- must be an iterator

--local unpack = table.unpack or unpack -- 5.1 compatibility
local find, sub, format = string.find, string.sub, string.format
local insert = table.insert

local List = {}
setmetatable(List, List)

local function is_list(obj)
    return getmetatable(obj) == List
end

local function iter_to_list(itr)
    local lst = List({})
    for v in itr do
        insert(lst, v)
    end
    return lst
end

-- convert an obj to a list if possible
-- 
-- obj -- a table, iterator, or List
-- returns: List (or error if not convertible)
local function tolist(obj)
    if is_list(obj) then
        return obj
    end

    obj = obj or {}

    if type(obj) == "function" then
        return iter_to_list(obj)
    elseif type(obj) == "table" then
        setmetatable(obj, List)
        --obj.__index = obj
        return obj
    else
        error("Can't convert type " .. type(obj) .. " to List")
    end
end

-- imap - map a function over a list or list-like table
local function imap(itbl, fcn)
    local lst = List({})
    for k,v in ipairs(itbl) do
        insert(lst, fcn(v))
    end
    return lst
end

local function identity(x)
    return x
end

-- returns the number of list items in itbl for which fcn returns true
-- if fcn is nil, then returns the number of truthy items in the table
local function count(itbl, fcn)
    fcn = fcn or identity
    count = 0
    for _,v in ipairs(itbl) do
        if fcn(v) then
            count = count + 1
        end
    end
    return count
end

local function list_to_string(itbl)
    local t = {}
    for i,v in ipairs(itbl) do
        if type(v) == "string" then
            t[i] = format('%q', v)
        else
            t[i] = tostring(v)
        end
    end
    return '{' .. table.concat(t, ",") .. "}"
end

local function lists_equal(lst1, lst2)
    if #lst1 ~= #lst2 then
        return false
    end
    for i = 1,#lst1 do
        if lst1[i] ~= lst2[i] then
            return false
        end
    end
    return true
end

List.__index = List -- why?
List.__tostring = list_to_string
List.__eq = lists_equal
List.map = imap
List.count = count
-- Below is to make it so that List({1,2,3}) returns a new List
setmetatable(List, {
    __call=function(klass, obj) return tolist(obj) end
})

function string_split(str, pat)
    local lst = List{}
    local p = 1
    while p <= #str do
        local s,e = find(str, pat, p)
        if s then
            insert(lst, sub(str, p, s-1))
            p = e + 1
        elseif p <= #str then
            insert(lst, sub(str, p, #str))
            break
        end
    end
    return lst
end

local String = {
    split = string_split,
}

local ml = {
    List=List,
    String=String,
}

-- tests
function test()

    local List, String = ml.List, ml.String
    local lst1 = List({1,2,3})
    assert(#lst1 == 3, "create len")
    local lst2 = List{1,2,3}
    assert(lst1 == lst2)
    assert(tostring(List{1,2,3}) == "{1,2,3}", "tostring")
    assert(lst1:map(function (x) return 2 * x end) == List{2,4,6}, "map")
    local split = String.split
    assert(split("foo,bar,baz", ",") == List{"foo", "bar", "baz"}, "split comma")
    assert(split("foo,bar,,baz", ",+") == List{"foo", "bar", "baz"}, "split pattern")
    assert(split("foo,bar,,baz,,", ",+") == List{"foo", "bar", "baz"}, "split end")

end

test()

return ml

