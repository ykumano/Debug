class Vec2D
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

class Element
    attr_reader :pos

    def initialize(x, y)
        @pos = Point2D.new(x, y)
    end

    def moveBy(vec)
        @pos.moveBy(vec)
        self
    end
end

class Sprite
    def initialize(filename)
        @pos = Point2D.new(0, 0)
    end

    def draw(pos)
        printf("%d %d\n",pos.x, pos.y)
        self
    end
end

elem = Element.new(10, 10)
sprite = Sprite.new("xxx.grf")

sprite.draw(elem.pos)

elem.moveBy(Vec2D.new(5, 3))

sprite.draw(elem.pos)

sprite.draw(elem.moveBy(Vec2D.new(2, 1)).pos)

v = Vec2D.new(2, 0)
v.print

dturn = Math::PI / 16
for ang in 0..16 do
  v.turn(dturn).print
end

str = sprintf("aaa:%d\n", 10);
p str
