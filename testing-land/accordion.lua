function Pandoc(doc)
    local blocks = doc.blocks
    local result = pandoc.List()
    local i = 1

    while i <= #blocks do
        local block = blocks[i]

        if block.t == "Header" and block.level == 2 then
            -- Collect everything until the next level-1 or level-2 heading
            local content = pandoc.List()
            local j = i + 1

            while j <= #blocks and
                not (blocks[j].t == "Header" and blocks[j].level <= 2) do
                content:insert(blocks[j])
                j = j + 1
            end

            local id = block.identifier
            local collapse_id = id .. "-collapse"

            -- Turn the existing ## heading into the accordion button
            block.classes:insert("accordion-button")
            block.classes:insert("collapsed")
            block.attributes["data-bs-toggle"] = "collapse"
            block.attributes["data-bs-target"] = "#" .. collapse_id
            block.attributes["aria-expanded"] = "false"
            block.attributes["aria-controls"] = collapse_id

            -- Accordion header
            local header = pandoc.Div(
                pandoc.List:new({ block }),
                pandoc.Attr("", { "accordion-header" })
            )

            -- Accordion body
            local body = pandoc.Div(
                pandoc.List:new({
                    pandoc.Div(
                        content,
                        pandoc.Attr("", { "accordion-body" })
                    )
                }),
                pandoc.Attr(
                    collapse_id,
                    { "accordion-collapse", "collapse" }
                )
            )

            -- Accordion item
            result:insert(
                pandoc.Div(
                    pandoc.List:new({ header, body }),
                    pandoc.Attr("", { "accordion-item" })
                )
            )

            i = j
        else
            result:insert(block)
            i = i + 1
        end
    end

    doc.blocks = result
    return doc
end
