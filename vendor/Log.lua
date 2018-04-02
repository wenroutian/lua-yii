--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/29
-- Time: 上午8:28
-- To change this template use File | Settings | File Templates.
--
local _M = {}
local util = require("vendor.Util")
function _M:log(data)
    if not data then
        return
    end
    if type(data) == "table" then
        data = util.json_encode(data)
    end
    local date = os.date("%Y-%m-%d")
    local file = ngx.var.realpath_root .. "/log/" .. date .. ".log"
    local fp = io.open(file, "a") -- 使用 io.open() 函数，以添加模式打开文件
    fp:write(os.date("%Y-%m-%d %H:%M:%S") .. data .. '\r\n') -- 使用 file:write() 函数，在文件末尾追加内容
    fp:close()
end

return _M