module("mainSceneModule", package.seeall)

local mainSceneModule = class("mainSceneModule")

function mainSceneModule:init()
	self.layer = false
	self.gotoBtn = false -- 添加一个测试按钮
	
	self:createUI()
end

function mainSceneModule:gotoNextModule()
	local CFightMapModule = require "module/fightMap/fightMapModule"
	local fightMapModule = CFightMapModule:new()
	fightMapModule:runThisModule()
end

function mainSceneModule:createUI()
	self.layer = cc.Layer:create()
	self.layer:retain()
	self.gotoBtn = cc.MenuItemImage:create(ResConfig.png.gotoNext1, ResConfig.png.gotoNext1)
	self.gotoBtn:registerScriptTapHandler(self.gotoNextModule)
	self.gotoBtn:setPosition(center())
	local menu = cc.Menu:create()
	menu:setPosition(0,0)
	menu:addChild(self.gotoBtn)
	self.layer:addChild(menu)
end

function mainSceneModule:runThisModule()
	local scene = cc.Scene:create()
	scene:addChild(self.layer)
	self.layer:release()
	cc.Director:getInstance():runWithScene(scene)
end

return mainSceneModule