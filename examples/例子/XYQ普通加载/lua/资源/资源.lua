-- @Author              : GGELUA
-- @Date                : 2021-05-06 08:18:23
-- @Last Modified by    : Please set LastEditors
-- @Last Modified time  : 2022-05-08 11:07:55
require('对象/主角')
local SDL = require('SDL')
local SDF = require('SDL.函数')
require('GGE.资源')

local 资源 = class('资源', 'GGE资源')

function 资源:初始化()
    print(gge.platform)
    self:添加路径('assets')
    --self:添加路径(SDF.取内部存储路径(), 1)
end

function 资源:取地图(id)
    local path = self:是否存在('scene/%d.map', id)
    if path then
        return require('资源/map')(path)
    end
end

function 资源:取动画(path)
    path = self:是否存在(path)
    if path then
        return require('资源/tcp')(self:取数据(path))
    end
end

return 资源
