--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 下午3:26
-- To change this template use File | Settings | File Templates.
--

local ngx = ngx
local require = require
local pacllrequire = require('vendor.Require')
local log = require("vendor.Log")
local table = require('vendor.Table')
local os = os

local _M = require("vendor.Controller"):new {
    _VERSION = '0.01',
    validate = require('validate.UserValidate')
}
local request = require("vendor.Request")
local model = require("models.User")

-- 添加用户
function _M:addAction()
    local param = self.param
    param.updated_at = os.time()
    param.created_at = os.time()
    param.auth_key = os.time()
    param.password_hash = ngx.md5(param.password .. param.auth_key)
    param.password = nil
    local res = model:add(param)
    if not res or res == 0 then
        return self:fail()
    end
    return self:success()
end

-- 更新用户

function _M:updateAction()
    local param = self.param
    local time = os.time()
    param.updated_at = time
    if param.password then
        param.auth_key = time
        param.password_hash = ngx.md5(param.password .. param.auth_key)
        param.password = nil
    end
    local id = param.id
    local res = model:update(id, param)
    if not res or res == 0 then
        return self:fail()
    end
    return self:success()
end

-- 获取对应的用户
function _M:getAction()
    local param = self.param
    local res = model:get(param.id)
    if not res or res == 0 then
        return self:fail()
    end
    return self:success(res)
end

-- 删除用户
function _M:delAction()
    local param = self.param
    local res = model:delete(param.id)
    if not res or res == 0 then
        return self:fail()
    end
    return self:success()
end

return _M
