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
			javascript = { "prettierd", "prettier", stop_after_first = true },
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
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			clang_format = {
				prepend_args = {
					"-style={BasedOnStyle: Mozilla, ColumnLimit: 0}",
				},
			},
			shfmt = {
				prepend_args = { "--simplify", "--indent", "2" },
			},
			gg_fallback = {
				format = function(self, ctx, lines, callback)
					-- Save cursor position
					local view = vim.fn.winsaveview()

					-- Apply formatting using Neovim's built-in formatexpr
					vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
					vim.cmd("normal! gg=G")
					local formatted_lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)

					-- Restore cursor position
					vim.fn.winrestview(view)

					callback(nil, formatted_lines)
				end,
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
