-- Helper file for Record Cranker
-- Contains class files for the main record

local pd <const> = playdate
local gfx <const> = pd.graphics

local recordSpriteImage = gfx.image.new("img/record.png")
class('Record').extends(gfx.sprite)

-- Record init function
-- Parameters: x, y - coordinates to initialize the Record
function Record:init(x, y)
   Record.super.init(self)
   self:setImage(recordSpriteImage)
   self:setScale(1.25)
   self:moveTo(x, y)

   self.velocity = 0
   self.notes = 0
   self.rpms = 0

   self.needles = 0
   self.motors = 0
   self.speakers = 0
   self.djs = 0
end

-- Record update function
-- Return: rotation angle of the record if crank isn't docked, 0 otherwise
function Record:update()
   -- if undocked, use crank change to increase velocity
   if (not pd.isCrankDocked()) then
      local change, acceleratedChange = playdate.getCrankChange()
      self.velocity += math.sqrt(math.abs(acceleratedChange)) / MAX_VELOCITY
   end

   -- reduce velocity, then ensure it's still in bounds
   self.velocity -= 0.05
   self.velocity = clamp(self.velocity, MIN_VELOCITY, MAX_VELOCITY)

   -- new rotation is current rotation + temporary rpms + permanent rpms
   local netChange = self:getRotation() + self.velocity + self.rpms
   self:setRotation(netChange)
   -- print(self.velocity)
end
