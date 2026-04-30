local function hasExt()
	local name = vim.api.nvim_buf_get_name(0)
	return name:match("%.[^./\\]+$") ~= nil
end

return {
	"stevearc/conform.nvim",
	enabled = hasExt(),
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "autopep8" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			java = { "clang-format" },
			javascript = { "clang-format" },
			json = { "clang-format" },
			objc = { "clang-format" },
			proto = { "clang-format" },
			cs = { "clang-format" },
			sh = { "shfmt" },
			["_"] = { "gg_fallback" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = function(bufnr)
			-- Only format if the file has an extension
			if vim.api.nvim_buf_get_name(bufnr):match("%.[^./\\]+$") then
				return { timeout_ms = 500 }
			end
		end,
		-- Customize formatters
		formatters = {
			autopep8 = {
				append_args = {
					"--max-line-length",
					"1023",
				},
			},
			clang_format = {
				append_args = {
					"-style='{ BasedOnStyle: Mozilla, ColumnLimit: 100 }'",
				},
			},
			shfmt = {
				prepend_args = { "--simplify", "--indent", "2" },
			},
			gg_fallback = {
				format = function(self, ctx, lines, callback)
					-- Save cursor position
					local view = vim.fn.winsaveview()

					local start_line = ctx.range and ctx.range.start[1] or 1
					local end_line = ctx.range and ctx.range["end"][1] or vim.api.nvim_buf_line_count(ctx.buf)

					-- Apply formatting using Neovim's built-in formatexpr
					vim.api.nvim_buf_call(ctx.buf, function()
						vim.cmd(string.format("silent! %d,%d=", start_line, end_line))
						-- Restore cursor position
						vim.fn.winrestview(view)
					end)

					local formatted_lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)
					callback(nil, formatted_lines)
				end,
				condition = function(self, ctx)
					return true
				end,
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
