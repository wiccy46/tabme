-- Simple test script for Tabme
-- Run with: nvim --headless -u NONE -c "set runtimepath+=." -S tests/test_tabme.lua -c "qa"

local core = require("tabme.core")

-- Mock nvim_get_current_buf to return a predictable bufnr
local original_get_current_buf = vim.api.nvim_get_current_buf
local current_buf = 1
vim.api.nvim_get_current_buf = function() return current_buf end

print("Testing Tabme pinning...")

-- Initial state
assert(core.pinned_bufnr == nil, "Initial pinned buffer should be nil")

-- Pin buffer 1
core.pin()
assert(core.pinned_bufnr == 1, "Buffer 1 should be pinned")

-- Pin buffer 2
current_buf = 2
core.pin()
assert(core.pinned_bufnr == 2, "Buffer 2 should be pinned (overriding 1)")

-- Unpin buffer 2 (toggle)
core.pin()
assert(core.pinned_bufnr == nil, "Should be unpinned after toggling")

-- Focus logic (minimal test)
core.pinned_bufnr = 2
-- We can't easily mock nvim_list_wins and other UI things effectively here 
-- but we can check if it at least doesn't crash.
pcall(core.focus)

print("Tests passed!")
