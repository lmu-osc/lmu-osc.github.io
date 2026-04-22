local function stringify(val)
	if val == nil then
		return ""
	end
	return pandoc.utils.stringify(val)
end

local function trim(val)
	local s = stringify(val)
	return s:match("^%s*(.-)%s*$")
end

local function safe_get(tbl, key, default)
	if type(tbl) == "table" and tbl[key] ~= nil then
		return tbl[key]
	end
	return default
end

local function build_flyer_data(meta)
	local flyer = safe_get(meta, "flyer", nil)

	if flyer == nil then
		return nil
	end

	local file = ""
	local title = ""

	if type(flyer) == "table" then
		local flyer_entry = flyer

		-- Allow list syntax, using the first flyer entry.
		if flyer_entry[1] ~= nil then
			flyer_entry = flyer_entry[1]
		end

		if type(flyer_entry) == "table" then
			file = trim(safe_get(flyer_entry, "file", ""))
			title = trim(safe_get(flyer_entry, "title", ""))
		end

		-- Backward compatibility: flyer: <path>
		if file == "" then
			file = trim(flyer)
		end
	else
		file = trim(flyer)
	end

	if file == "" then
		return nil
	end

	return {
		src = file,
		label = title
	}
end

function Meta(meta)
	local flyer_data = build_flyer_data(meta)
	if flyer_data then
		meta.flyer_data = flyer_data
	end

	return meta
end
