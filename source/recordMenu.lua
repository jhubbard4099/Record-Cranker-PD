-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('RecordMenuContainer').extends(gfx.sprite)

-- main menu variables
local recordMenu = pd.ui.gridview.new(0, 32)
local recordMenuSprite = gfx.sprite.new()

-- Constructor
function RecordMenuContainer:init(x, y)
   recordMenu:setNumberOfRows(1)
   recordMenu:setCellPadding(2, 2, 2, 2)

   recordMenuSprite:setCenter(0, 0)
   recordMenuSprite:moveTo(x, y)
   recordMenuSprite:add()

   self.menu = recordMenu
end

-- Function override for drawing each gridview cell
function recordMenu:drawCell(section, row, column, selected, x, y, width, height)
   if selected then
      gfx.fillCircleInRect(x, y, width, height)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
   else
      gfx.drawCircleInRect(x, y, width, height)
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
   end

   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextInRect("", x, y + (height/2 - fontHeight/2) + 2, width, height, nil, nil, kTextAlignment.center)
end

-- Update function to be run every tick
function RecordMenuContainer:update()
   gfx.clear()

   -- draw main menu
   if recordMenu.needsDisplay then
      local recordMenuImage = gfx.image.new(172, 180)
      gfx.pushContext(recordMenuImage)
         recordMenu:drawInRect(0, 0, 172, 180)
      gfx.popContext()
      recordMenuSprite:setImage(recordMenuImage)
   end

   gfx.sprite.update()
end
