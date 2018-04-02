--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 下午2:10
-- To change this template use File | Settings | File Templates.
--

--memchache处理类
--version:0.0.1
--Copyright (C) Yuanlun He.

local setmetatable = setmetatable
local require = require

local redis = require "resty.redis"

local _M = {
    _VERSION = '0.01',
    timeout = 1000,
    host = "127.0.0.1",
    port = 6379,
}

function _M.__index(self, key)
    return _M[key] or function(...)

        local redis, err = redis:new()
        if not redis then
            return nil, err
        end

        redis:set_timeout(self.timeout) -- 1 sec

        local ok, err = redis:connect(self.host, self.port)
        if not ok then
            return nil, err
        end

        local ok, err = redis[key](redis, ...)

        redis:set_keepalive(10000, 100) --放回连接池

        return ok, err
    end
end

function _M.new(self, config)
    config = config or {}
    return setmetatable(config, self)
end

return _M
