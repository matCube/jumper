__visibleRect = cc.rect(0,0,0,0)

function lazyInit()
	if __visibleRect.width == 0.0 and __visibleRect.width == 0.0 then
		__visibleRect.x = 0
		__visibleRect.y = 0
		local size = cc.Director:getInstance():getWinSize()
		__visibleRect.width = size.width
		__visibleRect.height = size.height
	end
end

function getVisibleRect()
	lazyInit()
	return cc.rect(__visibleRect.x, __visibleRect.y, __visibleRect.width, __visibleRect.height)
end

function left()
	lazyInit()
	return cc.p(__visibleRect.x, __visibleRect.y+__visibleRect.height*0.5)
end

function right()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width, __visibleRect.y+__visibleRect.height*0.5)
end

function top()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width*0.5, __visibleRect.y+__visibleRect.height)
end

function bottom()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width*0.5, __visibleRect.y)
end

function center()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width*0.5, __visibleRect.y+__visibleRect.height*0.5)
end

function leftTop()
    lazyInit()
    return cc.p(__visibleRect.x, __visibleRect.y+__visibleRect.height)
end

function rightTop()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width, __visibleRect.y+__visibleRect.height)
end

function leftBottom()
    lazyInit()
    return cc.p(__visibleRect.x,__visibleRect.y)
end

function rightBottom()
    lazyInit()
    return cc.p(__visibleRect.x+__visibleRect.width, __visibleRect.y)
end