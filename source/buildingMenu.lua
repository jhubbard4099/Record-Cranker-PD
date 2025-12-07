-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BuildingMenuContainer').extends(gfx.sprite)

-- main menu variables
local buildingMenu = pd.ui.gridview.new(0, 32)
local buildingMenuSprite = gfx.sprite.new()
local buildingMenuOptions = {"Needle", "Motor", "Speaker", "Auto DJ"}

-- Constructor
function BuildingMenuContainer:init(x, y)
   buildingMenu:setNumberOfRows(#buildingMenuOptions)
   buildingMenu:setCellPadding(2, 2, 2, 2)

   buildingMenu.backgroundImage = gfx.nineSlice.new("img/gridBox.png", 7, 7, 18, 18)
   buildingMenu:setContentInset(5, 5, 5, 5)

   buildingMenuSprite:setCenter(0, 0)
   buildingMenuSprite:moveTo(x, y)
   buildingMenuSprite:add()

   self.menu = buildingMenu
end

-- Function override for drawing each gridview cell
function buildingMenu:drawCell(section, row, column, selected, x, y, width, height)
   if selected then
      gfx.fillRoundRect(x, y, width, height, 4)
      gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
   else
      gfx.setImageDrawMode(gfx.kDrawModeCopy)
   end

   local fontHeight = gfx.getSystemFont():getHeight()
   gfx.drawTextInRect(buildingMenuOptions[row], x, y + (height/2 - fontHeight/2) + 2, width, height, nil, nil, kTextAlignment.center)
end

-- Update function to be run every tick
function BuildingMenuContainer:update()
   gfx.clear()

   -- draw main menu
   if buildingMenu.needsDisplay then
      local buildingMenuImage = gfx.image.new(172, 180)
      gfx.pushContext(buildingMenuImage)
         buildingMenu:drawInRect(0, 0, 172, 180)
      gfx.popContext()
      buildingMenuSprite:setImage(buildingMenuImage)
   end

   gfx.sprite.update()
end
