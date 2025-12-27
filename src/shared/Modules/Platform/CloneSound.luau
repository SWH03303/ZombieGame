return function(sound, container)
	local soundClone = sound:Clone()
	soundClone.Parent = container
	print(soundClone.SoundId)
	return soundClone
end
