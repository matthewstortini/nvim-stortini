return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"lewis6991/gitsigns.nvim",
	},
	config = function()
		require("gitsigns").setup()

		local diag_status = function()
			return vim.diagnostic.is_enabled({ bufnr = 0 }) and "DIAG:ON" or "DIAG:OFF"
		end

		local full_path = function()
			local dir = vim.fn.expand("%:p:h")
			return vim.fn.fnamemodify(dir, ":~") .. "/"
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				always_divide_middle = true,
				globalstatus = false,
			},

			sections = {
				lualine_a = { "mode" },
				lualine_b = {},
				lualine_c = {
					"filename",
					"branch",
					{
						"diff",
						source = function()
							local gs = vim.b.gitsigns_status_dict
							if not gs then
								return nil
							end
							return {
								added = gs.added,
								modified = gs.changed,
								removed = gs.removed,
							}
						end,
					},
					"diagnostics",
				},

				lualine_x = {
					diag_status,
					"encoding",
					"fileformat",
					"filetype",
				},

				lualine_y = { "progress" },
				lualine_z = { "location" },
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					"filename",
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			-- second line showing full path
			winbar = {
				lualine_a = { full_path },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},

			inactive_winbar = {
				lualine_a = { full_path },
			},
		})
	end,
}
