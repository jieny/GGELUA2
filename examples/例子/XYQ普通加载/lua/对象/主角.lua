-- @Author              : GGELUA
-- @Date                : 2022-03-07 03:05:14
-- @Last Modified by    : GGELUA
-- @Last Modified time  : 2022-03-23 13:57:06

local 玩家 = require('对象/玩家')
local 主角 = class('主角', 玩家)

function 主角:初始化()
end

function 主角:更新(dt)
    self[玩家]:更新(dt)
end

function 主角:显示(xy)
    self[玩家]:显示(xy)
end

return 主角
