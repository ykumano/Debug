# ２次元ベクタ管理クラス
class Vector2d
    attr_reader :dx, :dy

    # コンストラクタ
    def initialize(dx, dy)
        @dx = dx
        @dy = dy

        @scalar = Math.sqrt(@dx * @dx + @dy * @dy)
        @angle = Math.atan2(dy, dx)
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
        @angle += r
        if (@angle > (Math::PI * 2)) then
            @angle -= (Math::PI * 2)
        end
        updateXy

        self
    end

    def updateXy
        # dx, dyを更新
        @dx = Math::cos(@angle) * @scalar
        @dy = Math::sin(@angle) * @scalar
    end

    def print
        printf("dx:%f dy:%f angle:%f scalar:%f\n", @dx, @dy, @angle, @scalar)
        self
    end
end

class Point2d
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

class Image
    def initialize(filename)
        @pos = Point2d.new(0, 0)
    end

    def draw(pos)
        printf("%d %d\n",pos.x, pos.y)
        self
    end
end

class Element
    attr_reader :pos
    attr_accessor :image, :vec2d

    def initialize(x, y)
        @pos = Point2d.new(x, y)
    end

    def moveBy(vec)
        @pos.moveBy(vec)
        self
    end

    def move
        if @vec2d != nil then
            @pos.moveBy(@vec2d)
        end
    end

    def render
        @image.draw(@pos)
    end
end

imageX = Image.new("xxx.grf")
elem = Element.new(10, 10)
elem.image = imageX

elem.render()

elem.moveBy(Vector2d.new(5, 3))
elem.render
elem.vec2d = Vector2d.new(2, 1)

elem.move
elem.render
elem.move
elem.render
elem.move
elem.render


#sprite.draw(elem.pos)

#sprite.draw(elem.moveBy(Vector2d.new(2, 1)).pos)

#v = Vector2d.new(2, 0)
#v.print

#dturn = Math::PI / 16
#for ang in 0..16 do
#  v.turn(dturn).print
#end

#str = sprintf("aaa:%d\n", 10);
#p str
