local core = require("tabme.core")
local M = {}

function M.tabline()
    local s = ""
    local tabs = vim.api.nvim_list_tabpages()

    if #tabs > 1 then
        local current_tab = vim.api.nvim_get_current_tabpage()
        for i, tab in ipairs(tabs) do
            if tab == current_tab then
                s = s .. "%#TabLineSel#"
            else
                s = s .. "%#TabLine#"
            end
            s = s .. "%" .. i .. "T"
            local windows = vim.api.nvim_tabpage_list_wins(tab)
            local is_pinned_in_tab = false
            local main_buf_name = "[No Name]"
            for _, win in ipairs(windows) do
                local buf = vim.api.nvim_win_get_buf(win)
                if buf == core.pinned_bufnr then
                    is_pinned_in_tab = true
                end
                if win == vim.api.nvim_tabpage_get_win(tab) then
                    local name = vim.api.nvim_buf_get_name(buf)
                    if name ~= "" then
                        main_buf_name = vim.fn.fnamemodify(name, ":t")
                    end
                end
            end
            if is_pinned_in_tab then
                s = s .. "%#TabmePinned# [" .. main_buf_name .. "] %#TabLine#"
            else
                s = s .. " " .. main_buf_name .. " "
            end
        end
    else
        -- Only one tab, show buffers instead
        local current_buf = vim.api.nvim_get_current_buf()
        local bufs = vim.api.nvim_list_bufs()
        for _, buf in ipairs(bufs) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_get_option_value("buflisted", { buf = buf }) then
                if buf == current_buf then
                    s = s .. "%#TabLineSel#"
                else
                    s = s .. "%#TabLine#"
                end
                local name = vim.api.nvim_buf_get_name(buf)
                if name == "" then
                    name = "[No Name]"
                else
                    name = vim.fn.fnamemodify(name, ":t")
                end
                if buf == core.pinned_bufnr then
                    s = s .. "%#TabmePinned# [" .. name .. "] %#TabLine#"
                else
                    s = s .. " " .. name .. " "
                end
            end
        end
    end
    s = s .. "%#TabLineFill#%T"
    return s
end

return M
