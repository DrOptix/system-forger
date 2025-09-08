-- THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

-- Core editor configs --

-- Show line numbers and activate relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use spaces for tabs & indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Disable line wrapping by default
vim.opt.wrap = false

-- Line limit guide, we'll default at 80 chars
vim.opt.colorcolumn = "80"

-- Highlights the current line
vim.opt.cursorline = true

-- Search settings:
--   * First lowercase letter assumes case insensitive search
--   * First uppercase letter assumes case sensitive search
vim.opt.ignorecase = true
vim.opt.smartcase = true
