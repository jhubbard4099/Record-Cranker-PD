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
local selectorMenuOptions = {"*Hardware*", "*Upgrades*"}

-- Constructor
function SelectorMenuContainer:init(x, y)
   selectorMenu:setNumberOfColumns(#selectorMenuOptions)
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
   if selected then
      gfx.fillRoundRect(x, y, width*2.5, height, 4)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
   else
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
   end

   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextInRect(selectorMenuOptions[column], x, y + (height/2 - fontHeight/2) + 2, width*2.5, height, nil, nil, kTextAlignment.center)
end

-- Update function to be run every tick
function SelectorMenuContainer:update()
   gfx.clear()

   -- draw main menu
   if selectorMenu.needsDisplay then
      local selectorMenuImage = gfx.image.new(172, 220)
      gfx.pushContext(selectorMenuImage)
         selectorMenu:drawInRect(0, 0, 172, 220)
      gfx.popContext()
      selectorMenuSprite:setImage(selectorMenuImage)
   end

   gfx.sprite.update()
end
