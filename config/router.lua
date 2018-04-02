--routerConfig
--version:'0.0.1'
--Copyright (C) Yuanlun He.


local router = {}

router["/get"] = "site.get"

router["/useradd"] = "user.add"
router["/userupdate"] = "user.update"
router["/userdel"] = "user.del"
router["/userget"] = "user.get"

router["/query"] = "site.query"
router["/upload"] = "site.upload"
router["/check"] = "site.checkData"
router["/redis"] = "site.redis"
return router