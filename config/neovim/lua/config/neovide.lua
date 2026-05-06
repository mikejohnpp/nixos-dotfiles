if not vim.g.neovide then
	return
end

-- Force line numbers (fix for Neovide)
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.cmdheight = 0

-- Font
vim.o.guifont = "JetBrainsMono Nerd Font Propo:h13"

-- Transparency
vim.g.neovide_opacity = 0.93
vim.g.neovide_normal_opacity = 0.93

-- Scroll animation
vim.g.neovide_scroll_animation_length = 0.2

-- Floating blur
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- Padding
vim.g.neovide_padding_top = 0
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 0
vim.g.neovide_padding_left = 0

-- Fullscreen
vim.g.neovide_fullscreen = false

-- Remember window size
vim.g.neovide_remember_window_size = true

-- Scale (zoom)
vim.g.neovide_scale_factor = 1.0

-- Progress bar
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_progress_bar_height = 5.0
vim.g.neovide_progress_bar_animation_speed = 200.0
vim.g.neovide_progress_bar_hide_delay = 0.2

vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_theme = "auto"

vim.g.neovide_refresh_rate_idle = 5
vim.g.neovide_refresh_rate = 120

vim.g.neovide_profiler = false

vim.g.neovide_cursor_smooth_blink = true

-- Keymaps for clipboard (Ctrl+Shift+C, Ctrl+Shift+V)
-- vim.keymap.set({ "n", "v" }, "<C-S-c>", '"+y', { desc = "Copy to clipboard" })
-- vim.keymap.set({ "n", "v" }, "<C-S-v>", '"+p', { desc = "Paste from clipboard" })
-- vim.keymap.set("i", "<C-S-v>", "<C-r>+", { desc = "Paste from clipboard" })
-- vim.keymap.set("c", "<C-S-v>", "<C-r>+", { desc = "Paste from clipboard" })
--
-- -- Toggle fullscreen
vim.keymap.set("n", "<C-a>f", function()
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, { desc = "Toggle fullscreen" })
--
-- -- Toggle title bar
-- vim.keymap.set("n", "<C-a>b", function()
-- 	vim.g.neovide_title_hidden = not vim.g.neovide_title_hidden
-- end, { desc = "Toggle title bar" })
--
-- -- Scale (zoom in/out) - giống browser
vim.keymap.set("n", "<C-=>", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
end, { desc = "Zoom in" })

vim.keymap.set("n", "<C-->", function()
	vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
end, { desc = "Zoom out" })

vim.keymap.set("n", "<C-0>", function()
	vim.g.neovide_scale_factor = 1.0
end, { desc = "Reset zoom" })
--
-- -- ============================================
-- -- TERMINAL MULTIPLEXER (TMUX-LIKE)
-- -- ============================================
--
-- -- Always show tabline in Neovide
-- vim.o.showtabline = 2
--
-- -- Window navigation (không cần prefix)
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down window" })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up window" })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
--
-- -- Terminal mode: Window navigation
-- vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left window" })
-- vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to down window" })
-- vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to up window" })
-- vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right window" })
--
-- -- Tmux-like keymaps với prefix <C-a>
-- vim.keymap.set("n", "<C-a>\\", "<cmd>vsplit | terminal<CR>", { desc = "Vsplit terminal" })
-- vim.keymap.set("n", "<C-a>-", "<cmd>split | terminal<CR>", { desc = "Split terminal" })
-- vim.keymap.set("n", "<C-a>c", "<cmd>tabnew | terminal<CR>", { desc = "New tab terminal" })
-- vim.keymap.set("n", "<C-a>t", function()
-- 	Snacks.terminal.toggle()
-- end, { desc = "Float terminal" })
-- vim.keymap.set("n", "<C-a>m", function()
-- 	require("mini.misc").zoom()
-- end, { desc = "Zoom pane" })
-- vim.keymap.set("n", "<C-a>x", function()
-- 	local buffers_in_tab = {}
-- 	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
-- 		local buf = vim.api.nvim_win_get_buf(win)
-- 		buffers_in_tab[buf] = true
-- 	end
-- 	if vim.fn.tabpagenr("$") > 1 then
-- 		vim.cmd("tabclose")
-- 		for buf, _ in pairs(buffers_in_tab) do
-- 			if vim.api.nvim_buf_is_valid(buf) then
-- 				pcall(vim.api.nvim_buf_delete, buf, { force = true })
-- 			end
-- 		end
-- 	else
-- 		vim.notify("Cannot close the last tab", vim.log.levels.WARN)
-- 	end
-- end, { desc = "Close tab with all buffers" })
--
-- -- Resize với prefix <C-a>
-- vim.keymap.set("n", "<C-a>h", "<cmd>vertical resize -5<CR>", { desc = "Resize left" })
-- vim.keymap.set("n", "<C-a>l", "<cmd>vertical resize +5<CR>", { desc = "Resize right" })
-- vim.keymap.set("n", "<C-a>j", "<cmd>resize -5<CR>", { desc = "Resize down" })
-- vim.keymap.set("n", "<C-a>k", "<cmd>resize +5<CR>", { desc = "Resize up" })
--
-- -- Tab navigation <C-a>1-9
-- for i = 1, 9 do
-- 	vim.keymap.set("n", "<C-a>" .. i, i .. "gt", { desc = "Go to tab " .. i })
-- end
--
-- -- Terminal mode: Tmux-like keymaps
-- vim.keymap.set("t", "<C-a>\\", [[<C-\><C-n><cmd>vsplit | terminal<CR>]], { desc = "Vsplit terminal" })
-- vim.keymap.set("t", "<C-a>-", [[<C-\><C-n><cmd>split | terminal<CR>]], { desc = "Split terminal" })
-- vim.keymap.set("t", "<C-a>c", [[<C-\><C-n><cmd>tabnew | terminal<CR>]], { desc = "New tab terminal" })
-- vim.keymap.set("t", "<C-a>t", function()
-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
-- 	vim.schedule(function()
-- 		Snacks.terminal.toggle()
-- 	end)
-- end, { desc = "Float terminal" })
-- vim.keymap.set("t", "<C-a>m", [[<C-\><C-n><cmd>lua require("mini.misc").zoom()<CR>]], { desc = "Zoom pane" })
-- vim.keymap.set("t", "<C-a>x", function()
-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
-- 	vim.schedule(function()
-- 		local buffers_in_tab = {}
-- 		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
-- 			local buf = vim.api.nvim_win_get_buf(win)
-- 			buffers_in_tab[buf] = true
-- 		end
-- 		if vim.fn.tabpagenr("$") > 1 then
-- 			vim.cmd("tabclose")
-- 			for buf, _ in pairs(buffers_in_tab) do
-- 				if vim.api.nvim_buf_is_valid(buf) then
-- 					pcall(vim.api.nvim_buf_delete, buf, { force = true })
-- 				end
-- 			end
-- 		else
-- 			vim.notify("Cannot close the last tab", vim.log.levels.WARN)
-- 		end
-- 	end)
-- end, { desc = "Close tab with all buffers" })
--
-- -- Terminal mode: Resize
-- vim.keymap.set("t", "<C-a>h", [[<C-\><C-n><cmd>vertical resize -5<CR>]], { desc = "Resize left" })
-- vim.keymap.set("t", "<C-a>l", [[<C-\><C-n><cmd>vertical resize +5<CR>]], { desc = "Resize right" })
-- vim.keymap.set("t", "<C-a>j", [[<C-\><C-n><cmd>resize -5<CR>]], { desc = "Resize down" })
-- vim.keymap.set("t", "<C-a>k", [[<C-\><C-n><cmd>resize +5<CR>]], { desc = "Resize up" })
--
-- -- Terminal mode: Tab navigation
-- for i = 1, 9 do
-- 	vim.keymap.set("t", "<C-a>" .. i, [[<C-\><C-n>]] .. i .. "gt", { desc = "Go to tab " .. i })
-- end
--
-- -- ============================================
-- -- PROJECT TAB MANAGEMENT
-- -- ============================================
-- local function open_folder_in_new_tab()
-- 	require("telescope.builtin").find_files({
-- 		find_command = { "fd", "--type", "d", "--max-depth", "2" },
-- 		cwd = "~",
-- 		prompt_title = "Select Project Folder",
-- 		attach_mappings = function(prompt_bufnr, map)
-- 			local actions = require("telescope.actions")
-- 			local action_state = require("telescope.actions.state")
--
-- 			local function open_in_tab()
-- 				local entry = action_state.get_selected_entry()
-- 				actions.close(prompt_bufnr)
-- 				if entry then
-- 					local path = entry.path or entry.value
-- 					vim.cmd("tabnew")
-- 					vim.cmd("tcd " .. vim.fn.fnameescape(path))
-- 				end
-- 			end
--
-- 			map("i", "<CR>", open_in_tab)
-- 			map("n", "<CR>", open_in_tab)
-- 			return true
-- 		end,
-- 	})
-- end
--
-- -- Keymap: New tab with different project root
-- vim.keymap.set("n", "<C-a>C", open_folder_in_new_tab, { desc = "New tab with project root" })
-- vim.keymap.set("t", "<C-a>C", function()
-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
-- 	vim.schedule(open_folder_in_new_tab)
-- end, { desc = "New tab with project root" })
--
-- -- ============================================
-- -- TAB-LOCAL CWD SYNC
-- -- ============================================
-- vim.api.nvim_create_autocmd("TabEnter", {
-- 	group = vim.api.nvim_create_augroup("neovide_tab_cwd_sync", { clear = true }),
-- 	callback = function()
-- 		local tab_cwd = vim.fn.getcwd(-1, 0)
-- 		vim.cmd("lcd " .. vim.fn.fnameescape(tab_cwd))
-- 	end,
-- })
