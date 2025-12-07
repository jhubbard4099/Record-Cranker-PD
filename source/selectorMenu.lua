-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SelectorMenuContainer').extends(gfx.sprite)

-- main menu variables
local selectorMenu = pd.ui.gridview.new(32, 32)
local selectorMenuSprite = gfx.sprite.new()

-- Constructor
function SelectorMenuContainer:init(x, y)
   selectorMenu:setNumberOfColumns(#selectorMenuOptions + 1)
   selectorMenu:setNumberOfRows(1)
   selectorMenu:setCellPadding(2, 45, 2, 2)

   selectorMenu.backgroundImage = gfx.nineSlice.new("img/gridBox.png", 7, 7, 18, 18)
   selectorMenu:setContentInset(5, 5, 5, 5)

   selectorMenuSprite:setCenter(0, 0)
   selectorMenuSprite:moveTo(x, y)
   selectorMenuSprite:add()

   self.menu = selectorMenu
end

-- Function override for drawing each gridview cell
function selectorMenu:drawCell(section, row, column, selected, x, y, width, height)
   if column == 3 then
      if selected then
         gfx.drawCircleInRect(197, 47, width * 5.2, height * 5.2)
         gfx.setImageDrawMode(gfx.kDrawModeCopy)
      end
   else
      if selected then
         gfx.fillRoundRect(x, y, width*2.5, height, 4)
         gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
      else
         gfx.setImageDrawMode(gfx.kDrawModeCopy)
      end

      local fontHeight = gfx.getSystemFont():getHeight()
      gfx.drawTextInRect(selectorMenuOptions[column], x, y + (height/2 - fontHeight/2) + 2, width*2.5, height, nil, nil, kTextAlignment.center)
   end
end

-- Update function to be run every tick
function SelectorMenuContainer:update()
   gfx.clear()

   -- draw main menu
   if selectorMenu.needsDisplay then
      local selectorMenuImage = gfx.image.new(380, 220)
      gfx.pushContext(selectorMenuImage)
         selectorMenu:drawInRect(0, 0, 380, 220)
      gfx.popContext()
      selectorMenuSprite:setImage(selectorMenuImage)
   end

   gfx.sprite.update()
end
