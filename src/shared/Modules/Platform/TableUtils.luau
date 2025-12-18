local function checkTable(array, module)
	for i, v in pairs(array) do
		if v == module then
			return true
		end
	end
	return false
end
