local M = {}

local function augroup(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

function M.setup()
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
		group = augroup("no_auto_comment"),
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
end

return M
