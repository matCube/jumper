module("gameConst", package.seeall)

entityType = {}
entityType.PlayerEntity = 1
entityType.MonsterEntity = 2

EntityAIType = {}
EntityAIType.Stand = 1
EntityAIType.Walk = 2
EntityAIType.Jump = 3
EntityAIType.Death = 4

EntityDirection = {}
EntityDirection.East = 1
EntityDirection.West = 2

-- 重力因子
gravity_factor = 10

-- 摩擦系数
friction_factor = 0.01