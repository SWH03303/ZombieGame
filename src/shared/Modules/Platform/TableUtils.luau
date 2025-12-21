local utils = {}

function utils.checkTable(array, module)
	for i, v in pairs(array) do
		if v == module then
			return true
		end
	end
	return false
end

function utils.addIn(t1, t2)
	if t2 == nil then
		return t1
	end

	for _, value in pairs(t2) do
		table.insert(t1, value)
	end
	return t1
end

return utils
