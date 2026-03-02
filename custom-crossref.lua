-- fullsec.lua
-- Usage: @fullsec(sec-id)

local headers = {}

-- Capture headers with computed numbers
function Header(el)
  if el.identifier ~= "" then
    headers[el.identifier] = {
      title = pandoc.utils.stringify(el.content),
      number = el.number and pandoc.utils.stringify(el.number) or ""
    }
  end
  return el
end

-- Process inline content safely
function Inlines(inlines)
  local result = pandoc.List()

  for i = 1, #inlines do
    local el = inlines[i]

    if el.t == "Str" then
      local id = el.text:match("^@fullsec%((.+)%)$")

      if id and headers[id] then
        local sec = headers[id]
        local text = sec.number .. " " .. sec.title

        result:insert(
          pandoc.Link(
            pandoc.Str(text),
            "#" .. id
          )
        )
      else
        result:insert(el)
      end
    else
      result:insert(el)
    end
  end

  return result
end