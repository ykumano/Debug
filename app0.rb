
$IMAGE_TITLE = 0
$IMAGE_MIKU = 6
$IMAGE_RUBY = 5
$IMAGE_SQUARE = 8

# �^�C�g���\���X�v���C�g
#-----------------------------------------------------------------------------
class TitleSprite < GNSprite
    def init()
        self.addBlend = 10
        self.scale = 1.0
    end

    def update()
        self.rotZ += 1
        if self.rotZ > 511 then
            self.rotZ = 0
        end
#        self.scale = self.scale + 0.1
#        if self.scale > 2.0 then
#            self.scale = 0.8
#        end
    end

    def test()
#        self.posX = 10
    end
end

# ���@�\���X�v���C�g
#-----------------------------------------------------------------------------
class OwnSprite < GNSprite
    def init()
        @zapperCntr = 0
#        $vpad.setOwnPos(self.posX, self.posY)
        self.rotZ = 384
    end

    def update()
        # �ړ�����
        self.posX += $vpad.deltaX
        self.posY += $vpad.deltaY
        self.rotZ = $vpad.dir

        # ���@�e����
        if GNTouch.state != $GNTOUCH_OFF then
            @zapperCntr += 1
            if @zapperCntr > 3 then
                # ���@�e����
                $panelPlay.zapperList.each {|zapper|
                    if zapper.activeStatus == 0 then
                        zapper.posX = self.posX - 4
                        zapper.posY = self.posY - 1
                        zapper.activeStatus = 1
                        break
                    end
                }
                $panelPlay.zapperList.each {|zapper|
                    if zapper.activeStatus == 0 then
                        zapper.posX = self.posX + 3
                        zapper.posY = self.posY - 1
                        zapper.activeStatus = 1
                        break
                    end
                }
                @zapperCntr = 0

                gnSound_playSE(0)
            end
        end

#        target = $collision.checkCollision(self)
#        if target != nil then
#            target.activeStatus = 0
#            $panelPlay.deleteChild(target)
#        end
    end

    def onPress()
    end

    def onRelease()
    end

    def onMove()
    end
end

# ���@�e�\���X�v���C�g
#-----------------------------------------------------------------------------
class ZapperSprite < GNSprite

    def init()
        self.rotZ = 384
        self.activeStatus = 0
        @fragmentCnt = 0
    end

    # �X�V����
    def update()
        if self.activeStatus == 1 then
            self.posY -= 6
            if self.posY < -16 then
                self.activeStatus = 0
            end

            target = $collision.checkCollision(self)
            if target != nil then
                # �G����
                target.activeStatus = 0
                $panelPlay.enemyNum -= 1

                # self����
                self.activeStatus = 0

                @fragmentCnt = 0
                gnSound_playSE(1)

                # ��������
                $panelPlay.fragmentList.each {|fragment|
                    if fragment.activeStatus == 0 then
                        fragment.posX = self.posX + gnRand(16) - 8
                        fragment.posY = self.posY + gnRand(16) - 8
                        fragment.activeStatus = 1

                        fragment.dx = target.dx * 0.01 + 0.1 * (gnRand(20) - 10)
                        fragment.dy = (target.dy - 5) * 0.01 + 0.1 * (gnRand(20) - 10)
                        fragment.lifetime = 32
                        fragment.scale = 1.5

                        @fragmentCnt += 1
                        if @fragmentCnt > 3 then
                            break
                        end
                    end
                }
            end
#            target = $collision.checkCollision(self)
#            if target != nil then
#                $panelPlay.deleteChild(target)
#            end
        end
    end

    def render()
        if self.activeStatus == 1 then
            super
        end
    end
end

# �G�e�\���X�v���C�g
#-----------------------------------------------------------------------------
class EnemyZapperSprite < GNSprite

    def init()
        self.rotZ = 384
        self.activeStatus = 0

        @zapperCnt = 0
    end

    # �X�V����
    def update()
        if self.activeStatus == 1 then
            self.posY += 2
            if self.posY > 159 then
                self.activeStatus = 0
            end
        end
    end

    def render()
        if self.activeStatus == 1 then
            super
        end
    end
end

# �����X�v���C�g
#-----------------------------------------------------------------------------
class FragmentSprite < GNSprite
    attr_accessor :dx, :dy, :lifetime

    def init()
        self.rotZ = 384
        self.activeStatus = 0
        self.addBlend = 4
        @lifetime = 0
    end

    # �X�V����
    def update()
        if self.activeStatus == 1 then
            self.posX += @dx
            self.posY += @dy

            self.addBlend = @lifetime
            self.scale -= 0.04

            @lifetime -= 1
            if @lifetime == 0 then
                self.activeStatus = 0
            end
        end
    end

    def render()
        if self.activeStatus == 1 then
            super
        end
    end
end

# �G�X�v���C�g
#-----------------------------------------------------------------------------
class EnemyASprite < GNSprite
    attr_accessor :dx, :dy

    def init()
        @dx = 0
        @dy = 2
        self.activeStatus = 0
    end

    # �X�V����
    def update()
        self.rotZ += 10
        if self.rotZ > 511 then
            self.rotZ = 0
        end
        self.posX += @dx
        if self.posX > 119 || self.posX < 0 then
            @dx = -@dx
        end

        # ��ʊO�ɏo�������
        self.posY += @dy
        if self.posY > 159 then
            self.activeStatus = 0
        end

        $collision.updateInfo(self)
    end
end

# �^�C�g����ʃ^�C��
#-----------------------------------------------------------------------------
class TitleTile < GNSprite
    def init()

        # �^�C���ړ����x
        @dy = -(gnRand(2)+1.5)

        self.posX = gnRand(200)+10
        self.posY = gnRand(300)+10
        self.rotX = gnRand(512)
        self.rotY = gnRand(512)
        self.rotZ = gnRand(512)
        self.use3d = 1

        self.addBlend = 14
    end

    # �X�V����
    def update()
        self.rotX += 2
        if self.rotX > 511 then
            self.rotX = 0
        end

        self.rotY += 2
        if self.rotY > 511 then
            self.rotY = 0
        end

        self.rotZ += 1
        if self.rotZ > 511 then
            self.rotZ = 0
        end

        self.posY += @dy
        if self.posY < -30 then
            self.posY = 400
        end
    end
end


# �^�C�g�����
#-----------------------------------------------------------------------------
class PanelTitle < Panel
    # ����
    def initialize()
        @children = []
        @tileList = Array.new(20) do
            TitleTile.new(gnRand(200)+20, gnRand(300)+10, $IMAGE_RUBY)
#            TitleTile.new(gnRand(200)+20, gnRand(300)+10, $IMAGE_MIKU)
#            TitleTile.new(gnRand(200)+20, gnRand(300)+10, $IMAGE_SQUARE)
        end
        @children += @tileList
        @title = TitleSprite.new(120, 140, $IMAGE_TITLE)
#        @title = TitleSprite.new(60, 70, $IMAGE_MIKU)
        @children += [@title]
    end

    def onTap
#$theScreen.setPanel(nil)
        $theScreen.setPanel($panelPlay)
        gnSound_playSE(4)
    end

    def render
        super
        gnDrawLine(10, 10, 50, 20, 0xffffff);
    end

    # ������
    def init()
        super
        GNTouch.setOnTapList( [lambda { onTap }] )
    end
end

$mapdata = [
    "..A.........",
    "..A.........",
    "..A.........",
    "..A.........",
    ".........A..",
    ".........A..",
    ".........A..",
    ".........A..",
    "............",
    "............",
    "............",
    "............",
]

# �v���C�����
#-----------------------------------------------------------------------------
class PanelPlay < Panel
    attr_accessor :zapperList, :fragmentList, :enemyNum, :eZapperList

    # ����
    def initialize()
        @enemyNum = 20

        @children = [ @ownSprite = OwnSprite.new(60, 80, 1) ]

        @zapperList = Array.new(16) do
            ZapperSprite.new(0, 0, 3)
        end
        @children += @zapperList

        @enemyList = Array.new(@enemyNum) do
            EnemyASprite.new(gnRand(70)+20, gnRand(100)+10, 2)
        end
        @children += @enemyList

        @eZapperList = Array.new(16) do
            EnemyZapperSprite.new(0, 0, 7)
        end
        @children += @eZapperList

        @fragmentList = Array.new(64) do
            FragmentSprite.new(0, 0, 4)
        end
        @children += @fragmentList

        $collision = GBCollision.new

        @mapCount = 0
        @mapReadCount = 0
    end

    # �}�b�v�f�[�^�Ǎ���
    def updateMapdata()
        if @mapReadCount == 0 then
            lineData = $mapdata[@mapCount]
            mapx = 0
            lineData.each_byte {|c|
                if c == 65 then
                    createEnemy(mapx, -30)
                end
                mapx += 10
            }

            @mapCount += 1
            if @mapCount >= $mapdata.length then
                @mapCount = 0
            end
        end
        @mapReadCount += 1
        if @mapReadCount > 5 then
            @mapReadCount = 0
        end
    end

    # Enemy����
    def createEnemy(x, y)
        for en in @enemyList do
            if en.activeStatus == 0 then
                en.posX = x
                en.posY = y
                en.activeStatus = 1
                break
            end
        end
    end

    def update()
        super

        # �}�b�v�f�[�^�Ǎ���
        updateMapdata
    end

    # ������
    def init()
        super
#        GNTouch.setOnTapList( [lambda { onTap }] )
        GNTouch.setOnTapList( [] )
        GNTouch.setOnMoveList( [lambda { @ownSprite.onMove }] )
        GNTouch.setOnPressList( [lambda { @ownSprite.onPress }] )
        GNTouch.setOnReleaseList( [lambda { @ownSprite.onRelease }] )
    end

    def deleteChild(element)
        @children.delete(element)
    end

end

# ���C��������
#-----------------------------------------------------------------------------
def initApp()
    # �^�b�`�p�l������������
    GNTouch.init()

    # ����p�b�h����
    $vpad = VPad3.new()

    # Screen����
    $theScreen = Screen.new(0, 0, $SCREEN_WIDTH, $SCREEN_HEIGHT)

    # �^�C�g����ʍ쐬
    $panelTitle = PanelTitle.new()

    # �^�C�g����ʕ\��
    $theScreen.setPanel($panelTitle)

    $panelPlay = PanelPlay.new()
    gnDebugLog("initApp")
end

# ���C�����[�v
#-----------------------------------------------------------------------------
def mainLoop()
    $vpad.update()
    $theScreen.update()
    $theScreen.render()
end
