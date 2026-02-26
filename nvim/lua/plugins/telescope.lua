return {
  "nvim-telescope/telescope.nvim",
  tag = "v0.2.1",
  url = "git@github.com:nvim-telescope/telescope.nvim.git",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local ts = require("telescope")
    local builtin = require("telescope.builtin")

    local h_pct = 1.0
    local w_pct = 1.0

    local fullscreen_setup = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      layout_strategy = "flex",
      layout_config = {
        flex = { flip_columns = 120 },
        horizontal = {
          mirror = false,
          prompt_position = "top",
          width = function(_, cols, _)
            return math.floor(cols * w_pct)
          end,
          height = function(_, _, rows)
            return math.floor(rows * h_pct)
          end,
          preview_cutoff = 10,
          preview_width = 0.55,
        },
        vertical = {
          mirror = true,
          prompt_position = "top",
          width = function(_, cols, _)
            return math.floor(cols * w_pct)
          end,
          height = function(_, _, rows)
            return math.floor(rows * h_pct)
          end,
          preview_cutoff = 10,
          preview_height = 0.55,
        },
      },
      preview = {
        treesitter = false,
      },
    }

    ts.setup({
      defaults = vim.tbl_extend("force", fullscreen_setup, {
        sorting_strategy = "ascending",
        path_display = { "filename_first" },
      }),

      pickers = {
        find_files = vim.tbl_extend("force", fullscreen_setup, {
          previewer = false,
        }),
        buffers = vim.tbl_extend("force", fullscreen_setup, {
          previewer = false,
          sort_lastused = true,
          ignore_current_buffer = true,
        }),
        live_grep = vim.tbl_extend("force", fullscreen_setup, {
          previewer = true,
        }),
      },

      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    ts.load_extension("fzf")

    local function buffer_dir()
      local dir = vim.fn.expand("%:p:h")
      if dir == "" then
        return vim.loop.cwd()
      end
      return dir
    end

    vim.keymap.set("n", "<leader>ff", function()
      builtin.find_files({
        cwd = vim.fn.input("Search dir: ", buffer_dir(), "dir"),
      })
    end)

    vim.keymap.set("n", "<leader>fg", function()
      builtin.live_grep({
        cwd = vim.fn.input("Search dir: ", buffer_dir(), "dir"),
      })
    end)

    vim.keymap.set("n", "<leader>fb", function()
      builtin.buffers({
        sort_lastused = true,
        ignore_current_buffer = true,
      })
    end)
  end,
}
