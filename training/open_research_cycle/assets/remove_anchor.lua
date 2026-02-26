function Header(el)
  if el.classes:includes("no-anchor") then
    el.identifier = ""
    return el
  end
end