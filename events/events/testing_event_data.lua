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

local function has_text(val)
  return trim(val) ~= ""
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


local function build_event_data(meta)
  local event = safe_get(meta, "event", {})
  local location = safe_get(event, "location", {})
  local format = safe_get(event, "format", {})
  local language = safe_get(event, "language", {})

  local start_date = trim(safe_get(event, "start_date", ""))
  local end_date = trim(safe_get(event, "end_date", ""))
  local time = trim(safe_get(event, "time", ""))

  local location_name = trim(safe_get(location, "name", ""))
  local location_address = trim(safe_get(location, "address", ""))
  local location_map_url = trim(safe_get(location, "map_url", ""))

  local format_type = trim(safe_get(format, "type", ""))
  local format_detail = trim(safe_get(format, "detail", ""))

  local language_primary = trim(safe_get(language, "primary", ""))
  local language_detail = trim(safe_get(language, "detail", ""))

  local date_display = build_date_display(start_date, end_date)

  local show_date_display = has_text(date_display)
  local show_time = has_text(time)
  local show_location_name = has_text(location_name)
  local show_location_address = has_text(location_address)
  local show_location_map_url = has_text(location_map_url)
  local show_format_type = has_text(format_type)
  local show_format_detail = has_text(format_detail)
  local show_language_primary = has_text(language_primary)
  local show_language_detail = has_text(language_detail)

  local show_date_time = show_date_display or show_time
  local show_location = show_location_name or show_location_address or show_location_map_url
  local show_format = show_format_type or show_format_detail
  local show_language = show_language_primary or show_language_detail

  local event_data = {
    date_display = date_display,
    time = time,
    start_date = start_date,
    end_date = end_date,
    location_name = location_name,
    location_address = location_address,
    location_map_url = location_map_url,
    format_type = format_type,
    format_detail = format_detail,
    language_primary = language_primary,
    language_detail = language_detail,
    show_date_time = show_date_time,
    show_location = show_location,
    show_format = show_format,
    show_language = show_language,
    card_class_date_time = show_date_time and "" or "d-none",
    card_class_location = show_location and "" or "d-none",
    card_class_format = show_format and "" or "d-none",
    card_class_language = show_language and "" or "d-none",
    date_display_class = show_date_display and "" or "d-none",
    time_class = show_time and "" or "d-none",
    location_name_class = show_location_name and "" or "d-none",
    location_address_class = show_location_address and "" or "d-none",
    format_type_class = show_format_type and "" or "d-none",
    format_detail_class = show_format_detail and "" or "d-none",
    language_primary_class = show_language_primary and "" or "d-none",
    language_detail_class = show_language_detail and "" or "d-none",
    location_link_class = show_location_map_url and "" or "d-none",
    location_plain_class = show_location_map_url and "d-none" or "",
    has_any_info_box = show_date_time or show_location or show_format or show_language,
    wrapper_class = (show_date_time or show_location or show_format or show_language) and "" or "d-none"
  }

  return event_data
end
function Meta(meta)
  meta.event_data = build_event_data(meta)
  return meta
end


