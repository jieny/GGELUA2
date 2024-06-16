-- @Author              : GGELUA
-- @Date                : 2022-03-07 03:05:33
-- @Last Modified by    : GGELUA
-- @Last Modified time  : 2022-03-23 13:57:25

local 对象基类 = class('对象基类')

function 对象基类:初始化(t)
    self.id = t.id
    self.xy = require('GGE.坐标')(t.x, t.y)
    local tcp = __资源:取动画('shape/0x7726ba66.tcp')
    self.ani = tcp:取动画(1):播放(true)
end

function 对象基类:更新(dt)
    self.ani:更新(dt)
    self.rect = self.ani:取矩形()
end

function 对象基类:显示(xy)
    local xy = self.xy - xy
    self.ani:显示(xy)
    xy:显示()
    self.rect:显示()
end

function 对象基类:取排序点()
    return self.xy.y
end
return 对象基类
