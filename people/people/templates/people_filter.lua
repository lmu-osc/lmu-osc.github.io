local function stringify(value)
  if value == nil then
    return ""
  end
  return pandoc.utils.stringify(value)
end

local function trim(value)
  local s = stringify(value)
  return s:match("^%s*(.-)%s*$")
end

local function get_meta(meta, key, default)
  if meta[key] == nil then
    return default
  end
  return meta[key]
end

local function list_length(value)
  if type(value) ~= "table" then
    return 0
  end
  return #value
end

local function membership_sort_key(membership, type_priority)
  local membership_type = trim(membership.type)
  local idx = type_priority[membership_type]
  if idx == nil then
    return 9999
  end
  return idx
end

local function has_position_or_faculty(membership)
  if trim(membership.position) ~= "" then
    return true
  end
  if trim(membership.faculty) ~= "" then
    return true
  end
  if trim(membership.affiliation) ~= "" then
    return true
  end
  if trim(membership.title) ~= "" then
    return true
  end
  return false
end

local function select_best_membership(memberships, type_priority)
  if list_length(memberships) == 0 then
    return nil
  end

  local sorted = pandoc.List({})
  for _, membership in ipairs(memberships) do
    sorted:insert(membership)
  end

  sorted:sort(function(a, b)
    return membership_sort_key(a, type_priority) < membership_sort_key(b, type_priority)
  end)

  for _, membership in ipairs(sorted) do
    if has_position_or_faculty(membership) then
      return membership
    end
  end

  return sorted[1]
end

local function derive_position_and_faculty(meta)
  local memberships = get_meta(meta, "memberships", pandoc.List({}))
  local position = ""
  local faculty = ""

  if list_length(memberships) == 0 then
    return position, faculty
  end

  local type_priority = {
    ["management"] = 1,
    ["staff"] = 2,
    ["advisory board"] = 3,
    ["scientific board"] = 4,
    ["special advisor"] = 5,
    ["lmu-individual"] = 6,
    ["fellow"] = 7,
    ["affiliate"] = 8
  }

  local active_memberships = pandoc.List({})
  local alumni_memberships = pandoc.List({})

  for _, membership in ipairs(memberships) do
    local status = trim(membership.status)
    if status == "active" then
      active_memberships:insert(membership)
    elseif status == "alumni" then
      alumni_memberships:insert(membership)
    end
  end

  local best_membership = select_best_membership(active_memberships, type_priority)
  if best_membership == nil then
    best_membership = select_best_membership(alumni_memberships, type_priority)
  end

  if best_membership == nil then
    best_membership = select_best_membership(memberships, type_priority)
  end

  if best_membership ~= nil then
    if trim(best_membership.position) ~= "" then
      position = trim(best_membership.position)
    elseif trim(best_membership.title) ~= "" then
      position = trim(best_membership.title)
    end

    if trim(best_membership.faculty) ~= "" then
      faculty = trim(best_membership.faculty)
    elseif trim(best_membership.affiliation) ~= "" then
      faculty = trim(best_membership.affiliation)
    end
  end

  return position, faculty
end

local function order_links(meta)
  local links = get_meta(meta, "links", pandoc.List({}))
  if list_length(links) == 0 then
    return links
  end

  local priority = {
    ["LMU Profile"] = 1,
    ["Professional Profile"] = 2,
    ["Personal Website"] = 3,
    ["Professional Website"] = 4
  }

  local keyed = pandoc.List({})
  for idx, link in ipairs(links) do
    local label = trim(link.label)
    local rank = priority[label] or 9999
    keyed:insert({ rank = rank, original_index = idx, link = link })
  end

  keyed:sort(function(a, b)
    if a.rank == b.rank then
      return a.original_index < b.original_index
    end
    return a.rank < b.rank
  end)

  local ordered = pandoc.List({})
  for _, item in ipairs(keyed) do
    ordered:insert(item.link)
  end

  return ordered
end

local function transform_social_media(meta)
  local social_media = get_meta(meta, "social_media", nil)
  if social_media == nil then
    return nil
  end

  local platform_map = {
    bluesky = "bluesky",
    linkedin = "linkedin",
    github = "github",
    orcid = "orcid",
    mastodon = "mastodon",
    scholar = "mortarboard",
    researchgate = "mortarboard",
    academia = "book",
    youtube = "youtube",
    instagram = "instagram",
    facebook = "facebook"
  }

  local transformed = pandoc.List({})

  for platform_name, url_value in pairs(social_media) do
    local url = trim(url_value)
    if url ~= "" then
      local platform_key = trim(platform_name):lower()
      local icon_platform = platform_map[platform_key] or "link-45deg"
      transformed:insert({
        url = pandoc.MetaString(url),
        platform = pandoc.MetaString(icon_platform)
      })
    end
  end

  if #transformed == 0 then
    return nil
  end

  return transformed
end

function Meta(meta)
  local position, faculty = derive_position_and_faculty(meta)
  meta.position = pandoc.MetaString(position)
  meta.faculty = pandoc.MetaString(faculty)
  meta.links = order_links(meta)

  local transformed_social = transform_social_media(meta)
  if transformed_social ~= nil then
    meta.social_media = transformed_social
  end

  return meta
end