-- @Author              : GGELUA
-- @Date                : 2022-03-07 03:05:56
-- @Last Modified by    : GGELUA
-- @Last Modified time  : 2022-03-23 13:57:13
local 基类 = require('对象/基类')
local 玩家 = class('玩家', 基类)

function 玩家:初始化()
end

function 玩家:更新(dt)
    self[基类]:更新(dt)
end

function 玩家:显示(xy)
    self[基类]:显示(xy)
end

return 玩家
