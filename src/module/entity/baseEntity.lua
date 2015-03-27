module("baseEntity", package.seeall)

local baseEntity = class("baseEntity")

function baseEntity:init()
	self.entityType = gameConst.entityType.PlayerEntity
	self.Direction = gameConst.EntityDirection.East
	self.ai = false
	self.code = false
	self.pos = false
	self.velocity = false
	self.armature = false
	self.mass = false -- 质量
	self.acceleration = {}
	self.acceleration.x = 0
	self.acceleration.y = 0
	self.xForce = 0 -- X 方向外力
	self.yForce = 0 -- Y 方向
	self.frictionForce = 0 -- 摩擦力
	self.maxVelocity = false
	
	self.interval = false
	local schedule = cc.Director:getInstance():getScheduler()
	self.interval = schedule:scheduleScriptFunc(function () self:update() end, 0.04, false)
end

-- x 轴向右为正， y方向向上为正
function baseEntity:changeForce(xForce, yForce)
	-- 计算摩擦力
	local f = gameConst.friction_factor * self.mass * gameConst.gravity_factor
	local totalForce = 0
	if self.velocity.x == 0 then
		if math.abs(xForce) > f then
			f = f * (xForce>0 and -1 or 1)
			totalForce = xForce + f
			self.acceleration.x = totalForce / self.mass
			self.xForce = xForce
			self.frictionForce = f
		end
	else
		f = f * (self.velocity.x>0 and -1 or 1)
		totalForce = xForce + f
		self.acceleration.x = totalForce / self.mass
		self.xForce = xForce
		self.frictionForce = f
	end
end

function baseEntity:update()
	if self.velocity.x > self.maxVelocity.x then
		self.velocity.x = self.maxVelocity.x
	else
		local tempV = self.velocity.x + self.acceleration.x
		if (tempV>=0 and self.velocity.x<0) or (tempV<=0 and self.velocity.x>0) then
			if self.xForce == 0 and self.frictionForce ~= 0 then
				self.frictionForce = 0
				self.acceleration.x = 0
				self.velocity.x = 0
			end
		else
			self.velocity.x = self.velocity.x + self.acceleration.x
		end
	end
	if self.velocity.y > self.maxVelocity.y then
		self.velocity.y = self.maxVelocity.y
	else
		self.velocity.y = self.velocity.y + self.acceleration.y
	end
	
	self.pos.x = self.pos.x + self.velocity.x
	self.pos.y = self.pos.y + self.velocity.y
	self.armature:setPosition(self.pos.x, self.pos.y)
end

function baseEntity:setDead()
	if self.interval then
		local schedule = cc.Director:getInstance():getScheduler()
		schedule:unscheduleScriptEntry(self.interval)
	end
end

function baseEntity:initEntityInfo(entityCode)
	local entityInfo = entityConfig.getEntityInfoByCode(entityCode)
	self.entityType = entityInfo.type
	self.velocity = {x=entityInfo.velocity[1], y=entityInfo.velocity[2]}
	self.maxVelocity = {x=entityInfo.maxVelocity[1], y=entityInfo.maxVelocity[2]}
	self.mass = entityInfo.mass

	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(ResConfig.png[entityInfo.model], ResConfig.plist[entityInfo.model], ResConfig.xml[entityInfo.model])
	self.armature = ccs.Armature:create(entityInfo.model)
end

function baseEntity:addToScene(scene)
	scene:addChild(self.armature)
	if not self.pos then
		self:setPosition(0,0)
	end
	self.armature:setPosition(cc.p(self.pos.x, self.pos.y))
end

function baseEntity:setPosition(x, y)
	if not self.pos then
		self.pos = {}
	end
	self.pos.x = x
	self.pos.y = y
end

function baseEntity:getPosition()
	return cc.p(self.pos.x, self.pos.y)
end

function baseEntity:play(action)
	if self.armature then
		self.armature:play(action)
	end
end

return baseEntity