local WidgetContainer = require("ui/widget/container/widgetcontainer")
local UIManager = require("ui/uimanager")
local Menu = require("ui/widget/menu")
local ConfirmBox = require("ui/widget/confirmbox")
local _ = require("gettext")

local SchultePlugin = WidgetContainer:extend{
    name = "schulte_table",
    is_doc_only = false,
}

function SchultePlugin:init()
    if self.ui.menu then
        self.ui.menu:registerToMainMenu(self)
    end
end

function SchultePlugin:addToMainMenu(menu_items)
    menu_items.schulte_table = {
        sorting_hint = "search", 
        text = _("Tabla de Schulte"),
        callback = function()
            self:showConfigMenu()
        end,
    }
end

function SchultePlugin:generateRandomNumbers(count)
    local nums = {}
    for i = 1, count do table.insert(nums, i) end
    
    math.randomseed(os.time())
    
    for i = #nums, 2, -1 do
        local j = math.random(i)
        nums[i], nums[j] = nums[j], nums[i]
    end
    return nums
end

function SchultePlugin:showConfigMenu()
    local item_table = {
        { text = "3x3 (9 números)", callback = function() self:drawTable(3) end },
        { text = "4x4 (16 números)", callback = function() self:drawTable(4) end },
        { text = "5x5 (25 números)", callback = function() self:drawTable(5) end },
        { text = "6x6 (36 números)", callback = function() self:drawTable(6) end },
    }
    local config_menu = Menu:new{
        title = _("Tamaño de la Tabla"),
        item_table = item_table,
    }
    UIManager:show(config_menu)
end

function SchultePlugin:drawTable(size)
    local nums = self:generateRandomNumbers(size * size)
    
    local text_grid = "\n"
    for r = 1, size do
        local row_str = ""
        for c = 1, size do
            local num = nums[((r-1) * size) + c]
            -- %2d alinea a la derecha usando espacios lógicos (ej. " 1", "36")
            row_str = row_str .. string.format("%2d        ", num)
        end
        text_grid = text_grid .. row_str .. "\n\n\n"
    end

    local dialog
    
    dialog = ConfirmBox:new{
        text = text_grid,
        ok_text = _("Cerrar"),
        ok_callback = function()
            UIManager:close(dialog)
        end,
        cancel_text = _("Nueva Tabla"),
        cancel_callback = function()
            UIManager:close(dialog)
            self:drawTable(size)
        end,
    }

    UIManager:show(dialog)
end

return SchultePlugin