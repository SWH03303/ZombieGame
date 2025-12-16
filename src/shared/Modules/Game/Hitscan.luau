local Hitscan = {}

function Hitscan:CreateRay(rayOrigin, rayDirection, filter)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = filter
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

	if raycastResult == nil then
		raycastResult = { Position = rayDirection + rayOrigin }
	end

	return raycastResult
end

return Hitscan
