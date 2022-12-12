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
local Map = {}
setmetatable(Map, Map)

local function is_list(obj)
    return getmetatable(obj) == List
end

local function is_map(obj)
    return getmetatable(obj) == Map
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

-- list_map - map a function over a list or list-like table
local function list_map(itbl, fcn)
    local lst = List({})
    for k,v in ipairs(itbl) do
        insert(lst, fcn(v))
    end
    return lst
end

-- list_filter - return values in itbl for which fcn returns truthy
local function list_filter(itbl, fcn)
    local lst = List({})
    for _,v in ipairs(itbl) do
        if fcn(v) then
            insert(lst, v)
        end
    end
    return lst
end

local function identity(x)
    return x
end

-- returns the number of list items in itbl for which fcn returns true
-- if fcn is nil, then returns the number of truthy items in the table
local function list_count(itbl, fcn)
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

local function list_invert(itbl)
    local mp = Map({})
    for i,v in ipairs(itbl) do
        mp[v] = i
    end
    return mp
end

List.__index = List -- why?
List.__tostring = list_to_string
List.__eq = lists_equal
List.map = list_map
List.count = list_count
List.invert = list_invert
List.filter = list_filter
-- Below is to make it so that List({1,2,3}) returns a new List
setmetatable(List, {
    __call=function(klass, obj) return tolist(obj) end
})


local function iter_to_map(itr)
    local mp = Map({})
    for k,v in pairs(itr) do
        mp[k] = v
    end
    return mp
end

-- convert an obj to a map if possible
-- 
-- obj -- a table, iterator, List, or Map
-- returns: Map (or error if not convertible)
local function tomap(obj)
    if is_map(obj) then
        return obj
    end

    obj = obj or {}

    if type(obj) == "function" then
        return iter_to_map(obj)
    elseif type(obj) == "table" then
        setmetatable(obj, Map)  -- what if it's a list already &&& ?
        return obj
    else
        error("Can't convert type " .. type(obj) .. " to Map")
    end
end

local function maps_equal(mp1, mp2)
    for k1, v1 in pairs(mp1) do
        local v2 = mp2[k1]
        if v2 ~= v1 then
            return false
        end
    end
    return true
end

local function map_to_string(tbl)
    local t = {}
    for k,v in pairs(tbl) do
        if type(v) == "string" then
           insert(t, format('%s=%q', k, tostring(v)))
        else
            insert(t, format('%s=%s', k, tostring(v)))
        end
    end
    return '{' .. table.concat(t, ",") .. "}"
end

-- index mp by each item in itbl and return a list the truthy values mp[i]
local function map_index(mp, itbl) 
    local lst = List{}
    for i,v in ipairs(itbl) do
        if mp[v] then
            insert(lst, mp[v])
        end
    end
    return lst
end

Map.__index = Map -- why?
Map.__tostring = map_to_string
Map.__eq = maps_equal
Map.index = map_index
--Map.map = map_map
-- Below is to make it so that Map({a=1, b=2}} returns a Map
setmetatable(Map, {
    __call=function(klass, obj) return tomap(obj) end
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
    assert(lst1:map(function (x) return 2 * x end) == List{2,4,6}, "map list")

    local mp1 = Map({a=1,b=3,c="foo"})
    assert(mp1 == Map({a=1,b=3,c="foo"}), "map equal")
    --assert(tostring(mp1) == '{a=1,b=3,c="foo"}', "map_tostring")
    assert(List({2,4,5}):invert() == Map{[2]=1,[4]=2,[5]=3}, "list invert")
    assert(mp1:index({'a','c', 'x'}) == List{1, "foo"})

    local odd = function(x) return x % 2 == 1 end
    assert(lst2:filter(odd) == List{1,3}, "list filter")

    local split = String.split
    assert(split("foo,bar,baz", ",") == List{"foo", "bar", "baz"}, "split comma")
    assert(split("foo,bar,,baz", ",+") == List{"foo", "bar", "baz"}, "split pattern")
    assert(split("foo,bar,,baz,,", ",+") == List{"foo", "bar", "baz"}, "split end")

end

test()

return ml

