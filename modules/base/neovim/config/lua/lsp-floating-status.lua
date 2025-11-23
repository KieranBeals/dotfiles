local lsp_status = require('lsp-status')
local M = {}
local win_id = nil

M.show_status = function()
	local status_text = lsp_status.status()
	if status_text == "" then
		if win_id and vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_win_hide(win_id)
		end
		return
	end

	local width = vim.api.nvim_get_option('columns')
	local height = 1
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = vim.api.nvim_get_option('lines') - vim.api.nvim_get_option('cmdheight') - 1,
		col = 0,
		style = "minimal",
		border = "none",
	}

	if not win_id or not vim.api.nvim_win_is_valid(win_id) then
		local buf = vim.api.nvim_create_buf(false, true)
		win_id = vim.api.nvim_open_win(buf, false, opts)
		vim.api.nvim_set_option_value('winhighlight', 'Normal:Pmenu', { win = win_id })
	end

	vim.api.nvim_buf_set_lines(vim.api.nvim_win_get_buf(win_id), 0, -1, false, { status_text })
	vim.api.nvim_win_set_config(win_id, opts)
	vim.api.nvim_win_show(win_id)
end

return M
