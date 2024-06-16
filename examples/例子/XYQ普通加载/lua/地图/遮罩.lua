-- @Author              : GGELUA
-- @Date                : 2022-03-07 05:10:34
-- @Last Modified by    : Please set LastEditors
-- @Last Modified time  : 2022-05-10 04:33:49

local function 取排序点(sf, x)
    for y = 0, sf.h - 1 do
        if ({sf:GetSurfacePixel(x, y)})[4] == 1 then --排序点，在alpha里
            return y + 1
        end
    end
    return sf.h
end

local 地图遮罩 = class('地图遮罩')

function 地图遮罩:初始化(t)
    self.id = t.x .. '_' .. t.y
    self.x = t.x
    self.y = t.y
    self.w = t.w
    self.h = t.h
    --self.spr = require('SDL.精灵')(0, self.x, self.y, self.w, self.h)
    self.xy = require('GGE.坐标')(self.x, self.y)

    self.rect = require('SDL.矩形')(self.x, self.y, self.w, self.h)

    self.pos = {[0] = self.y + self.h}

    self.排序点 = {}
end

function 地图遮罩:置图像(sf)
    for x = 0, self.w, 10 do
        table.insert(self.pos, 取排序点(sf, x) + self.y)
    end
    if self.w % 10 ~= 0 then
        table.insert(self.pos, 取排序点(sf, self.w - 1) + self.y)
    end
    for i, y in ipairs(self.pos) do
        self.排序点[i] = require('GGE.坐标')(self.x + (i - 1) * 10, y)
    end
    self.spr = require('SDL.精灵')(sf)
end

function 地图遮罩:更新()
end

function 地图遮罩:显示(xy)
    if self.spr then
        self.spr:显示(self.xy - xy)
        self.spr:取矩形():显示()
    end

    for i, v in ipairs(self.排序点) do
        local xy = v - xy
        xy:显示()
    end
end

function 地图遮罩:检查点(xy)
    return self.rect:检查点(xy)
end

function 地图遮罩:检查排序点(p, xy) --判断目标是否在遮罩后面
    if self.spr then
        self.spr:置坐标(self.xy - xy)
        if self.spr:取矩形():检查交集(p.rect) then
            if p.xy.x >= self.x and p.xy.x <= self.x + self.w then
                local x = math.ceil((p.xy.x - self.x) / 10)
                if x <= 0 then
                    x = 1
                end
                if x > #self.pos then
                    x = #self.pos
                end
                return p.xy.y < self.pos[x]
            elseif p.xy.x < self.x then
                return p.xy.y < self.pos[1]
            elseif p.xy.x > self.x + self.w then
                return p.xy.y < self.pos[#self.pos]
            end
        end
    end

    return false
end

return 地图遮罩
