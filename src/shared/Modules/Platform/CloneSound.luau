return function(sound, container)
	local soundClone = sound:Clone()
	soundClone.Parent = container
	return soundClone
end
