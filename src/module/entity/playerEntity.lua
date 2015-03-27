module("playerEntity", package.seeall)

local baseEntity = require "module/entity/baseEntity"
local playerEntity = class(baseEntity, "playerEntity")

function playerEntity:init()
	self.isJumpping = false
end

function playerEntity:walk()
	
end

function playerEntity:jump()
	
end

return playerEntity