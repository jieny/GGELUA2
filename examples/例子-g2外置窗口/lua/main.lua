local SDL = require('SDL')
引擎 =
    require 'SDL.窗口' {
    标题 = 'GGELUA_外置框',
    宽度 = 800,
    高度 = 600,
    帧率 = 60,
    渲染器 = 'direct3d11'
}

外置=
    require 'SDL.窗口'{
    标题='聊天窗口',
    宽度=260,
    高度=引擎.高度,
    帧率= 30,
    渲染器= 'opengl',
    父窗口 = 引擎,
}
--[[
function SDL精灵:SDL精灵(p, x, y, w, h, _win) --添加最后一个参数
    self._win = _win or SDL._win --默认窗口
end
]]
spr1 = require('lua/精灵')('assets/test.bmp',nil,nil,nil,nil,外置) --传入窗口
tex = require('lua/纹理')('assets/test.webp',外置)
spr2 = require('lua/精灵')(tex,nil,nil,nil,nil,外置)

function 外置:初始化()

end

function 外置:更新事件(dt, x, y)
    --外置框跟随主窗
    --====================================
    local 引擎x,引擎y = 引擎:取坐标()
    local 外置x,外置y = 外置:取坐标()
    if 引擎x+引擎.宽度+2~=外置x then
        self:置坐标(引擎x+引擎.宽度+2,引擎y)
    end
    --====================================
end
function 外置:渲染事件(dt, x, y)
    if self:渲染开始(0x70, 0x70, 0x70) then
        spr1:显示(0, 0)
        spr2:显示(0, 168)
        -- self:渲染清除(0x27,0x28,0x22)
        self:渲染结束()
    end
end
function 引擎:初始化() end

function 引擎:更新事件(dt, x, y) end

function 引擎:渲染事件(dt, x, y)
    if self:渲染开始(0x70, 0x70, 0x70) then
        -- spr1:显示(0, 0)
        -- spr2:显示(0, 0)
        self:渲染结束()
    end
end

function 引擎:窗口事件(消息)
    if 消息 == SDL.WINDOWEVENT_CLOSE then
        引擎:关闭()
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

function 引擎:鼠标事件()
end

function 引擎:输入事件()
end

function 引擎:销毁事件()
end
