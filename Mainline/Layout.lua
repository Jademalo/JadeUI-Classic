local addonName, JadeUI = ...

--Dump the current edit mode layouts into a savedvariable
JadeUIEditDB = JadeUIEditDB or {}
function ExportToSavedVariables()
    local layoutInfo = C_EditMode.GetLayouts()
    if layoutInfo then
        JadeUIEditDB = layoutInfo
        print("Layout info saved! Type /reload to write to SavedVariables.")
    end
end

--Basic UI Layout, based on Modern. This is necessary because GetLayouts doesn't dump the default presets.
JadeUI.defaultLayout = {
    ["layoutName"] = "JadeUI",
    ["interfaceStyle"] = 0,
    ["layoutType"] = 1,
    ["systems"] = {
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "MicroMenuContainer",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMLEFT",
                ["offsetY"] = -4,
                ["offsetX"] = -4.5,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 1,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = -77,
                ["offsetX"] = -5,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 4,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 1,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = -77,
                ["offsetX"] = -5,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 5,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 6,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = -50,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 7,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = -100,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 8,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 11,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 12,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 13,
            ["system"] = 0,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "CENTER",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 1,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 2,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                ["offsetY"] = -4,
                ["offsetX"] = 4,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                ["offsetY"] = -4,
                ["offsetX"] = 250,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                ["offsetY"] = -240,
                ["offsetX"] = 500,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 26,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 8,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 12,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 14,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 18,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 19,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 20,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 21,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 22,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "CompactRaidFrameManager",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = -7,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 4,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 26,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 8,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 12,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 13,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 14,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 15,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 18,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 19,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 20,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 21,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 22,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "CompactRaidFrameManager",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = -5,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 5,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 6,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 26,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 8,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 12,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 17,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 18,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 19,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 20,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 21,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 22,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 7,
            ["system"] = 3,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 16,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "CENTER",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 8,
            ["system"] = 3,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 4,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 5,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 11,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 6,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = -10,
                ["offsetX"] = -255,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 6,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 8,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = -155,
                ["offsetX"] = -270,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 6,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 11,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 9,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -25,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 6,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 7,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 4,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 30,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 20,
                    ["setting"] = 3,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOMLEFT",
                ["relativePoint"] = "BOTTOMLEFT",
                ["offsetY"] = 145,
                ["offsetX"] = 35,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 8,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = -4,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 9,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                ["offsetY"] = -116,
                ["offsetX"] = 16,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 10,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOMRIGHT",
                ["offsetY"] = 85,
                ["offsetX"] = -9,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 11,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 40,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPRIGHT",
                ["relativePoint"] = "TOPRIGHT",
                ["offsetY"] = -275,
                ["offsetX"] = -110,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 12,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 6,
                    ["setting"] = 2,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 6,
                ["offsetX"] = 116.5,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 13,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 2,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "MicroMenuContainer",
                ["point"] = "BOTTOMLEFT",
                ["relativePoint"] = "BOTTOMRIGHT",
                ["offsetY"] = -4,
                ["offsetX"] = 7,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 14,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 10,
                    ["setting"] = 3,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 15,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 10,
                    ["setting"] = 3,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 17,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 15,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 16,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -100,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 17,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 10,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 18,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 19,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 12,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 310,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 20,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 7,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 240,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 20,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 370,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 20,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 1,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 11,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 430,
                ["offsetX"] = 420,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 4,
            ["system"] = 20,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 100,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 3,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 12,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 13,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 14,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 380,
                ["offsetX"] = -410,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 21,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 1,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 12,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 13,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOMRIGHT",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 336,
                ["offsetX"] = -457,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 22,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 8,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -40,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 22,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 8,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -90,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 22,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 7,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 8,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -130,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 4,
            ["system"] = 22,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 200,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 20,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 2,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 6,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 8,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 9,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 10,
                },
                {
                    ["value"] = 5,
                    ["setting"] = 11,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 12,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOPLEFT",
                ["relativePoint"] = "TOPLEFT",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 23,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "TOP",
                ["relativePoint"] = "TOP",
                ["offsetY"] = -182,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 24,
        },
        {
            ["settings"] = {
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "RIGHT",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 128,
                ["offsetX"] = -28,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 25,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "MainActionBar",
                ["point"] = "RIGHT",
                ["relativePoint"] = "LEFT",
                ["offsetY"] = 5,
                ["offsetX"] = 30,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 26,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 0,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "BagsBar",
                ["point"] = "LEFT",
                ["relativePoint"] = "RIGHT",
                ["offsetY"] = 5,
                ["offsetX"] = -30,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 26,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 10,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "Minimap",
                ["point"] = "CENTER",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = -68,
                ["offsetX"] = -68,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 27,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 0,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "CENTER",
                ["relativePoint"] = "CENTER",
                ["offsetY"] = 0,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["system"] = 28,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 213,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 15,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 6,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 450,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 1,
            ["system"] = 29,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 213,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 15,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 6,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 425,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 2,
            ["system"] = 29,
        },
        {
            ["settings"] = {
                {
                    ["value"] = 5,
                    ["setting"] = 0,
                },
                {
                    ["value"] = 50,
                    ["setting"] = 1,
                },
                {
                    ["value"] = 0,
                    ["setting"] = 2,
                },
                {
                    ["value"] = 213,
                    ["setting"] = 3,
                },
                {
                    ["value"] = 15,
                    ["setting"] = 4,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 5,
                },
                {
                    ["value"] = 1,
                    ["setting"] = 6,
                },
            },
            ["anchorInfo"] = {
                ["relativeTo"] = "UIParent",
                ["point"] = "BOTTOM",
                ["relativePoint"] = "BOTTOM",
                ["offsetY"] = 400,
                ["offsetX"] = 0,
            },
            ["isInDefaultPosition"] = true,
            ["systemIndex"] = 3,
            ["system"] = 29,
        },
    },
}
