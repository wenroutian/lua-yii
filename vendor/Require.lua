--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 下午3:05
-- To change this template use File | Settings | File Templates.
--

local pcall = pcall

local require = require

local _M = {
    _VERSION = '0.01',
}

function _M:require(file)
    return pcall(require, file)
end


return _M