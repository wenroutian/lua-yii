--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 上午11:25
-- To change this template use File | Settings | File Templates.
--


local require = require

local _M = require("vendor.Model"):new { _version = '0.0.1' }

local rememberMe = false
local User = require('models.User')

function _M.rules()
    return {
        add = {
            { { 'username', 'password', 'useremail' }, 'trim' },
            { 'username', 'required', message = '请填写登录账号' },
            --{'username', 'email'}, --用户名必须为email时设置
            { 'password', 'required', message = '请填写登录密码' },
            { 'password', 'length', message = '密码长度太短', min = 6 },
            { 'useremail', 'required', message = '请填邮箱' },
            { 'useremail', 'email', message = '用户邮箱不正确' }, --用户名必须为email时设置
            --使用自定义方法校验参数
            { 'username', 'checkUsernameExist' },
            { 'useremail', 'checkUserEmailExist' }
        },
        update = {
            { { 'username' }, 'trim' },
            { 'id', 'required', message = '主键id不能为空' },
            --{'username', 'email'}, --用户名必须为email时设置
            { 'username', 'required', message = '请填写登录密码' },
            --使用自定义方法校验参数
            { 'username', 'checkUsernameExist' },
        },
        del = {
            { 'id', 'required', message = '主键id不能为空' }
        }
    }
end

function _M:checkPass(key)
    if self:hasErrors() then return nil end
    local user = Userinfo.getUserByName(self.username)
    if not user then
        self:addError('username', '账号不存在')
    elseif user.password ~= self.password then
        self:addError('password', '密码错误')
    else
        self.userinfo = user
    end
end

function _M:checkUsernameExist(key)
    if self:hasErrors() then return nil end
    local count = User:getCountByName(self.username)
    if count ~= 0 then
        self:addError('username', '账号已存在')
    end
end

function _M:checkUserEmailExist(key)
    if self:hasErrors() then return nil end
    local count = User:getCountByEmail(self.useremail)
    if count ~= 0 then
        self:addError('useremail', '邮箱已注册')
    end
end

return _M