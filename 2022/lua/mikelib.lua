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

local List = {}

local function tolist(obj)
    if islist(obj) then
        return obj
    end
    local lst
    if type(obj) == "function" then
    elseif type(obj) == "table" then
        lst = obj
    else
        lst = {}
    end


end

List.__call = tolist

return {
    split=split,
    List=List,
}