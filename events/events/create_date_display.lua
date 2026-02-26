-- testing_event_data.lua

local month_abbr = {
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
}

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

local function parse_iso_date(date_str)
  local y, m, d = date_str:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)$")
  if y == nil then
    return nil
  end

  y = tonumber(y)
  m = tonumber(m)
  d = tonumber(d)

  if not y or not m or not d or m < 1 or m > 12 or d < 1 or d > 31 then
    return nil
  end

  return { year = y, month = m, day = d }
end

local function format_date(parsed, include_year)
  if include_year then
    return string.format("%02d %s %d", parsed.day, month_abbr[parsed.month], parsed.year)
  end
  return string.format("%02d %s", parsed.day, month_abbr[parsed.month])
end

local function build_date_display(start_date, end_date)
  local start_text = trim(start_date)
  local end_text = trim(end_date)

  if start_text == "" then
    return ""
  end

  if end_text == "" then
    local parsed = parse_iso_date(start_text)
    if parsed then
      return format_date(parsed, true)
    end
    return start_text
  end

  local start_parsed = parse_iso_date(start_text)
  local end_parsed = parse_iso_date(end_text)

  if not start_parsed or not end_parsed then
    return start_text .. " - " .. end_text
  end

  if start_parsed.year == end_parsed.year then
    return format_date(start_parsed, false) .. " - " .. format_date(end_parsed, true)
  end

  return format_date(start_parsed, true) .. " - " .. format_date(end_parsed, true)
end

local function normalize_external_url(value)
  local url = trim(value)
  if url == "" then
    return ""
  end

  if url:match("^[A-Za-z][A-Za-z0-9+.-]*://")
    or url:match("^mailto:")
    or url:match("^tel:") then
    return url
  end

  return "https://" .. url
end

local function is_blank(value)
  return trim(value) == ""
end

local function filter_people_list(people_list)
  if not people_list or type(people_list) ~= "table" then
    return false
  end

  local filtered = pandoc.List({})
  for _, person in ipairs(people_list) do
    if type(person) == "table" then
      local name = safe_get(person, "name", "")
      local url = safe_get(person, "url", "")
      if not (is_blank(name) and is_blank(url)) then
        table.insert(filtered, person)
      end
    end
  end

  if #filtered == 0 then
    return false
  end

  return filtered
end

local function build_event_data(meta)
  local event = safe_get(meta, "event", {})
  local links = safe_get(meta, "links", nil)

  local start_date = trim(safe_get(event, "start_date", ""))
  local end_date = trim(safe_get(event, "end_date", ""))
  local date_display = build_date_display(start_date, end_date)

  local links_registration = normalize_external_url(safe_get(links, "registration", ""))
  local links_materials = normalize_external_url(safe_get(links, "materials", ""))
  local links_workshop_website = normalize_external_url(safe_get(links, "workshop_website", ""))

  local event_data = {
    date_display = date_display,
    links = {
      registration = links_registration,
      materials = links_materials,
      workshop_website = links_workshop_website
    }
  }

  return event_data
end
function Meta(meta)
  meta.event_data = build_event_data(meta)

  meta.presenters = filter_people_list(safe_get(meta, "presenters", nil))
  meta.instructors = filter_people_list(safe_get(meta, "instructors", nil))
  meta.helpers = filter_people_list(safe_get(meta, "helpers", nil))
  meta.organizers = filter_people_list(safe_get(meta, "organizers", nil))
  meta.host = filter_people_list(safe_get(meta, "host", nil))

  return meta
end


