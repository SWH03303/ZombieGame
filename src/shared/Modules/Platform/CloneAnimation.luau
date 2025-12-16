return function(id, container, animator)
	local anim = Instance.new("Animation")
	anim.AnimationId = id
	anim.Parent = container
	anim = animator:LoadAnimation(anim)
	return anim
end
