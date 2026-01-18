local rs = game:GetService("ReplicatedStorage")
local packages = rs:WaitForChild("Packages")
local Hitbox = require(packages:WaitForChild("Hitbox"))

function explosion()
	local hitbox = Hitbox.new({
		InitialCframe = workspace.HitboxTest.CFrame,
		SizeOrPart = Vector3.new(10, 10, 10),
		Debug = true,
	})

	hitbox.OnHit:Connect(function(hitCharacters)
		for _, character in ipairs(hitCharacters) do
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			humanoid:TakeDamage(10)
		end
	end)

	hitbox:Start()
	print("start")

	task.delay(5, function()
		hitbox:Destroy()
		print("end")
	end)
end

return explosion
