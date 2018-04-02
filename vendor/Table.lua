--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 下午4:46
-- To change this template use File | Settings | File Templates.
--

local function not_table(t) return type(t) ~= 'table' end

local function get(args, key, default)
    if key and args then
        return args[key] or default or nil
    else
        return args
    end
end

local function flip(tab)
    if not_table(tab) then return nil end

    local newTable = {}

    for k, v in pairs(tab) do
        newTable[v] = k
    end

    return newTable
end

local function keys(tab)
    if not_table(tab) then return nil end

    local new = {}
    for k in pairs(tab) do
        new[#new + 1] = k
    end
    return new
end

local function count(tab)
    if not_table(tab) then return nil end

    local i = 0
    for _ in pairs(tab) do
        i = i + 1
    end
    return i
end

--local function deep_copy(from, to, already)
--    local ret = (to == nil) and {} or to
--    if not already then already = {} end
--    if already[from] then return "<recursion>" end
--    already[from] = true
--    for k, v in pairs(from) do
--        ret[k] = type(v) == 'table' and deep_copy(v, nil, already) or v
--    end
--    return ret
-- end

local function shallow_copy(from, to)
    local ret = (to == nil) and {} or to
    for k, v in pairs(from) do
        ret[k] = v
    end
    return ret
end

local function copy(from, to, deep)
    return deep and deep_copy(from, to) or shallow_copy(from, to)
end

local function deep_copy(from, to)
    local ret = (to == nil) and {} or to
    for k, v in pairs(from) do
        if not_table(v) then
            ret[k] = v
        else
            deep_copy(v, ret[k])
        end
    end
    return ret
end




local function compare(t1, t2)
    if type(t1) == type(t2) then
        if type(t1) == 'table' then
            local bool = true
            for k, v in pairs(t1) do bool = bool and compare(v, t2[k])
            end
            return bool
        elseif type(t1) == 'function' then return true
        end
        return t1 == t2
    end
    return false
end

local function each_recursive(t, f, index, notKeys, each_dict, path)

    if type(t) == 'table' then
        each_dict = each_dict or {}
        if each_dict[t] then return else each_dict[t] = true
        end

        path = path or ''

        f(index, t, path)

        for k, v in pairs(t) do
            if not notKeys then
                each_recursive(k, f, nil, notKeys, each_dict, path .. '#')
            end
            each_recursive(v, f, k, notKeys, each_dict,
                path .. ((type(k) == 'string' or type(k) == 'number')
                        and k or inspect(k)) .. '.')
        end
    else
        f(index, t, path)
    end
end

local function make_const(mutable)
    for k, v in pairs(mutable) do
        if type(k) == 'table' then
            mutable[k] = nil
            k = make_const(k)
            mutable[k] = v
        end
        if type(v) == 'table' then
            mutable[k] = make_const(v)
        end
    end
    return setmetatable({}, {
        __index = mutable,
        __newindex = function() error("const-violation on table")
        end,
        __metatable = false,
    });
end

local function map(tab, fn)
    local ret = {}
    for ik, iv in pairs(tab) do
        local fv, fk = fn(iv, ik)
        ret[fk and fk or ik] = fv
    end
    return ret
end

local function at(tab, ...)
    local dim = { ... }
    local last = nil
    for _, d in pairs(dim) do
        last = tab[d]
        if last then
            tab = last
        else
            return nil
        end
    end
    return last
end

local function set(tab)
    local new = {}
    for _, d in pairs(tab) do new[d] = true
    end
    return new
end

local function pack(...)
    return { n = select("#", ...), ... }
end

local function first(t)
    if not_table(t) then return nil
    end
    for _, v in pairs(t) do return v
    end
end

local function first_key(t)
    if not_table(t) then return nil
    end
    for k, _ in pairs(t) do return k
    end
end

local function filter(t, f)
    if not_table(t) then return nil
    end
    local result = {}
    for k, v in pairs(t) do if f(v) then result[k] = v
    end
    end
    return result
end

local function empty(t)
    if not_table(t) then return true
    end
    return next(t) == nil
end

local function each(t, f)
    if not_table(t) then return nil
    end
    for k, v in pairs(t) do f(v, k)
    end
    return t
end

local function add(t, key, value) t[key] = value; return t
end

local function complete(t, key, valort)
    if type(key) == 'table' then
        for k, v in pairs(key) do complete(t, k, v)
        end; return t
    end

    assert(type(key) == 'string')
    if not_table(t) then error 'cant add anything'
    end

    for k, v in pairs(t) do
        --if not_table(v) then t[k] = {v}; v = t[k] end
        if not v[key] then v[key] = valort
        end
    end

    return t
end

local function explode(div, str) -- credit: http://richard.warburton.it
    if (div == '') then return false
    end

    local pos, arr = 0, {}

    for st, sp in function() return string.find(str, div, pos, true)
    end do
        arr[#arr + 1] = string.sub(str, pos, st - 1)
        pos = sp + 1
    end

    arr[#arr + 1] = string.sub(str, pos)
    return arr
end

local exports = {
    flip = flip,
    keys = keys,
    count = count,
    copy = copy,
    deep_copy = deep_copy,
    shallow_copy = shallow_copy,
    compare = compare,
    each_recursive = each_recursive,
    make_const = make_const,
    at = at,
    set = set,
    pack = pack,
    first = first,
    first_key = first_key,
    filter = filter,
    empty = empty,
    each = each,
    map = map,
    add = add,
    complete = complete,
    explode = explode,
    get = get
}

return exports