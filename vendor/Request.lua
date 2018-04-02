--请求处理类
--version:0.0.1
--Copyright (C) Yuanlun He.

local setmetatable = setmetatable
local find = string.find
local pairs = pairs
local type = type
local ngx_req = ngx.req
local ngx_var = ngx.var
local table = require('vendor.Table')
local log = require('vendor.log')

local _M = { _VERSION = '0.01' }

function _M.get(key, default)
    local args = ngx_req.get_uri_args()
    return table.get(args, key, default)
end

function _M.cookie(key, default)
    if key and ngx_var then
        return ngx_var["cookie_" .. key] or default
    end
    return ngx_var.http_cookie
end


function _M.post(key, default)
    ngx_req.read_body()
    local args = ngx_req.get_post_args()
    return table.get(args, key, default)
end

function _M.data(key, default)
    local get = ngx_req.get_uri_args()
    ngx_req.read_body()
    local post = ngx_req.get_post_args()
    local data = {}
    if ngx.var.method == 'GET' then
        data = table.deep_copy(get, post, true)
    else
        data = table.deep_copy(post, get, true)
    end
    return table.get(data, key, default) or {}
end



function _M.isPostFile()
    local header = ngx_var.content_type
    if not header then return false end

    if type(header) == "table" then
        header = header[1]
    end
    return find(header, "multipart") and true or false
end

return _M
