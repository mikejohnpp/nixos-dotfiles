vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Ensure runtimepath includes this config directory
local this_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(this_dir)

local this_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(this_dir)

local completion = require("config.completion")
local lsp = require("config.lsp")

completion.setup()
lsp.setup()

pcall(function()
	require("vim._core.ui2").enable({})
end)

local opt = vim.opt

-- Line numbers & cursor
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.cursorline = false
opt.signcolumn = "yes"
opt.scrolloff = 15
opt.sidescrolloff = 8

-- Indentation & Tabs
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = -1
opt.shiftwidth = 4
opt.smartindent = true
opt.autoindent = true

-- Search settings
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split" -- Live preview substitutions

-- File & Buffer handling
opt.autoread = true
opt.undofile = true -- Persistent undo history
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.fileencoding = "utf-8"

-- Splits & Windows
opt.splitbelow = true
opt.splitright = true

-- Wrapping & Text display
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.whichwrap = "bs<>[]hl"
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Timing & Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Completion menu
opt.pumheight = 10
opt.shortmess:append("c")
opt.iskeyword:append("-")
opt.formatoptions:remove({ "c", "r", "o" })

-- UI appearance
opt.termguicolors = true
opt.showmode = false -- Mode is displayed in custom statusline
opt.showtabline = 1
opt.laststatus = 3 -- Global statusline
opt.cmdheight = 0
opt.mouse = "a"

-- Built-in colorscheme
pcall(vim.cmd.colorscheme, "retrobox")

opt.clipboard = "unnamedplus"

-- If connected via SSH, synchronize clipboard with local machine using OSC 52
if vim.env.SSH_TTY or vim.env.SSH_CLIENT then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = osc52.paste("+"),
			["*"] = osc52.paste("*"),
		},
	}
end

local modes = {
	["n"] = "NORMAL",
	["no"] = "O-PENDING",
	["v"] = "VISUAL",
	["V"] = "V-LINE",
	["\22"] = "V-BLOCK",
	["s"] = "SELECT",
	["S"] = "S-LINE",
	["\19"] = "S-BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "V-REPLACE",
	["c"] = "COMMAND",
	["cv"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
}

function _G.custom_statusline()
	local m = modes[vim.fn.mode()] or vim.fn.mode()
	local file = vim.fn.expand("%:~:.")
	if file == "" then
		file = "[No Name]"
	end
	local modified = vim.bo.modified and " [+]" or ""
	local readonly = (vim.bo.readonly or not vim.bo.modifiable) and " [RO]" or ""
	local ft = vim.bo.filetype ~= "" and (" " .. vim.bo.filetype) or ""
	return string.format(" %s │ %s%s%s %%=%s │ %%l:%%c │ %%p%%%% ", m, file, modified, readonly, ft)
end

vim.o.statusline = "%!v:lua.custom_statusline()"

-- Recursive file search for `:find`
opt.path:append("**")
opt.wildmenu = true
opt.wildoptions = "pum,fuzzy"
opt.wildmode = "longest:full,full"
opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/target/*", "*.o", "*.pyc" })

-- Live Grep with ripgrep if installed
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep --smart-case --hidden -g '!.git'"
	opt.grepformat = "%f:%l:%c:%m"
end

-- Netrw configuration
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- Tree view
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_altv = 1

-- Load quickfix filter tool
pcall(vim.cmd.packadd, "cfilter")

local augroup = function(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	desc = "Highlight selection on yank",
	callback = function()
		vim.hl.on_yank({ timeout = 200 })
	end,
})

-- Restore cursor to last position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("restore_cursor"),
	desc = "Restore cursor to file position in previous session",
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto resize splits when terminal window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup("resize_splits"),
	command = "wincmd =",
})

-- Check for external changes on focus
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = augroup("checktime"),
	command = "checktime",
})

-- Close auxiliary windows with 'q'
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("quick_close"),
	pattern = { "help", "man", "qf", "checkhealth" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
	end,
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- Terminal settings
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup("term_open"),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.cmd.startinsert()
	end,
})



-- Diagnostic keymaps
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })



local opts = { noremap = true, silent = true }

-- Reload config
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source current file" })

-- File exploration & Navigation
vim.keymap.set("n", "<leader>e", "<cmd>Lexplore<CR>", { desc = "Toggle Netrw File Explorer" })
vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file (native)" })
vim.keymap.set("n", "<leader>fb", ":b ", { desc = "Find buffer (native)" })
vim.keymap.set("n", "<leader>fg", function()
	local pattern = vim.fn.input("Grep: ")
	if pattern ~= "" then
		vim.cmd("silent grep! " .. pattern .. " | copen")
	end
end, { desc = "Grep search" })

-- Quickfix navigation & toggle
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "]Q", "<cmd>clast<CR>zz", { desc = "Last quickfix item" })
vim.keymap.set("n", "[Q", "<cmd>cfirst<CR>zz", { desc = "First quickfix item" })
vim.keymap.set("n", "<leader>cq", function()
	local qf_win = vim.fn.getqflist({ winid = 0 }).winid
	if qf_win ~= 0 then
		vim.cmd("cclose")
	else
		vim.cmd("copen")
	end
end, { desc = "Toggle quickfix window" })

-- Move lines up/down (Normal, Visual, Insert)
vim.keymap.set("n", "<M-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("i", "<M-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<M-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down", silent = true })
vim.keymap.set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up", silent = true })

-- Moving through wrapped lines
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Insert blank line without entering insert mode
vim.keymap.set("n", "zj", "o<esc>", opts)
vim.keymap.set("n", "zk", "<S-o><esc>", opts)

-- Delete single character without copying to register
vim.keymap.set("n", "x", '"_x', opts)

-- Keep last yanked when pasting in visual mode
vim.keymap.set("v", "p", '"_dP', opts)

-- Explicitly yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })

-- Half-page jump & center
vim.keymap.set("n", "<S-j>", "<C-d>zz", opts)
vim.keymap.set("n", "<S-k>", "<C-u>zz", opts)
vim.keymap.set("n", "<S-h>", "^", opts)
vim.keymap.set("n", "<S-l>", "$", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Buffer navigation & deletion (Preserves window split layout)
local function buf_delete(bufnr)
	bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].modified then
		local choice = vim.fn.confirm("Lưu thay đổi trước khi đóng buffer?", "&Yes\n&No\n&Cancel")
		if choice == 1 then
			vim.cmd.write()
		elseif choice == 3 or choice == 0 then
			return
		end
	end

	local windows = vim.fn.win_findbuf(bufnr)
	local alt_buf = vim.fn.bufnr("#")
	local target_buf = (alt_buf > 0 and alt_buf ~= bufnr and vim.api.nvim_buf_is_loaded(alt_buf) and vim.bo[alt_buf].buflisted) and alt_buf or nil

	if not target_buf then
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			if b ~= bufnr and vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted then
				target_buf = b
				break
			end
		end
	end

	for _, win in ipairs(windows) do
		if target_buf then
			vim.api.nvim_win_set_buf(win, target_buf)
		else
			local scratch = vim.api.nvim_create_buf(true, false)
			vim.api.nvim_win_set_buf(win, scratch)
		end
	end

	pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
end

local function buf_delete_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if b ~= current and vim.bo[b].buflisted then
			buf_delete(b)
		end
	end
end

local function buf_delete_all()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[b].buflisted then
			buf_delete(b)
		end
	end
end

vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>qa", buf_delete, { desc = "Buffer delete" })
vim.keymap.set("n", "<leader>qA", buf_delete_all, { desc = "Buffer delete all" })
vim.keymap.set("n", "<leader>qo", buf_delete_others, { desc = "Buffer delete other" })

-- Save all
vim.keymap.set("n", "<leader>w", ":wa<CR>", { desc = "Save all files" })

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Move selected lines up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down", silent = true })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up", silent = true })

-- Clear search highlight on Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts)

-- Terminal keymaps
vim.keymap.set("n", "<space>to", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 15)
end, { desc = "Open bottom terminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window resizing
vim.keymap.set("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<cr>", { desc = "Decrease Window Width" })

-- Toggle line numbers
vim.keymap.set("n", "<leader>an", function()
	vim.wo.number = not vim.wo.number
	vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle line number" })

-- Native Undotree (Neovim 0.12 built-in)
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle Builtin Undotree" })

-- Native Difftool (Neovim 0.12 built-in)
vim.keymap.set("n", "<leader>df", function()
	vim.cmd.packadd("nvim.difftool")
	local f1 = vim.fn.input("File 1: ", vim.fn.expand("%"), "file")
	local f2 = vim.fn.input("File 2: ", "", "file")
	if f1 ~= "" and f2 ~= "" then
		require("difftool").open(f1, f2)
	end
end, { desc = "Diff two files (Native)" })

-- Lazygit in tab (if installed on server)
if vim.fn.executable("lazygit") == 1 then
	vim.keymap.set("n", "<leader>lg", "<cmd>tabnew | term lazygit<CR>", { desc = "Open Lazygit" })
end
