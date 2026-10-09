vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ensure runtimepath includes this config directory
local this_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(this_dir)

local plugins = require("config.plugins")
local options = require("config.options")
local autocmds = require("config.autocmds")
local keymaps = require("config.keymaps")
local completion = require("config.completion")
local lsp = require("config.lsp")

plugins.setup()
options.setup()
autocmds.setup()
keymaps.setup()
completion.setup()
lsp.setup()
