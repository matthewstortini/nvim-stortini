return {
  {
    "mason-org/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
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

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, opts)
        end,
      })

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
