return function(sound, container)
	local soundClone = sound:Clone()
	soundClone.Parent = container
	--print(soundClone)
	return soundClone
end
