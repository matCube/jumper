module("entityConfig", package.seeall)

local entityMap = false

function lazyInit()
	if not entityMap then
		entityMap = {}
		local datas = require "config/CN/t_entity"
		for _,v in ipairs(datas) do
			entityMap[v.code] = v
		end
	end
end

function getEntityInfoByCode(code)
	lazyInit()
	return entityMap[code]
end