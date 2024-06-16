-- @Author       : GGELUA
-- @Date         : 2021-09-01 22:40:52
-- @Last Modified by    : GGELUA
-- @Last Modified time  : 2022-03-22 21:07:24

local _坐标 = require('GGE.坐标')

local function _坐标到格子(x, y)
    if type(x) == 'table' then
        x, y = x.x, x.y
    end
    return x // 20, y // 20
end

local function _格子到坐标(x, y)
    if type(x) == 'table' then
        x, y = x.x, x.y
    end
    return _坐标(x * 20, y * 20)
end

local 地图寻路 = class('地图寻路')

function 地图寻路:地图寻路(w, h, data)
    self._ud = require('gastar')(w, h, data)
    self._p = {}
    self.w = w
    self.h = h
end

function 地图寻路:检查点(x, y)
    return self._ud:CheckPoint(x, y)
end

function 地图寻路:寻路(xy, txy)
    local x, y = _坐标到格子(xy)
    local tx, ty = _坐标到格子(txy)

    if self:判断直线障碍(xy, txy) then
        if not self._ud:CheckPoint(tx, ty) then --目标是障碍
            tx, ty = _坐标到格子(self:最近坐标(txy) or xy)
        end
        if not self._ud:CheckPoint(x, y) then --卡障碍
            xy = self:最近坐标(xy)
            if xy then
                x, y = _坐标到格子(xy)
            else
                return {}
            end
        end
        self._p = self._ud:GetPath(x, y, tx, ty)
    else
        self._p = {_坐标(txy.x / 20, txy.y / 20)}
    end
    return self._p
end

function 地图寻路:下一点(xy)
    if xy then
        local 坐标, 位置 = self._p[1], #self._p
        坐标 = _格子到坐标(坐标)
        for i, v in ipairs(self._p) do
            v = _格子到坐标(v)
            if self:判断直线障碍(xy, v) then
                位置 = i
                break
            else
                坐标 = v
            end
        end
        for i = 1, 位置 do
            table.remove(self._p, 1)
        end

        坐标 = _坐标(坐标)
        坐标.是否路径 = true
        return 坐标
    end
    return #self._p > 0
end

function 地图寻路:判断直线障碍(xy, txy)
    local 距离 = xy:取距离(txy) - 10
    local 孤度 = xy:取弧度(txy)

    local 坐标
    repeat
        坐标 = xy:取距离坐标(距离, 孤度)
        if not self._ud:CheckPoint(_坐标到格子(坐标)) then
            return true
        end
        距离 = 距离 - 10
    until 距离 < 0
    return false
end

function 地图寻路:最近坐标(xy) --最近可以行走的坐标
    local 距离 = 20
    local 坐标
    repeat
        for i = 0, 6, 0.5 do
            坐标 = xy:取距离坐标(距离, i)
            if self._ud:CheckPoint(_坐标到格子(坐标)) then
                return 坐标
            end
        end
        距离 = 距离 + 20
    until 距离 > 500
end

return 地图寻路
