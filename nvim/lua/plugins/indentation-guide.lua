return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}

			local hooks = require("ibl.hooks")

			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#f2a1a8", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#f4d79c", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#9ccaf3", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#f0b893", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#b6e0a0", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#d3a8f0", nocombine = true })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#9adfe0", nocombine = true })
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#181b21" })
			end)

			require("ibl").setup({
				indent = {
					char = "┆",
					highlight = highlight,
				},
				scope = { enabled = false },
				whitespace = { remove_blankline_trail = false },
			})

			vim.opt.cursorline = true
		end,
	},
}
