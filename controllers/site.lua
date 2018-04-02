--site Controller
--version:0.0.1
--Copyright (C) Yuanlun He.

local Pager = require("vendor.Pager")
local ngx = ngx
local log = require("vendor.Log")

local _M = require("vendor.Controller"):new { _VERSION = '0.01' }
local request = require("vendor.Request")

function _M:indexAction()
    return self:render('index')
end

function _M:loginAction()
    if self.user.isLogin then return self:goHome() end

    local model = require('models.LoginForm'):new()

    if model:load(self.request.post()) and model:login(self.user) then
        return self:goHome()
    end

    return self:render('login', {
        model = model
    })
end

function _M:logoutAction()
    self.user.logout()
    return self:goHome()
end

function _M:guideAction()
    return self:render('guide')
end

function _M:getAction(a)
    local data = {}

    --local json = require('cjson')
    --setmetatable(data, json.empty_array_mt)
    --ngx.say("empty array: ", json.encode(data)) -- empty array: []
    --  local res = ngx.location.capture("/user")
    -- return self:outJson(res)
    --    local time = {}
    --    time.test = a
    --    local router = require("config.router")
    --
    --    time.router = ngx.req.get_uri_args()
    --
    --    time.site = 1
    --    time.status = ngx.var.method
    --    local ngx_req = ngx.req
    --    local ngx_var = ngx.var
    --    return self:outJson(time)
end

function _M:userAction()
    local user = {}
    ngx.req.read_body()
    local file = io.open("test2.txt", "a") -- 使用 io.open() 函数，以添加模式打开文件
    file:write("\nhello world") -- 使用 file:write() 函数，在文件末尾追加内容
    file:close()
    user.name = "xiaobo"
    user.sex = "男"
    user.age = 18
    user.date = os.date("%Y-%m-%d")

    user.data = request.get('a')
    user.string = ngx.var.query_string


    user.header = ngx.req.raw_header()
    user.dir = ngx.var.document_root
    user.real_path = ngx.var.realpath_root
    user.text = ngx.var.document_uri
    user.body = ngx.req.get_body_data()
    local ok = log:log(user)
    --user.ok = ok
    return self:outJson(user)
end

function _M:queryAction()
    local User = require('models.User') --使用Product数据表操作类
    local id = request.get('id')
    if id then
        local query = User:findOneById(id)
        if next(query) == nil then
            return self:outJson({ code = "1", message = "暂无此id的记录" })
        end
        -- local query = User.find().where({}).all() --fin()方法生成新的查询器
        --    local db = require('config.db')
        --
        --    --执行sql：
        --    local rows = db:query('select * from user')

        -- local page = Pager {
        --使用分页类
        --   pageSize = 8, --设置每页显示最多8条信息
        --   totalCount = query.count(), --使用查询器查询符合条件的数据总条数
        -- }
        --
        --local list = query.orderBy('id desc').all() --使用查询器查询分页数据集
        return self:outJson(query)
    end
    return self:outJson({ code = "1", message = "请传入id参数" })
end

function _M:uploadAction()
    local file = require('vendor.Files')
    local path = "/data/lua-yii/lua-resty-yii/"
    --local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    local filename = "test"
    local savename = path

    local ok, err = file.receive('file') --接收name为upfile的上传文件
    if not ok then
        return self:outJson({ retcode = 1, retmsg = '接收文件失败，请重试:' .. err })
    end
    return self:outJson({ ok })
end

function _M:checkDataAction()
    -- log:log(32)
    local validate = require('validate.UserValidate')
    --  local pcall = pcall
    --  local status, validate = pcall(require('validate.UserValidate'))
    --  if status then
    if not validate:validate() then
        return self:outJson({ validate.err })
    end
    --log:log(12)
    return self:outJson({ code = 0, message = "验证数据成功" })
    --  end
    --  return self:outJson({ validate })
end

function _M:redisAction()
    local require = require('vendor.Require');
    local status, redis = require:require('config.redis')
    if not status then
        return self:fail("初始化对应的redis错误")
    end
    -- return self:success({ redis })
    --  local redis = require('config.redis')
    local ok = redis.set('xiaobo', 'xiaobo')
    if ok then
        local name = redis.get('xiaobo')
        if name ~= ngx.null then
            return self:success({ name })
        end
    end
    return self:fail("添加失败")
end






function _M:log()
    log:log("this is log")
    log:log({
        data = {
            log = "log data"
        }
    })
end

return _M
