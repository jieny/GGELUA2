-- @Author              : GGELUA
-- @Last Modified by    : Please set LastEditors
-- @Date                : 2022-03-23 10:09:27
-- @Last Modified time  : 2022-05-11 19:09:53
if gge.isdebug and os.getenv('LOCAL_LUA_DEBUGGER_VSCODE') == '1' then
    package.loaded['lldebugger'] = assert(loadfile(os.getenv('LOCAL_LUA_DEBUGGER_FILEPATH')))()
    require('lldebugger').start()
end
local SDL = require('SDL')
引擎 =
    require 'SDL.窗口' {
    标题 = 'XYQ染色',
    宽度 = 800,
    高度 = 600,
    帧率 = 60
}

local function dewpal(data)
    local flag, num, pos = string.unpack('<c4I4', data)
    if flag == 'wpal' then
        local h, n = {}
        for i = 1, num + 1 do
            n, pos = string.unpack('<I4', data, pos)
            table.insert(h, n)
        end
        local ret = {}
        for i = 1, num do --分段数(部位)
            ret[i] = {a = h[i], b = h[i + 1]}
            n, pos = string.unpack('<I4', data, pos)

            for j = 1, n do --方案数
                ret[i][j] = {}

                for N = 1, 9 do
                    n, pos = string.unpack('<I4', data, pos)
                    ret[i][j][N] = n
                end
            end
        end
        return ret
    end
end

function 引擎:初始化()
    wpal = dewpal(SDL.LoadFile('assets/0001-虎头怪.wpal'))
    tcp = require('tcp')(SDL.LoadFile('assets/虎头怪_静立.was'))

    tcp:调色(wpal, 0x03030303)
    ani1 = tcp:取动画(1):播放(true)
    ani1.资源.p = 0x03030303

    tcp:调色(wpal, 0x04040404)
    ani2 = tcp:取动画(1):播放(true)
    ani2.资源.p = 0x04040404
end

function 引擎:更新事件(dt, x, y)
    ani1:更新(dt)
    ani2:更新(dt)
end

function 引擎:渲染事件(dt, x, y)
    if self:渲染开始(0x70, 0x70, 0x70) then
        ani1:显示(100, 100)
        ani2:显示(x, y)
        self:渲染结束()
    end
end

function 引擎:窗口事件(ev)
    if ev == SDL.WINDOWEVENT_CLOSE then
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
