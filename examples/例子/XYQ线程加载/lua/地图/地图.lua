-- @Author              : GGELUA
-- @Last Modified by    : Please set LastEditors
-- @Date                : 2022-05-09 11:59:31
-- @Last Modified time  : 2022-05-09 12:19:52

local 地图寻路 = require('地图/寻路')
local 地图类 = class('地图', 地图寻路)

function 地图类:初始化(id, width, height)
    local map = assert(__资源:取地图(id), '地图不存在')
    print(map.flag)
    self._map = map
    self.宽度 = map.width
    self.高度 = map.height
    self.列数 = map.colnum
    self.行数 = map.rownum
    self.总数 = map.mapnum
    self.地表 = {}
    self.遮罩 = {}
    self.对象 = {}
    self.obj = {}
    self:置宽高(width or 引擎.宽度, height or 引擎.高度)
    --==================================================================================
    地图寻路.地图寻路(self, self.列数 * 16, self.行数 * 12, map:取障碍())
end

function 地图类:置宽高(w, h)
    self._w = w
    self._h = h
    self._w2 = w // 2
    self._h2 = h // 2
    self._w3 = self.宽度 - self._w2
    self._h3 = self.高度 - self._h2

    self._x = nil
    self._y = nil
end

function 地图类:更新(dt)
    if self.up then --刷新玩家或遮罩
        self.up = false
        self.obj = {}
        for k, v in pairs(self.对象) do
            table.insert(self.obj, v)
        end
        --先对玩家，NPC排序
        table.sort(
            self.obj,
            function(a, b)
                return a:取排序点() < b:取排序点()
            end
        )

        --计算遮罩插入的位置
        for _, m in pairs(self.遮罩) do
            for i = #self.obj, 1, -1 do
                local p = self.obj[i]
                if ggetype(p) ~= '地图遮罩' then
                    if m:检查排序点(p, self.xy) then
                        table.insert(self.obj, i + 1, m)
                        break
                    end
                end
            end
        end

    --删除最底下的遮罩
    -- while ggetype(self.obj[1]) == '地图遮罩' do
    --     table.remove(self.obj, 1)
    -- end
    end

    for _, v in ipairs(self.obj) do
        v:更新(dt)
    end

    local x, y = __主角.xy.x, __主角.xy.y
    if x == self._x and y == self._y then --刷新地表
        return
    end

    self._x = x
    self._y = y
    if x > self._w3 then
        x = self._w3
    end
    if y > self._h3 then
        y = self._h3
    end
    x = x - self._w2
    y = y - self._h2
    if x < 0 then
        x = 0
    end
    if y < 0 then
        y = 0
    end
    self.x = x
    self.y = y
    self.xy = require('GGE.坐标')(x, y)

    self.list = {}
    self.遮罩 = {}
    local sid = (y // 240) * self.列数 + (x // 320)
    local id = sid
    x = -(x % 320)
    y = -(y % 240)

    for cy = y, self._h, 240 do
        for cx = x, self._w, 320 do
            if self.地表[id] then
                self.地表[id].x = cx
                self.地表[id].y = cy
                table.insert(self.list, self.地表[id])
                for k, v in pairs(self.地表[id].遮罩) do
                    self.遮罩[v.id] = v
                end
            elseif self.地表[id] == nil then
                self.地表[id] = false
                coroutine.xpcall(
                    function()
                        self.地表[id] = self._map:取精灵(id)
                        self._x = nil
                    end
                )
            end

            id = id + 1
            if id == self.列数 or id == self.总数 then
                break
            end
        end
        sid = sid + self.列数
        id = sid
        if sid >= self.总数 then
            break
        end
    end
    self.up = true
end

-- local 障碍 = require("SDL.精灵")(0,0,0,20,20):置颜色(0,0,0,150)
-- local 路径 = require("SDL.精灵")(0,0,0,20,20):置颜色(0,255,0,150)
--格子 = require("GGE.坐标")(20,20)
function 地图类:显示()
    for i, v in ipairs(self.list) do
        v.精灵:显示(v.x, v.y)
    end
    for _, v in ipairs(self.obj) do
        v:显示(self.xy)
    end
end

function 地图类:加入(v)
    self.对象[v.id] = v
    self.up = true
end
return 地图类
