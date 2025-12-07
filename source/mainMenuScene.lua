-- Helper file for Record Cranker
-- Contains scene logic for the main gameplay menu

import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/nineslice"

import "selectorMenu"
import "buildingMenu"
import "upgradeMenu"
import "record"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MainMenuScene').extends(gfx.sprite)
local musicTrack = pd.sound.fileplayer.new("sfx/track_polka")

-- main menu variables
local selectorMenu = SelectorMenuContainer(10, 10)
local buildingMenu = BuildingMenuContainer(10, 50)
local upgradeMenu = UpgradeMenuContainer(10, 50)
local record = Record(290, 140)

local currentMenu

-- Constructor
function MainMenuScene:init()
   record:add()
   selectorMenu:add()

   musicTrack:setRate(0)
   musicTrack:play()

   self:add()
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
   if (pd.buttonJustPressed("B")) then
      -- SCENE_MANAGER:switchScene(GameScene, "fade")
   end
end

function MainMenuScene:drawSubmenus()
   local section, row, column = selectorMenu.menu:getSelection()
   print(currentSelector)
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
end

-- Update function to be run every tick
function MainMenuScene:update()
   gfx.clear()
   self:drawSubmenus()
   self:processButtons()
   self:processMusic()
   gfx.sprite.update()
end
