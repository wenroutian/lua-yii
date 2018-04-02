--数据库配置
--Copyright (C) Yuanlun He.

local require = require

return require('vendor.Mysql'):new{
	host = "127.0.0.1",
    port = 3306,
    database = "test",
    user = "root",
    password = "root",
    charset = "utf8", 
}
