vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

vim.keymap.set("n", "<space>to", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
end)

require("vim._core.ui2").enable({})

vim.o.autoread = true
vim.o.hlsearch = true -- Set highlight on search
vim.o.number = true -- Make line numbers default
vim.o.mouse = "a" -- Enable mouse mode
vim.o.breakindent = true -- Enable break indent
vim.o.undofile = true -- Save undo history
vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true -- smart case
vim.wo.signcolumn = "yes" -- Keep signcolumn on by default
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.o.backup = false -- creates a backup file
vim.o.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.o.completeopt = "menuone,noselect" -- Set completeopt to have a better completion experience
vim.opt.termguicolors = true -- set termguicolors to enable highlight groups
vim.o.whichwrap = "bs<>[]hl" -- which "horizontal" keys are allowed to travel to prev/next line
vim.o.wrap = false -- display lines as one long line
vim.o.linebreak = true -- companion to wrap don't split words
vim.o.scrolloff = 15 -- minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 8 -- minimal number of screen columns either side of cursor if wrap is `false`
vim.o.relativenumber = true -- set relative numbered lines
vim.o.numberwidth = 4 -- set number column width to 2 {default 4}
vim.o.shiftwidth = 0 -- the number of spaces inserted for each indentation
vim.o.tabstop = 2 -- insert n spaces for a tab
vim.o.softtabstop = -1 -- Number of spaces that a tab counts for while performing editing operations
vim.o.expandtab = true -- convert tabs to spaces
vim.o.cursorline = false -- highlight the current line
vim.o.splitbelow = true -- force all horizontal splits to go below current window
vim.o.splitright = true -- force all vertical splits to go to the right of current window
vim.o.swapfile = false -- creates a swapfile
vim.o.smartindent = true -- make indenting smarter again
vim.o.showmode = false -- we don't need to see things like -- INSERT -- anymore
vim.o.showtabline = 1 -- always show tabs
vim.o.backspace = "indent,eol,start" -- allow backspace on
vim.o.pumheight = 10 -- pop up menu height
vim.o.conceallevel = 0 -- so that `` is visible in markdown files
vim.o.fileencoding = "utf-8" -- the encoding written to a file
vim.o.cmdheight = 0 -- more space in the neovim command line for displaying messages
vim.o.autoindent = true -- copy indent from current line when starting new one
vim.opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.

vim.g.have_nerd_font = true

--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
--disable netrrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.laststatus = 3
vim.opt.clipboard:append("unnamedplus") -- Sync clipboard between OS and Neovim.
-- vim.opt.guicursor = ""
vim.colorcolumn = "0"

local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
-- vim.keymap.set("n", "<leader>x", ":.lua<CR>")
-- vim.keymap.set("v", "<leader>x", ":lua<CR>")

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Allow moving the cursor through wrapped lines with j, k
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Insert new line
vim.keymap.set("n", "zj", "o<esc>", opts)
vim.keymap.set("n", "zk", "<S-o><esc>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Vertical scroll and center
-- vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
-- vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

vim.keymap.set("n", "<S-j>", "<C-d>zz", opts)
vim.keymap.set("n", "<S-k>", "<C-u>zz", opts)
vim.keymap.set("n", "<S-h>", "^", opts)
vim.keymap.set("n", "<S-l>", "$", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- BuffercopeFuzzyCommandSearch)
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)

-- Save all
vim.keymap.set("n", "<leader>w", ":wa<CR>", opts)

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", silent = true })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", silent = true })

-- Resize window
vim.keymap.set("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })

-- Toggle line number
vim.keymap.set("n", "<leader>an", function()
	vim.wo.number = not vim.wo.number
	vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle line number" })

-- native undotree
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })
