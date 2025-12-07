-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('UpgradeMenuContainer').extends(gfx.sprite)

-- main menu variables
local upgradeMenu = pd.ui.gridview.new(0, 32)
local upgradeMenuSprite = gfx.sprite.new()

-- Constructor
function UpgradeMenuContainer:init(x, y)
   upgradeMenu:setNumberOfRows(#upgradeMenuOptions)
   upgradeMenu:setCellPadding(2, 2, 2, 2)

   upgradeMenu.backgroundImage = gfx.nineSlice.new("img/gridBox.png", 7, 7, 18, 18)
   upgradeMenu:setContentInset(5, 5, 5, 5)

   upgradeMenuSprite:setCenter(0, 0)
   upgradeMenuSprite:moveTo(x, y)
   upgradeMenuSprite:add()

   self.menu = upgradeMenu
end

-- Function override for drawing each gridview cell
function upgradeMenu:drawCell(section, row, column, selected, x, y, width, height)
   if selected then
      gfx.fillRoundRect(x, y, width, height, 4)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
   else
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
   end

   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextInRect(upgradeMenuOptions[row], x, y + (height/2 - fontHeight/2) + 2, width, height, nil, nil, kTextAlignment.center)
end

-- Update function to be run every tick
function UpgradeMenuContainer:update()
   gfx.clear()

   -- draw main menu
   if upgradeMenu.needsDisplay then
      local upgradeMenuImage = gfx.image.new(172, 180)
      gfx.pushContext(upgradeMenuImage)
         upgradeMenu:drawInRect(0, 0, 172, 180)
      gfx.popContext()
      upgradeMenuSprite:setImage(upgradeMenuImage)
   end

   gfx.sprite.update()
end
