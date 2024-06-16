-- @Author              : GGELUA
-- @Date                : 2021-04-08 08:05:24
-- @Last Modified by    : Please set LastEditors
-- @Last Modified time  : 2022-05-10 06:02:31

local SDL = require 'SDL'

local callback = setmetatable({}, {__mode = 'v'})
local ue = --userevent
    SDL.RegisterUserEvent(
    function(code, ...)
        code = code & 0xFFFFFFFF --转无符号
        if callback[code] then
            callback[code]:线程事件(...)
        end
    end
)

local map = class('map')

function map:初始化(path)
    local code = require('gxy2.hash')(tostring(self))
    callback[code] = self
    local ud, info = require('gxy2.map')(path, ue, code)

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
    self.mapco = {}
    self.maskco = {}
    self.mask = {}
end

function map:线程事件(data)
    local r = {self.ud:GetResult(data)}
    if type(r[1]) == 'number' then
        local id, sf, mask = table.unpack(r)

        for k, v in pairs(mask) do
            local mid = v.x .. '_' .. v.y
            if not self.mask[mid] then
                local 遮罩 = require('地图/遮罩')(v)
                v.遮罩 = 遮罩
                table.insert(self.maskco, v)
                mask[k] = 遮罩
                self.mask[mid] = 遮罩
            else
                mask[k] = self.mask[mid]
            end
        end

        coroutine.xpcall(
            self.mapco[id],
            {
                精灵 = require('SDL.精灵')(sf),
                遮罩 = mask
            }
        )
        self.mapco[id] = nil
    else
        local info, sf = table.unpack(r)
        info.遮罩:置图像(sf)
    end

    if not next(self.mapco) and next(self.maskco) then
        local mask = table.remove(self.maskco, 1)
        self.ud:GetMask(mask, true)
    end
end

function map:取障碍()
    return self.ud:GetCell()
end

function map:取精灵(id)
    local co, main = coroutine.running()
    if not main then
        self.ud:GetMap(id, true)
        self.mapco[id] = co
        return coroutine.yield()
    end
end

function map:清空缓存()
    self.ud:Clear()
end
return map
