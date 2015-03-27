module("fightMapModule", package.seeall)

local fightMapModule = class("fightMapModule")

function fightMapModule:init()
	self.layer = false
	self.mapLayer = false
	self.backGroundLayer = false
	self.cloud = false
	self.leftBtn = false
	self.rightBtn = false
	self.jumoBtn = false
	self:createUI()
end

function fightMapModule:createImgButton(param)
	local button = ccui.Button:create()
	button:loadTextures(param.normalImg, param.selectImg)
	button:setPosition(param.x, param.y)
	button:setScale(param.scale)
	button:setTouchEnabled(true)
	return button
end

function fightMapModule:createUI()
	self.layer = cc.Layer:create()
	self.layer:retain()
	
	self.backGroundLayer = cc.Sprite:create(ResConfig.jpg.backGround)
	self.layer:addChild(self.backGroundLayer, -1)
	self.backGroundLayer:setAnchorPoint(cc.p(0.5, 0.5))
	self.backGroundLayer:setPosition(center())
	self.mapLayer = cc.TMXTiledMap:create(ResConfig.tmx.guanka1)
	self.layer:addChild(self.mapLayer, 1)
	self.mapLayer:setAnchorPoint(cc.p(0.5,0.5))
	self.mapLayer:setPosition(center())

	-- 创建三个交互按钮
	self.leftBtn = self:createImgButton({x=300,y=64,normalImg=ResConfig.png.left1,selectImg=ResConfig.png.left2, scale=0.8})
	self.rightBtn = self:createImgButton({x=364,y=64,normalImg=ResConfig.png.gotoNext1,selectImg=ResConfig.png.gotoNext2, scale=0.8})
	self.jumoBtn = self:createImgButton({x=600,y=64,normalImg=ResConfig.png.jump1,selectImg=ResConfig.png.jump2, scale=0.8})
	self.leftBtn:addTouchEventListener(function (sender, eventType)
		self:onMoveLeft(sender, eventType)
	end)
	self.rightBtn:addTouchEventListener(function (sender, eventType)
		self:onMoveRight(sender, eventType)
	end)
	self.jumoBtn:addTouchEventListener(function (sender, eventType)
		self:onJump(sender, eventType)
	end)

	self.layer:addChild(self.leftBtn)
	self.layer:addChild(self.rightBtn)
	self.layer:addChild(self.jumoBtn)
	
	-- test
	local CCloud = require "module/fightMap/elements/cloud"
	local param1 = {filePath=ResConfig.png.cloud, pos={x=100, y=600}, depth=4, velocity={x=0.2, y=0}}
	self.cloud1 = CCloud.new(param1)
	
	local param2 = {filePath=ResConfig.png.cloud, pos={x=100, y=400}, depth=6, velocity={x=0.1, y=0}}
	self.cloud2 = CCloud.new(param2)
	
	local param3 = {filePath=ResConfig.png.cloud, pos={x=100, y=200}, depth=10, velocity={x=0.1, y=0}}
	self.cloud3 = CCloud.new(param3)
	
	local CPlayer = require "module/entity/playerEntity"
	self.player = CPlayer:new()
	self.player:initEntityInfo(1000)
	self.player:addToScene(self.layer)
	---------------------------------------------------
end

function fightMapModule:runThisModule()
	local scene = cc.Scene:create()
	scene:addChild(self.layer, 1)
	self.layer:release()
	self.cloud1:run(self.layer, 0)
	self.cloud2:run(self.layer, 0)
	self.cloud3:run(self.layer, 0)
	cc.Director:getInstance():replaceScene(scene)
end

function fightMapModule:onMoveLeft(sender, eventType)
	if eventType == ccui.TouchEventType.began then
		self.player:changeForce(-8)
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		self.player:changeForce(0)
	end
end

function fightMapModule:onMoveRight(sender, eventType)
	if eventType == ccui.TouchEventType.began then
		self.player:changeForce(8)
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		self.player:changeForce(0)
	end
end

function fightMapModule:onJump(sender, eventType)
	if eventType == ccui.TouchEventType.began then
		
	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		
	end
end

return fightMapModule