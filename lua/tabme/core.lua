local M = {}

M.pinned_bufnr = nil

function M.pin()
    local bufnr = vim.api.nvim_get_current_buf()
    if M.pinned_bufnr == bufnr then
        M.pinned_bufnr = nil
        print("Tabme: Unpinned buffer " .. bufnr)
    else
        M.pinned_bufnr = bufnr
        print("Tabme: Pinned buffer " .. bufnr)
    end
    -- Trigger UI update if necessary
    vim.cmd("redrawtabline")
end

function M.unpin()
    M.pinned_bufnr = nil
    print("Tabme: Unpinned all buffers")
    vim.cmd("redrawtabline")
end

function M.focus()
    if not M.pinned_bufnr or not vim.api.nvim_buf_is_valid(M.pinned_bufnr) then
        print("Tabme: No pinned buffer or buffer is invalid")
        return
    end

    -- Try to find a window with the pinned buffer
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == M.pinned_bufnr then
            vim.api.nvim_set_current_win(win)
            return
        end
    end

    -- If not found in any window, switch to it in the current window
    vim.api.nvim_set_current_buf(M.pinned_bufnr)
end

return M
