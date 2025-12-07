-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

import "selectorMenu"
import "buildingMenu"
import "upgradeMenu"
import "recordMenu"
import "record"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MainMenuScene').extends(gfx.sprite)
local musicTrack = pd.sound.fileplayer.new("sfx/track_polka")

-- All menu options
selectorMenuOptions = {"*Hardware*", "*Upgrades*"}
buildingMenuOptions = {"Needle", "Motor", "Speaker", "Auto DJ"}
upgradeMenuOptions = {"Titanium Crank", "Ruby-Tipped Needles", "Faster Motors", "Deeper Bass", "Better Wages"}

-- main menu variables
local selectorMenu = SelectorMenuContainer(10, 10)
local buildingMenu = BuildingMenuContainer(10, 50)
local upgradeMenu = UpgradeMenuContainer(10, 50)

local record = Record(290, 140)
-- local recordMenu = RecordMenuContainer(290, 140)

local currentMenu

-- Constructor
function MainMenuScene:init()
   record:add()
   -- recordMenu:add()
   selectorMenu:add()

   musicTrack:setRate(0)
   musicTrack:play()

   self:add()
end

function MainMenuScene:purchaseItem()
   local section, row, column = currentMenu.menu:getSelection()
   if currentMenu == buildingMenu then
      currentMenuOption = buildingMenuOptions[row]
      if currentMenuOption == buildingMenuOptions[1] and record.notes >= buildingMenu.needlePrice then
         record.notes -= buildingMenu.needlePrice
         record.needles += 1
         buildingMenu.needlePrice += buildingMenu.needlePrice * 1.1
      elseif currentMenuOption == buildingMenuOptions[2] and record.notes >= buildingMenu.motorPrice then
         record.notes -= buildingMenu.motorPrice
         record.motors += 1
         buildingMenu.motorPrice += buildingMenu.motorPrice * 1.1
      elseif currentMenuOption == buildingMenuOptions[3] and record.notes >= buildingMenu.speakerPrice then
         record.notes -= buildingMenu.speakerPrice
         record.speakers += 1
         buildingMenu.speakerPrice += buildingMenu.speakerPrice * 1.1
      elseif currentMenuOption == buildingMenuOptions[4] and record.notes >= buildingMenu.djPrice then
         record.notes -= buildingMenu.djPrice
         record.djs += 1
         buildingMenu.djPrice += buildingMenu.djPrice * 1.1
      else
         -- do nothing
      end
   elseif currentMenu == upgradeMenu then

   else
      -- do nothing
   end
   print( record.needles .. " " .. record.motors .. " " .. record.speakers .. " " .. record.djs)
end

function MainMenuScene:processMusic()
   local playbackRate = record.velocity / MAX_VELOCITY
   musicTrack:setRate(playbackRate)
end

-- Handle all button inputs
function MainMenuScene:processButtons()
   -- handle menu navigation
   if pd.buttonJustPressed("left") then
      selectorMenu.menu:selectPreviousColumn(true)
   elseif pd.buttonJustPressed("right") then
      selectorMenu.menu:selectNextColumn(true)
   end

   if currentMenu ~= nil then
      if pd.buttonJustPressed("up") then
         currentMenu.menu:selectPreviousRow(true)
      elseif pd.buttonJustPressed("down") then
         currentMenu.menu:selectNextRow(true)
      end
   end

   -- handle A/B buttons
   if (pd.buttonJustPressed("A")) then
      local section, row, column = selectorMenu.menu:getSelection()
      if column == 3 then
         record.notes += math.sqrt(math.sqrt(record.velocity))
         print(record.notes)
      else
         self:purchaseItem()
      end
   end
end

-- TODO: Figure out why the menus overlap
function MainMenuScene:drawSubmenus()
   local section, row, column = selectorMenu.menu:getSelection()
   -- print(currentSelector)
   -- printTable(gfx.sprite.getAllSprites())
   if column == 1 then
      currentMenu = buildingMenu
      upgradeMenu:remove()
      buildingMenu:add()
   elseif column == 2 then
      currentMenu = upgradeMenu
      buildingMenu:remove()
      upgradeMenu:add()
   else
      currentMenu = nil
      buildingMenu:remove()
      upgradeMenu:remove()
   end

   gfx.setColor(gfx.kColorBlack)
   gfx.fillRect(380, 0, 50, 50)
   gfx.setColor(gfx.kColorWhite)
   gfx.drawRect(380, 20, 50, 50)

   gfx.drawText("Notes:", 380, 10)
   gfx.drawText(record.notes, 380, 10)

   gfx.drawText("RPMs:", 380, 30)
   gfx.drawText(record.rpms, 380, 30)

   gfx.setColor(gfx.kColorWhite)
   gfx.setColor(gfx.kColorBlack)
end

-- Update function to be run every tick
function MainMenuScene:update()
   gfx.clear()
   self:drawSubmenus()
   self:processButtons()
   self:processMusic()
   gfx.sprite.update()
end
