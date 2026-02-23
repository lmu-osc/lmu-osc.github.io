-- event-setup.lua

local function get_param(meta, param_name, default)
  if meta[param_name] == nil then
    return default
  else
    return meta[param_name]
  end
end

local function safe_get(tbl, key, default)
  if type(tbl) == "table" and tbl[key] ~= nil then
    return tbl[key]
  else
    return default
  end
end

local function safe_trim(val)
  if type(val) == "string" then
    return val:match("^%s*(.-)%s*$")
  else
    return ""
  end
end

function Meta(meta)
  local event = meta["event"] or {}

  local event_end_date = safe_get(event, "end_date", "")
  local has_end_date = false
  if type(event_end_date) == "string" then
    has_end_date = event_end_date:match("%S") ~= nil
  elseif type(event_end_date) == "table" then
    -- If end_date is a table (e.g., list of dates), check if any entry is non-empty
    for _, v in ipairs(event_end_date) do
      if type(v) == "string" and v:match("%S") then
        has_end_date = true
        break
      end
    end
  end

  -- Recursively convert Lua values to Pandoc Meta types
  local function to_meta(val)
    if type(val) == "string" then
      return pandoc.MetaString(val)
    elseif type(val) == "table" then
      -- Check if it's a list (array-like)
      local is_array = true
      local count = 0
      for k, v in pairs(val) do
        count = count + 1
        if type(k) ~= "number" then is_array = false break end
      end
      if is_array then
        local meta_list = {}
        for i = 1, #val do
          meta_list[i] = to_meta(val[i])
        end
        return pandoc.MetaList(meta_list)
      else
        local meta_map = {}
        for k, v in pairs(val) do
          meta_map[k] = to_meta(v)
        end
        return pandoc.MetaMap(meta_map)
      end
    else
      return val
    end
  end

  local event_data = {
    event = to_meta(event),
    event_title = get_param(meta, "title", ""),
    has_end_date = has_end_date,
    event_description = get_param(meta, "event_description", {}),
    instructors = get_param(meta, "instructors", {}),
    helpers = get_param(meta, "helpers", {}),
    contact = get_param(meta, "contact", {}),
    contact_name = safe_trim(safe_get(get_param(meta, "contact", {}), "name", "")),
    contact_email = safe_trim(safe_get(get_param(meta, "contact", {}), "email", ""))
  }

  meta.event_data = event_data
  return meta
end