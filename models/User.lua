--
-- Created by IntelliJ IDEA.
-- User: xiaobo
-- Date: 2018/3/28
-- Time: 上午8:13
-- To change this template use File | Settings | File Templates.
--
local require = require

local log = require('vendor.log')

local _M = require('vendor.ActiveRecord') { tableName = function() return "user" end }


function _M:findOneById(id)
    local user = self.find().where({ id = id }).all()
    return user
end

function _M:getCountByName(name)
    local count = self.find().where({ username = name }).count()
    return count
end

function _M:getCountByEmail(useremail)
    local count = self.find().where({ useremail = useremail }).count()
    return count
end

function _M:add(data)
    local query = self.new(data)
    query.save()
    log:log(query.get('err'))
    log:log(query.get('insert_id'))
    return query.get('insert_id')
end

function _M:update(id, data)
    local query = self.new(data)
    query.where({ id = id }).update()
    log:log(query.get('err'))
    log:log(query.get('affected_rows'))
    return query.get('affected_rows')
end

function _M:delete(id)
    local query = self.new()
    query.where({ id = id }).delete()
    log:log(query.get('err'))
    log:log(query.get('affected_rows'))
    return query.get('affected_rows')
end

function _M:get(id)
    local query = self.new()
    local res = query.select('id,created_at,username,useremail,updated_at,status').where({ id = id }).one()
    return res
end


return _M
