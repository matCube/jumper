module("main", package.seeall)

package.path = package.path .. ";.\\src\\?.lua;.\\src\\" 

function preInit()
	math.randomseed(os.time())	
	
	require "systemParam"
	require "common/class"
	require "config/resource"
	require "util/VisibleRect"
	require "module/gameConst"
	require "config/configManager"
	
	collectgarbage("collect")
	collectgarbage("setpause", 100)
	collectgarbage("setstepmul", 5000)
	
	local director = cc.Director:getInstance()
	local glView = director:getOpenGLView()
	if nil == glView then
		glView = cc.GLView:createWithRect("jumpper", cc.rect(500,0,1024,640))
		director:setOpenGLView(glView)
	end
	
	director:setDisplayStats(__IS_DEBUG__)
	director:setAnimationInterval(1.0 / __FRAME_RATE__)
	director:getOpenGLView():setDesignResolutionSize(__DESIGN_RESOLUTION_SIZE__.width, __DESIGN_RESOLUTION_SIZE__.height, cc.ResolutionPolicy.FIXED_WIDTH)
	
	cc.FileUtils:getInstance():addSearchPath("src")
	cc.FileUtils:getInstance():addSearchPath("res")
	
	return true
end

function main()
	preInit()

	-- 进入主场景模块
	local CMainSceneModule = require "module/mainScene/mainSceneModule"
	mainSceneModule = CMainSceneModule.new()
	mainSceneModule:runThisModule()
end

function __G__TRACKBACK__(msg)
	if true--[[__IS_DEBUG__--]] then
		local errorMsg = "[LUA ERROR]"..tostring(msg)..debug.traceback()
		print(errorMsg)
	end
end

rawset(_G, "__G__TRACKBACK__", __G__TRACKBACK__)
xpcall(main, __G__TRACKBACK__)