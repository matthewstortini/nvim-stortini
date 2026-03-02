return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
			local mr = require("mason-registry")
			mr.refresh(function()
				for _, name in ipairs({
					"stylua",
					"clang-format",
				}) do
					local ok, pkg = pcall(mr.get_package, name)
					if ok and not pkg:is_installed() then
						pkg:install()
					end
				end
			end)
		end,
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
				},
			})
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			-- LSP keymaps and commands
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true }

					vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>ld", function()
						vim.diagnostic.open_float(0, { scope = "cursor" })
					end, opts)
				end,
			})
      -- Turn diagnostics off when a buffer is first created/opened
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
        callback = function(args)
          vim.diagnostic.enable(false, { bufnr = args.buf })
        end,
      })
      -- Toggle buffer diagnsotics on/off
      vim.keymap.set("n", "<leader>td", function()
        local bufnr = 0 -- current buffer
        local enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
        vim.diagnostic.enable(not enabled, { bufnr = bufnr })
      end)

			-- lua_ls setup
			vim.lsp.config["lua_ls"] = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			}

			-- C / C++ setup
			vim.lsp.config["clangd"] = {
				cmd = { "clangd" },
				filetypes = { "c", "cpp", "objc", "objcpp" },
				root_markers = {
					"compile_commands.json",
					"compile_flags.txt",
					".git",
				},
			}
		end,
	},
}
