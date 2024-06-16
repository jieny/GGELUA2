-- @Author              : GGELUA
-- @Date                : 2021-04-08 08:00:20
-- @Last Modified by    : Please set LastEditors
-- @Last Modified time  : 2022-05-09 12:18:10
-- 声明：例子仅供学习交流

local GGEF = require('GGE.函数')
local SDL = require('SDL')
引擎 =
    require 'SDL.窗口' {
    标题 = 'GGELUA_XYQ',
    宽度 = 800,
    高度 = 600,
    帧率 = 60,
    可调整 = true
}

function 引擎:初始化()
    __资源 = require('资源')()
    if 1 == 1 then
        __地图 = require('地图')(1001)
        __主角 = require('主角') {id = 1, x = 807, y = 1386}
    else
        __地图 = require('地图')(1173)
        __主角 = require('主角') {id = 1, x = 4561, y = 1721}
    end

    __地图:加入(__主角)
    --music = __资源:取音效('music/0x00167186.mp3'):播放(true)
end

function 引擎:更新事件(dt, x, y)
    __地图:更新(dt)
end

function 引擎:渲染事件(dt, x, y)
    if self:渲染开始() then
        __地图:显示()

        self:渲染结束()
    end
end

function 引擎:窗口事件(ev)
    if ev == SDL.WINDOWEVENT_CLOSE then
        引擎:关闭()
    elseif ev == SDL.WINDOWEVENT_SIZE_CHANGED then
        __地图:置宽高(self.宽度, self.高度)
    end
end

function 引擎:键盘事件(KEY, KMOD, 状态, 按住)
    if not 状态 then --弹起
        if KEY == SDL.KEY_F1 then
            print('F1')
        end
    end
    if KMOD & SDL.KMOD_LCTRL ~= 0 then
        print('左CTRL', 按住)
    end
    if KMOD & SDL.KMOD_ALT ~= 0 then
        print('左右ALT', 按住)
    end
end

function 引擎:鼠标事件(key, x, y, btn, ...)
    if btn ~= SDL.BUTTON_LEFT then
        return
    end
    if key == SDL.MOUSE_DOWN then
    elseif key == SDL.MOUSE_MOTION then
    elseif key == SDL.MOUSE_UP then
        __主角.xy = require('GGE.坐标')(__地图.xy + require('GGE.坐标')(x, y))
        print(__主角.xy)
    end
end

function 引擎:输入事件()
end

function 引擎:销毁事件()
end
