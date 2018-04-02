--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/30
-- Time: 下午2:12
-- To change this template use File | Settings | File Templates.
--
local require = require

return require('vendor.Redis'):new {
    host = "127.0.0.1",
    port = 6379,
}
