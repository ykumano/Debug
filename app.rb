$IMAGE_TITLE = 0
$IMAGE_MIKU = 6
$IMAGE_RUBY = 5
$IMAGE_SQUARE = 8

class Point2D
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def moveBy(vec)
        @x += vec.dx
        @y += vec.dy
        self
    end
end

class Angle
    attr_accessor :th

    def initialize(th)
        @th = th
    end

    def turn(r)
        @th += r
        if (@th > (Math::PI * 2)) then
            @th -= (Math::PI * 2)
        elsif (@th < 0) then
            @th += (Math::PI * 2)
        end

        self
    end
end

class Vec2D
    attr_reader :dx, :dy, :angle

    # コンストラクタ
    def initialize(dx, dy)
        @dx = dx
        @dy = dy

        @scalar = Math.sqrt(@dx * @dx + @dy * @dy)
        @angle = Angle.new(Math.atan2(dy, dx))
    end

    def setAngle(angle, scalar)
        @scalar = scalar
        @angle = angle
    end

    # 加速
    def accel(acc, max)
        @scalar += acc

        if (@scalar > max) then
            @scalar = max
        end
        updateXy

        self
    end

    # 方位変更
    def turn(r)
        @angle.turn(r)
        updateXy

        self
    end

    def setVec(dx, dy)
        @dx = dx
        @dy = dy

        @scalar = Math.sqrt(@dx * @dx + @dy * @dy)
        @angle.th = Math.atan2(dy, dx)
    end

    def updateXy
        # dx, dyを更新
        @dx = Math::cos(@angle.th) * @scalar
        @dy = Math::sin(@angle.th) * @scalar
    end

    def print
        gnDebugLog(sprintf("dx:%f dy:%f angle:%f scalar:%f\n", @dx, @dy, @angle, @scalar))
        self
    end
end

#class Rot3D
#    attr_reader :x, :y, :z
#
#    def initialize(x, y, z)
#        @x = Angle.new(x)
#        @y = Angle.new(y)
#        @z = Angle.new(z)
#    end
#end

class Element2D
    attr_reader :pos, :vec2d, :scale

    def initialize(x, y, scale = 1.0)
        @pos = Point2D.new(x, y)
        @vec2d = Vec2D.new(0, 0)
        @scale = scale
    end

    def move
        @pos.moveBy(@vec2d)
        self
    end

    def turn(r)
        @vec2d.turn(r)
        self
    end

    def print
        gnDebugLog(sprintf("Element x:%f y:%f\n", @pos.x, @pos.y))
        self
    end
end

class Sprite
    attr_accessor :elem

    def initialize(id)
        @pos = Point2D.new(0, 0)
        @id = id
        @elem = nil
    end

    def setElement(elem)
        @elem = elem
    end

#    def draw(pos, angle = 0.0, scale = 1.0)
#        gnDrawImage(@id, pos.x, pos.y, angle, scale, 1)
#        self
#    end

    def draw
        gnDrawImage(@id, @elem.pos.x, @elem.pos.y, @elem.vec2d.angle.th, @elem.scale, 1)
        self
    end

#    def drawElement(elem)
#        gnDrawImage(@id, elem.pos.x, elem.pos.y, elem.rot3d.z.th, elem.scale, 1)
#        self
#    end

#    def drawElement3d(elem)
#        gnDrawImage3d(@id, elem.pos.x, elem.pos.y, elem.rot3d.x.th, elem.rot3d.y.th, elem.rot3d.z.th)
#        self
#    end

    def print
        gnDebugLog(sprintf("Sprite x:%f y:%f\n", @pos.x, @pos.y))
        self
    end
end

# タイトル画面
#-----------------------------------------------------------------------------
class PanelTest < Panel
    # 生成
    def initialize()
        @children = []
        @rot = 0
        @elem = Element2D.new(40.0, 40.0)
        @elem.vec2d.setVec(0.4, 0.2)
        @sprite = Sprite.new($IMAGE_MIKU)
        @sprite.setElement(@elem)
    end

    def onTap
    end

    # 初期化
    def init()
        super
        GNTouch.setOnTapList( [lambda { onTap }] )
    end

    # 破棄
    def finish()
    end

    def render
        super
#        gnDrawLine(10, 10, 50, 20, 0xffffff);
#        gnDrawImage($IMAGE_MIKU, 30, 30, @rot, 1.0, 1)
#        @rot += 0.01
#        if @rot > Math::PI*2 then
#            @rot = 0
#        end

#        @sprite.draw(@elem.moveBy(Vec2D.new(0.3, 0.5)).pos)

#         @sprite.elem.moveBy(Vec2D.new(0.2, 0.4)).rotZ(0.01)
         @sprite.elem.turn(0.01).move
         @sprite.draw

#        @sprite.draw(@elem.pos)
#        @sprite.draw(@elem.pos, @elem.angle)

#        @sprite.drawElement(@elem.rotZ(0.02))
#        @sprite.drawElement3d(@elem.rot(0.02, 0.02, 0.01))
    end
end

# メイン初期化
#-----------------------------------------------------------------------------
def initApp()
    # タッチパネル処理初期化
    GNTouch.init()

    # 操作パッド生成
    $vpad = VPad3.new()

    # Screen生成
    $theScreen = Screen.new(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT)

    # タイトル画面作成
    $panelTest = PanelTest.new()

    # タイトル画面表示
    $theScreen.setPanel($panelTest)

    gnDebugLog("initApp\n")
end

def finishApp()
    $theScreen.finish()
end

# メインループ
#-----------------------------------------------------------------------------
def mainLoop()
    $vpad.update()
    $theScreen.update()
    $theScreen.render()
end
