--[[
so story behind this 
i tried foolishly to send a request to github but roblox's httpservice:jsonencode is absolute trash so i had to make my own 
feel free to use this for any project if u dont wnna use roblox's absolute trash functions
]]

local JsonEncoder = {}

local function escape_str(s)
	s = s:gsub("\\", "\\\\")
	s = s:gsub("\"", "\\\"")
	s = s:gsub("\b", "\\b")
	s = s:gsub("\f", "\\f")
	s = s:gsub("\n", "\\n")
	s = s:gsub("\r", "\\r")
	s = s:gsub("\t", "\\t")
	return s
end

local function is_array(t)
	local max = 0
	local count = 0
	for k, _ in pairs(t) do
		if type(k) ~= "number" then return false end
		if k > max then max = k end
		count = count + 1
	end
	return max == count
end


function JsonEncoder.encode(value)
	local vtype = type(value)

	if vtype == "string" then
		return "\"" .. escape_str(value) .. "\""

	elseif vtype == "number" or vtype == "boolean" then
		return tostring(value)

	elseif vtype == "nil" then
		return "null"

	elseif vtype == "table" then
		local result = {}

		if is_array(value) then
			for _, v in ipairs(value) do
				table.insert(result, JsonEncoder.encode(v))
			end
			return "[" .. table.concat(result, ",") .. "]"
		else
			for k, v in pairs(value) do
				if type(k) ~= "string" then
					error("JSON object keys must be strings, got: " .. type(k))
				end
				table.insert(result, "\"" .. escape_str(k) .. "\":" .. JsonEncoder.encode(v))
			end
			return "{" .. table.concat(result, ",") .. "}"
		end
	else
		error("Unsupported type in JSON: " .. vtype)
	end
end

return JsonEncoder
