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

-- Keybindings --

vim.g.mapleader = " "

-- Window splits
local opts = { noremap = true, silent = true }

opts.desc = "Split window vertically"
vim.keymap.set("n", "<leader>sv", "<C-w>v", opts)

opts.desc = "Split window horizontally"
vim.keymap.set("n", "<leader>sh", "<C-w>s", opts)

opts.desc = "Make splits equal size"
vim.keymap.set("n", "<leader>se", "<C-w>=", opts)

opts.desc = "Close current split"
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", opts)

-- Tabs management --
opts.desc = "Open new tab"
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", opts)

opts.desc = "Close current tab"
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", opts)

opts.desc = "Go to next tab"
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", opts)

opts.desc = "Go to previous tab"
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", opts)

-- Editor
opts.desc = "Move selected lines down"
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)

opts.desc = "Move selected lines up"
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Load lazy.nvim plugin manager --
require("system-forger")
