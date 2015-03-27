module("cloud", package.seeall)

local cloud = class("cloud")

function cloud:init(param)
	self.cloudSprite = cc.Sprite:create(param.filePath)
	self.cloudSprite:retain()
	self.cloudSize = self.cloudSprite:getContentSize()
	self.depth = param.depth
	self.velocity = param.velocity
	self.pos = param.pos
	self.Interval = false
end

function cloud:updateFunc()
	self.pos.x = self.pos.x + self.velocity.x*self.depth*0.1
	self.pos.y = self.pos.y + self.velocity.y*self.depth*0.1
	if self.pos.x < -self.cloudSize.width*0.5 or self.pos.x > right().x+self.cloudSize.width*0.5 or
			self.pos.y < -self.cloudSize.height*0.5 or self.pos.y > top().y+self.cloudSize.height*0.5 then
		self:setDead()
	end
	self.cloudSprite:setPosition(cc.p(self.pos.x, self.pos.y))
end

function cloud:setDead()
	if self.Interval then
		local schedule = cc.Director:getInstance():getScheduler()
		schedule:unscheduleScriptEntry(self.Interval)
		self.Interval = false
	end
end

function cloud:run(scene, z)
	scene:addChild(self.cloudSprite, z)
	self.cloudSprite:release()
	self.cloudSprite:setAnchorPoint(0.5, 0.5)
	self.cloudSprite:setPosition(cc.p(self.pos.x, self.pos.y))

	self.cloudSprite:setScale(self.depth*0.1)

	if not self.Interval then
		local schedule = cc.Director:getInstance():getScheduler()
		self.Interval = schedule:scheduleScriptFunc(function ()
			self:updateFunc()
		end, 1.0/__FRAME_RATE__, false)
	end
end

return cloud