--******************************************************--
-- @Desc: lua 类定义
-- @Author: xf
-- @Date: 2015/3/23
--******************************************************--

-- 数据深拷贝
-- @param srcData 
-- @return 复制数据
function deepCopy(srcData)
	local srcDataType = type(srcData)
	local deepCopyData
	if srcDataType == "table" then
		deepCopyData = {}
		for k,v in pairs(srcData) do
			deepCopyData[deepCopy(k)] = deepCopy(v)
		end
		setmetatable(deepCopyData, deepCopy(getmetatable(srcData)))
	else
		deepCopyData = srcData
	end
	return deepCopyData
end

-- 为class 添加数据时，检查其父类是否已经存在该方法，如果存在
-- 则创建相应的处理标记
-- @param tb: class.vtbl
-- @param k,v: 新数据
-- @param classData: class
function shiftToSuper(tb, k, v, classData)
	local tbv = rawget(tb, k)
	if tbv then
		local super = classData.super
		while super do
			if super.selfFun[k] then
				if not tb.Super then
					tb.Super = {}
				end
				if not tb.Super[super.className] then
					tb.Super[super.className] = {}
				end
				tb.Super[super.className][k] = super.selfFun[k]
			end 
			super = super.super
		end
	end
	rawset(tb,k,v)
    return
end

-- 构造类
-- @param super: 继承的父类（如果没有父类，那么该参数为类名）  
-- @param className: 类名
-- @param defaultArgs: 专属类的一些默认参数
-- @return : 返回构造好的类
function class(super, className, defaultArgs)
	local classData = {} -- 需要进行构造的类
	classData.init = false
	classData.className = className
	if "string" == type(super) then
		classData.className = super
	else
		classData.super = super
	end
	classData.defaultArgs = defaultArgs or {}
	classData.vtbl = {} -- 处理当前类和父类的方法映射、多态等信息
	classData.selfFun = {} -- 该类的函数表

	-- 创建对象
	classData.new = function(argTableInit)
			local obj={}
			local mt = { __index=classData.vtbl }
			setmetatable(obj,mt)
			local argTable = {}
			for k,v in pairs(classData.defaultArgs) do
				argTable[k] = v
			end
			if argTableInit then
				for k,n in pairs(argTableInit) do
					argTable[k] = n
				end
			end
			obj.__className = classData.className
			
			do
				local create
				create = function(c)
					if c.super then
						create(c.super)
					end
					if c.init then
						c.init(obj,argTable)
					end
				end
				create(classData)
			end
			
			mt.__newindex = function (t,k)
				error("attempt to newindex a not exist value:"..k.."\n")
			end
			return obj
		end

	local vtbl = classData.vtbl

	function vtbl:clone()
		return deepCopy(self)
	end

	function vtbl:super(className, method, ...)
		return self.Super[className][method](self, ...)
	end

	-- 将父类的虚表信息拷贝到本地
	if classData.super then
		for k,v in pairs(classData.super.vtbl) do
			if k == "Super" then
				vtbl[k] = deepCopy(v)
			else
				vtbl[k] = v
			end
		end
	end

	setmetatable(classData, {__newindex=function (t,k,v)
		if "init" == k then
			classData.init = v
		else
			shiftToSuper(vtbl, k, v, classData)
			classData.selfFun[k] = v
		end
	end})

	return classData
end