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
  if type(event_end_date) == "string" and event_end_date:match("%S") then
    has_end_date = true
  end

  local event_data = {
    event_param = event,
    event_title = get_param(meta, "title", ""),
    event_start_date = safe_trim(safe_get(event, "start_date", "")),
    event_end_date = safe_trim(event_end_date),
    event_time = safe_trim(safe_get(event, "time", "")),
    event_location_name = safe_trim(safe_get(safe_get(event, "location", {}), "name", "")),
    event_location_address = safe_trim(safe_get(safe_get(event, "location", {}), "address", "")),
    event_map_url = safe_trim(safe_get(safe_get(event, "location", {}), "map_url", "")),
    event_format_type = safe_trim(safe_get(safe_get(event, "format", {}), "type", "")),
    event_format_detail = safe_trim(safe_get(safe_get(event, "format", {}), "detail", "")),
    event_language_primary = safe_trim(safe_get(safe_get(event, "language", {}), "primary", "")),
    event_language_detail = safe_trim(safe_get(safe_get(event, "language", {}), "detail", "")),
    has_end_date = has_end_date,
    links_param = get_param(meta, "links", {}),
    links_registration = safe_trim(safe_get(get_param(meta, "links", {}), "registration", "")),
    links_materials = safe_trim(safe_get(get_param(meta, "links", {}), "materials", "")),
    links_workshop_website = safe_trim(safe_get(get_param(meta, "links", {}), "workshop_website", "")),
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