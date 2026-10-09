local M = {}

function M.setup()
	-- Ensure runtimepath includes this config directory
	local this_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
	vim.opt.runtimepath:prepend(this_dir)

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
	opt.inccommand = "split"

	-- File & Buffer handling
	opt.autoread = true
	opt.undofile = true
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
	opt.completeopt = "menu,menuone,noinsert"

	-- UI appearance
	opt.termguicolors = true
	opt.showmode = false
	opt.showtabline = 1
	opt.laststatus = 3
	opt.cmdheight = 0
	opt.mouse = "a"

	pcall(vim.cmd.colorscheme, "retrobox")

	opt.clipboard = "unnamedplus"

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

	-- Statusline
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

  function _G.fuzzy_find_file(text,_)
    local files = vim.fn.glob("**/*", true, true)
    return vim.fn.matchfuzzy(files, text)
  end

	vim.o.statusline = "%!v:lua.custom_statusline()"

	-- Wildmenu & find
  opt.findfunc = "v:lua.fuzzy_find_file"
	opt.path:append("**")
	opt.wildmenu = true
	opt.wildoptions = "pum,fuzzy"
	opt.wildmode = "longest:full,full"
	opt.wildignore:append({ "*/.git/*", "*/node_modules/*", "*/target/*", "*.o", "*.pyc" })

	if vim.fn.executable("rg") == 1 then
		opt.grepprg = "rg --vimgrep --smart-case --hidden -g '!.git'"
		opt.grepformat = "%f:%l:%c:%m"
	end

	-- Netrw
	vim.g.netrw_banner = 0
	vim.g.netrw_liststyle = 3
	vim.g.netrw_winsize = 25
	vim.g.netrw_browse_split = 4
	vim.g.netrw_altv = 1

	pcall(vim.cmd.packadd, "cfilter")
end

return M
