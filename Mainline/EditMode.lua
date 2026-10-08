local addonName, JadeUI = ...

function CreateJadeUILayout()

    local layoutOffset = 0
    --Offset the base index to index 4, which is the first custom layout
    if JadeUI.isForever then
        layoutOffset = 3
    end

    --Import the existing layouts
    local layoutData = C_EditMode.GetLayouts()

    -- Get index of JadeUI if it already exists
    local targetIndex = nil
    for index, layout in ipairs(layoutData.layouts) do
        if layout.layoutName == "JadeUI" then
            targetIndex = index
            break
        end
    end

    if targetIndex then
        layoutData.layouts[targetIndex] = JadeUI.Layout
    else
        table.insert(layoutData.layouts, JadeUI.Layout)
        targetIndex = #layoutData.layouts
    end

    C_EditMode.SaveLayouts(layoutData)
    C_EditMode.SetActiveLayout(targetIndex+layoutOffset)

end
