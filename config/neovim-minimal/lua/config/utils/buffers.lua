local M = {}

function M.delete(bufnr)
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

function M.delete_others()
	local current = vim.api.nvim_get_current_buf()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if b ~= current and vim.bo[b].buflisted then
			M.delete(b)
		end
	end
end

function M.delete_all()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[b].buflisted then
			M.delete(b)
		end
	end
end

return M
