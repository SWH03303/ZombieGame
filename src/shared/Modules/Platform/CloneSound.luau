return function(sound, container)
	if container:FindFirstChild(sound.Name) then
		return container:FindFirstChild(sound.Name)
	end
	local soundClone = sound:Clone()
	soundClone.Parent = container
	return soundClone
end
