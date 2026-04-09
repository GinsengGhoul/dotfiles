vim.g.mapleader = " "
local keymap = vim.keymap -- for conciseness

-- keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- make dd actually delete xx will cut instead
keymap.set("n", "dd", '"_dd', { noremap = true })
keymap.set("n", "xx", "dd", { noremap = true })
-- go to end of line using ff and ;;
keymap.set("n", ";;", "$", { noremap = true })
keymap.set("n", "ff", "0", { noremap = true })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<F4>", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>e", ":CHADopen<CR>", { desc = "Clear search highlights" })

-- format
keymap.set("n", "<leader>f", function()
	require("conform").format({ async = false })
end, { desc = "format file" })

vim.keymap.set({ "n", "v" }, "=", function()
	local mode = vim.api.nvim_get_mode().mode
	local is_visual = mode:match("[vV\22]")

	local start_line, end_line
	if is_visual then
		start_line = vim.fn.line("v")
		end_line = vim.fn.line(".")
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end
		-- Force exit visual mode so the -- VISUAL -- label clears
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	else
		start_line = 1
		end_line = vim.api.nvim_buf_line_count(0)
	end

	local line_count = end_line - start_line + 1

	require("conform").format({
		lsp_fallback = true,
		range = is_visual and {
			["start"] = { start_line, 0 },
			["end"] = { end_line, 0 },
		} or nil,
	}, function(err)
		if not err then
			-- We use schedule to ensure the print happens after the mode switch is processed
			vim.schedule(function()
				vim.cmd("echo '" .. line_count .. " lines formatted'")
			end)
		end
	end)
end, { desc = "Format with line count" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>h", ":wincmd h<CR>", { desc = "move to window on left" })
keymap.set("n", "<leader>j", ":wincmd j<CR>", { desc = "move to window on down" })
keymap.set("n", "<leader>k", ":wincmd k<CR>", { desc = "move to window on up" })
keymap.set("n", "<leader>l", ":wincmd l<CR>", { desc = "move to window on right" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
