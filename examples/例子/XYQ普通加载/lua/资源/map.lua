-- @Author              : GGELUA
-- @Date                : 2021-04-08 08:05:24
-- @Last Modified by    : Please set LastEditors
-- @Last Modified time  : 2022-05-09 12:09:30

local SDL = require 'SDL'

local map = class('map')

function map:初始化(path)
    local ud, info = require('gxy2.map')(path)
    self.ud = ud
    for k, v in pairs(info) do
        --  rownum;//行
        --  colnum;//列
        --  mapnum;//图块数量
        --  masknum;//遮罩数量
        --  width;//地图宽度
        --  height;//地图高度
        self[k] = v
    end
    self.mask = {}
end

function map:取障碍()
    return self.ud:GetCell()
end

function map:取精灵(id)
    local sf, mask = self.ud:GetMap(id)
    for k, v in pairs(mask) do
        local mid = v.x .. '_' .. v.y
        if not self.mask[mid] then
            mask[k] = require('地图/遮罩')(v)
            mask[k]:置图像(self.ud:GetMask(v))
            self.mask[mid] = mask[k]
        else
            mask[k] = self.mask[mid]
        end
    end
    return {
        精灵 = require('SDL.精灵')(sf),
        遮罩 = mask
    }
end

return map
