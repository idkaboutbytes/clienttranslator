--!strict
--[=[
	@class RoundingBehaviourTypes
]=]

const Enums = require("../../roblox_packages/Enums")

export type RoundingBehaviourType = "roundToClosest" | "truncate" | "None"

return Enums.new({
	ROUND_TO_CLOSEST = "roundToClosest" :: "roundToClosest",
	TRUNCATE = "truncate" :: "truncate",
	NONE = "none" :: "none",
})
