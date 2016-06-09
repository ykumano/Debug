#=============================================================================
# GUI�����p�N���X�L�q�t�@�C��(���[�U����J)
#=============================================================================

# �萔��`
#-----------------------------------------------------------------------------
# ��ʃT�C�Y
#
$SCREEN_WIDTH       = 240
$SCREEN_HEIGHT      = 320

# �^�b�`�p�l�������Ԏ���
#
$GNTOUCH_OFF  = 0
$GNTOUCH_ON   = 1
$GNTOUCH_MOVE = 2

# �摜���\�[�XID
#
$YELLOW_BUTTON_ON   = 1
$YELLOW_BUTTON_OFF  = 2
$GREEN_BUTTON_ON    = 16
$GREEN_BUTTON_OFF   = 15
$IMAGE_SKY          = 17
$IMAGE_TREE         = 18

# �N���X��`
#-----------------------------------------------------------------------------

# �\���p���N���X
#
class Element
    # ������
    def initialize(posX=0, posY=0, width=0, height=0)
#        @posX   = posX      # �ʒu(x)
#        @posY   = posY      # �ʒu(y)
        @width  = width     # ��
        @height = height    # ����

        @element = nil
    end

    # �\���ʒu�̕ύX
    def setPosition(posX=0, posY=0)
#        @posX = posX
#        @posY = posY
        gnElement_setPosition(@element, posX, posY)
    end

    def posX
        return gnElement_getX(@element)
    end

    def posY
        return gnElement_getY(@element)
    end

    def posX=(x)
        return gnElement_setX(@element, x)
    end

    def posY=(y)
        return gnElement_setY(@element, y)
    end

    def init()
    end

    def update()
    end

    def render()
    end
end

# �X�N���[��
#
class Screen < Element
    def setPanel(panel)
        if @currentPanel != nil then
            @currentPanel.fin()
        end
        @currentPanel = panel
        @currentPanel.init
    end

    def update()
        GNTouch.update()
        @currentPanel.update()
    end

    def finish()
        $currentPanel.finish()
    end

    def render()
        gnFrameBegin
        @currentPanel.render()
    end
end

# �p�l��
#
class Panel < Element
    # ������
    def init()
        GNTouch.init()

        # �qElement������
        @children.each {|child|
            child.init()
        }
    end

    def finish()
    end

    # �X�V
    def update()
        # �qElement����
        @children.each {|child|
            child.update()
        }
    end

    # �`��
    def render()
        # �qElement�`��
        @children.each {|child|
            child.render()
        }
    end
end

# �^�b�`�p�l������Ǘ��N���X
#
class GNTouch
    def self.init()
        @preTouchState = 0
        @touchState = 0
        @tapCounter = 0

        @onTapHandlerList = []
        @onMoveHandlerList = []
        @onPressHandlerList = []
        @onReleaseHandlerList = []
    end

    def self.state()
        @touchState
    end

    def self.posX()
        @touchPosX
    end

    def self.posY()
        @touchPosY
    end

    # �X�V������
    def self.update()
        @touchState, @touchPosX, @touchPosY = gnGetTouchState()

        if @preTouchState == $GNTOUCH_OFF && @touchState != $GNTOUCH_OFF then
            # Press���n���h���Ăяo��
            @onPressHandlerList.each {|handler|
                handler.call
            }
        end

        if @preTouchState != $GNTOUCH_OFF && @touchState == $GNTOUCH_OFF then
            if @tapCounter < 20 then
                # Tap���n���h���Ăяo��
                @onTapHandlerList.each {|handler|
                    handler.call
                }
            else
                # Release���n���h���Ăяo��
                @onReleaseHandlerList.each {|handler|
                    handler.call
                }
            end
        elsif @touchState == $GNTOUCH_MOVE then
            # Move���n���h���Ăяo��
            @onMoveHandlerList.each {|handler|
                handler.call
            }
        end

        # Tap����p�J�E���^�X�V
        if @touchState != $GNTOUCH_OFF then
            @tapCounter = @tapCounter + 1
        else
            @tapCounter = 0
        end

        @preTouchState = @touchState
    end

    # Tap���n���h���o�^
    def self.setOnTapList(onTapHandlerList)
        @onTapHandlerList = onTapHandlerList
    end

    # Move���n���h���o�^
    def self.setOnMoveList(onMoveHandlerList)
        @onMoveHandlerList = onMoveHandlerList
    end

    # Press���n���h���o�^
    def self.setOnPressList(onPressHandlerList)
        @onPressHandlerList = onPressHandlerList
    end

    # Release���n���h���o�^
    def self.setOnReleaseList(onReleaseHandlerList)
        @onReleaseHandlerList = onReleaseHandlerList
    end
end

$PAD_V_MAX = 80
# ����p�b�h
#-----------------------------------------------------------------------------
class VPad
    attr_accessor :deltaX, :deltaY

    def initialize()
        @preTouchState = 0
        @touchState = 0

        @ownX = 0
        @ownY = 0
        @ownTargetX = @ownX
        @ownTargetY = @ownY
    end

    def setOwnPos(x, y)
        @ownX = x
        @ownY = y
        @ownTargetX = @ownX
        @ownTargetY = @ownY
    end

    def update()
        @touchState, @touchPosX, @touchPosY = gnGetTouchState()

        # Press���m
        if @preTouchState == $GNTOUCH_OFF && @touchState != $GNTOUCH_OFF then
            @touchOriginX = @touchPosX
            @touchOriginY = @touchPosY
            @ownTargetX = @ownX
            @ownTargetY = @ownY
            @ownOriginX = @ownX
            @ownOriginY = @ownY
        end

        # Move���m
        if @touchState == $GNTOUCH_MOVE then
            @ownTargetX = @ownOriginX + (@touchPosX - @touchOriginX)
            @ownTargetY = @ownOriginY + (@touchPosY - @touchOriginY)
        end

        # x�����̈ړ�����
        if (@ownTargetX - @ownX) >= 0 then
            @distX = @ownTargetX - @ownX
            if @distX > $PAD_V_MAX then
                @distX = $PAD_V_MAX
            end
            @deltaX = @distX / 4.0
            @ownX = @ownX + @deltaX
        else
            @distX = @ownX - @ownTargetX
            if @distX > $PAD_V_MAX then
                @distX = $PAD_V_MAX
            end
            @deltaX = -(@distX / 4.0)
            @ownX = @ownX + @deltaX
        end

        # y�����̈ړ�����
        if (@ownTargetY - @ownY) >= 0 then
            @distY = @ownTargetY - @ownY
            if @distY > $PAD_V_MAX then
                @distY = $PAD_V_MAX
            end
            @deltaY = @distY / 4.0
            @ownY = @ownY + @deltaY
        else
            @distY = @ownY - @ownTargetY
            if @distY > $PAD_V_MAX then
                @distY = $PAD_V_MAX
            end
            @deltaY = -(@distY / 4.0)
            @ownY = @ownY + @deltaY
        end

        @preTouchState = @touchState
    end
end

$VPAD_DELTA_MAX = 10
# ����p�b�h
#-----------------------------------------------------------------------------
class VPad2
    attr_accessor :deltaX, :deltaY

    def initialize()
        @preTouchState = 0
        @touchState = 0

        @preTouchPosX = 0
        @preTouchPosY = 0

        @deltaX = 0
        @deltaY = 0
    end

    def update()
        @touchState, @touchPosX, @touchPosY = gnGetTouchState()

        # Move���m
        if @touchState != $GNTOUCH_OFF then
            @deltaX = @deltaX + (@touchPosX - @preTouchPosX)
            if @deltaX > $VPAD_DELTA_MAX then
                @deltaX = $VPAD_DELTA_MAX
            end
            if @deltaX < -$VPAD_DELTA_MAX then
                @deltaX = -$VPAD_DELTA_MAX
            end

            @deltaY = @deltaY + (@touchPosY - @preTouchPosY)
            if @deltaY > $VPAD_DELTA_MAX then
                @deltaY = $VPAD_DELTA_MAX
            end
            if @deltaY < -$VPAD_DELTA_MAX then
                @deltaY = -$VPAD_DELTA_MAX
            end
        else
            @deltaX = 0
            @deltaY = 0
        end

        @preTouchPosX = @touchPosX
        @preTouchPosY = @touchPosY
    end
end

# ����p�b�h
#-----------------------------------------------------------------------------
$RANGE_MAX = 7
class VPad3
    attr_accessor :deltaX, :deltaY, :dir

    def initialize()
        @preTouchState = 0
        @touchState = 0

        @touchOriginX = 0
        @touchOriginY = 0

        @range = 0

        @deltaX = 0
        @deltaY = 0
        @dir = 0
    end

    def update()
        @touchState, @touchPosX, @touchPosY = gnGetTouchState()

        # Press���m
        if @preTouchState == $GNTOUCH_OFF && @touchState != $GNTOUCH_OFF then
            @touchOriginX = @touchPosX
            @touchOriginY = @touchPosY
        end

        # Move���m
        if @touchState != $GNTOUCH_OFF then
            @deltaX = @touchPosX - @touchOriginX
            @deltaY = @touchPosY - @touchOriginY

            @dir = gnMathAtan2(@deltaY, @deltaX)

            @range = gnMathSqrt(@deltaX * @deltaX + @deltaY * @deltaY)

            if(@range > $RANGE_MAX) then
                @deltaX = @deltaX * $RANGE_MAX / @range
                @deltaY = @deltaY * $RANGE_MAX / @range
            end

            @deltaX = @deltaX * 0.2
            @deltaY = @deltaY * 0.2
        else
            @deltaX = 0
            @deltaY = 0
        end

        @preTouchState = @touchState
    end
end
