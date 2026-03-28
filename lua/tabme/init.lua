local core = require("tabme.core")
local ui = require("tabme.ui")

local M = {}

local default_config = {
    keybindings = {
        pin = "<leader>tp",
        focus = "<leader>tf",
    },
    tabline = false, -- Whether to override the tabline
    highlight = {
        link = "Search", -- More visible default
        bold = true,
    },
}

M.core = core

function M.is_pinned(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return core.pinned_bufnr == bufnr
end

function M.format(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    name = (name == "") and "[No Name]" or vim.fn.fnamemodify(name, ":t")
    
    if M.is_pinned(bufnr) then
        return "%#TabmePinned# [" .. name .. "] %#TabLineSel#"
    end
    return name
end

function M.setup(user_config)
    local config = vim.tbl_deep_extend("force", default_config, user_config or {})

    -- Register commands
    vim.api.nvim_create_user_command("TabmePin", core.pin, {})
    vim.api.nvim_create_user_command("TabmeFocus", core.focus, {})
    vim.api.nvim_create_user_command("TabmeUnpin", core.unpin, {})

    -- Set keybindings if they are defined
    if config.keybindings.pin then
        vim.keymap.set("n", config.keybindings.pin, core.pin, { desc = "Pin/Unpin current buffer" })
    end
    if config.keybindings.focus then
        vim.keymap.set("n", config.keybindings.focus, core.focus, { desc = "Focus pinned buffer" })
    end

    -- Setup highlighting for pinned buffer
    local function set_highlights()
        vim.api.nvim_set_hl(0, "TabmePinned", config.highlight)
    end

    set_highlights()

    -- Ensure highlights persist on colorscheme change
    vim.api.nvim_create_autocmd("ColorScheme", {
        callback = set_highlights,
    })

    -- Setup tabline if enabled
    if config.tabline then
        vim.opt.tabline = "%!v:lua.require'tabme.ui'.tabline()"
        vim.opt.showtabline = 2 -- Always show tabline
    end

    -- Clear pinned buffer if it is deleted
    vim.api.nvim_create_autocmd("BufDelete", {
        callback = function(args)
            if core.pinned_bufnr == args.buf then
                core.pinned_bufnr = nil
                vim.cmd("redrawtabline")
            end
        end,
    })
end

return M
