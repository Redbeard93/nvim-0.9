local config = require("V9.config")
local home = vim.loop.os_homedir()

require("lazy").setup({

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
  },
  {
    "williamboman/mason.nvim",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "VeryLazy", "BufNewFile", "BufReadPost" },
    config = function()
      require("V9.lsp")
    end,
  },

  -- 代码片段
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  -- LuaSnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    build = "make install_jsregexp",
    config = function()
      require("V9.plugins.config.luasnip")
    end,
  },
  {
    "saadparwaiz1/cmp_luasnip",
    dependencies = { "L3MON4D3/LuaSnip" },
    lazy = true,
  },
  -- lspkind
  {
    "onsails/lspkind-nvim",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("lspkind").init({
        -- preset = "codicons",
        symbol_map = {
          Copilot = "",
        },
      })
      vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    end,
  },
  -- nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "VeryLazy" },
    keys = { ":", "/", "?" },
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind-nvim",
      "rcarriga/cmp-dap",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
    },
    lazy = true,
    config = function()
      require("V9.plugins.config.nvim-cmp")
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true,
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true,
  },
  {
    "hrsh7th/cmp-path",
    lazy = true,
  },
  {
    "rcarriga/cmp-dap",
    lazy = true,
  },
  {
    "hrsh7th/cmp-nvim-lsp-document-symbol",
    lazy = true,
  },

  -- using packer.nvim
 -- {
 --   "akinsho/bufferline.nvim",
 --   version = "*",
 --   event = { "UIEnter" },
 --   dependencies = { "nvim-tree/nvim-web-devicons" },
 --   config = function()
 --     require("V9.plugins.config.bufferline")
 --   end,
 -- },
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" },
  },

  -- treesitter (新增)
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "VeryLazy", "BufNewFile", "BufReadPost" },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "markdown",
        },
        sync_install = false,
        ignore_install = {},

        highlight = {
          enable = true,
          disable = {},
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = { query = "@class.outer", desc = "Next class start" },
              ["]o"] = "@loop.*",
              ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
              ["[o"] = "@loop.*",
              ["[s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
              ["[z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
            goto_next = {
              ["]d"] = "@conditional.outer",
            },
            goto_previous = {
              ["[d"] = "@conditional.outer",
            },
          },
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
              ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
            },
            selection_modes = {
              ["@parameter.outer"] = "v", -- charwise
              ["@function.outer"] = "V", -- linewise
              ["@class.outer"] = "<c-v>", -- blockwise
            },
            include_surrounding_whitespace = false,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
      -- 开启 Folding see nvim-ufo
      -- vim.wo.foldmethod = "expr"
      -- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "VeryLazy", "BufNewFile", "BufReadPost" },
  },

  -- java
  {
    "mfussenegger/nvim-jdtls",
    lazy = true,
    ft = "java",
  },
  {
    "scalameta/nvim-metals",
    lazy = true,
    ft = "scala",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- debug
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("V9.dap")
      -- require("telescope").load_extension("dap")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    lazy = true,
    dependencies = { "mfussenegger/nvim-dap" },
    event = { "VeryLazy" },
    config = function()
      require("V9.plugins.config.nvim-dap-ui")
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = true,
    event = { "VeryLazy" },
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("nvim-dap-virtual-text").setup({})
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    lazy = true,
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup(config.env.py_bin)
    end,
  },
  {
    "sakhnik/nvim-gdb",
    lazy = true,
    cmd = {
      "GdbStart",
      "GdbStartLLDB",
      "GdbStartPDB",
      "GdbStartBashDB",
      "GdbStartRR",
    },
    init = function()
      vim.g.nvimgdb_disable_start_keymaps = 1
      vim.g.nvimgdb_use_find_executables = 0
      vim.g.nvimgdb_use_cmake_to_find_executables = 0
    end,
    config = function() end,
    build = ":!./install.sh",
  },

  -- 搜索插件
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = { "VeryLazy" },
    cmd = { "Telescope" },
    config = function()
      require("V9.plugins.config.telescope")
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
  },

  {
    "LinArcX/telescope-env.nvim",
    lazy = true,
  },
  -- 项目管理
  {
    "nvim-telescope/telescope-project.nvim",
    lazy = true,
  },

  -- git
  {
    "tpope/vim-fugitive",
    lazy = true,
    cmd = { "Git" },
  },
  {
    "sindrets/diffview.nvim",
    layz = true,
    cmd = {
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewLog",
      "DiffviewOpen",
      "DiffviewRefresh",
      "DiffviewToggleFiles",
    },
    config = function()
      require("diffview").setup({})
    end,
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    cmd = { "Neogit" },
    dependencies = { "sindrets/diffview.nvim" },
    config = function()
      require("V9.plugins.config.neogit")
    end,
  },

  -- git edit 状态显示插件
  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = { "VeryLazy", "BufReadPost" },
    config = function()
      require("V9.plugins.config.gitsigns-nvim")
    end,
  },

  -- 浮动窗口插件
  {
    "akinsho/toggleterm.nvim",
    lazy = true,
    version = "*",
    cmd = { "ToggleTerm" },
    config = function()
      require("toggleterm").setup({
        shade_terminals = true,
        direction = "horizontal",
        close_on_exit = true,
        float_opts = {
          border = "single",
        },
      })
    end,
  },

  -- 异步任务执行插件
--  {
--    "jedrzejboczar/toggletasks.nvim",
--    lazy = true,
--    dependencies = { "akinsho/toggleterm.nvim" },
--    config = function()
--      require("toggletasks").setup({
--        search_paths = {
--          ".tasks",
--          ".toggletasks",
--          ".nvim/toggletasks",
--          ".nvim/tasks",
--        },
--        toggleterm = {
--          close_on_exit = true,
--        },
--      })
--
--      require("telescope").load_extension("toggletasks")
--    end,
--  },

  -- 多光标插件
  {
    "mg979/vim-visual-multi",
    lazy = true,
    keys = {
      { "<C-n>", mode = { "n", "x" }, desc = "visual multi" },
    },
  },

  -- blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = true,
    event = { "UIEnter" },
    config = function()
      require("V9.plugins.config.indent-blankline")
    end,
  },

  -- 大纲插件
  {
    "simrat39/symbols-outline.nvim",
    lazy = true,
    cmd = {
      "SymbolsOutline",
      "SymbolsOutlineOpen",
      "SymbolsOutlineClose",
    },
    config = function()
      require("V9.plugins.config.symbols-outline")
    end,
  },

  -- 消息通知
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out",
        on_open = nil,
        on_close = nil,
        render = "default",
        timeout = 3000,
        minimum_width = 50,
        background_colour = "#000000",
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })

      vim.notify = notify
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
    config = function()
      require("fidget").setup({
        window = {
          relative = "win",
          -- 更改blend数值后要:PackerSync才能起效
          blend = 0,
          zindex = nil,
          border = "none",
        }
      })
    end,

  },
  {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "notify", -- default view for messages
          view_error = "notify", -- view for errors
          view_warn = "notify", -- view for warnings
          view_history = "messages", -- view for :messages
          view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
            ["vim.lsp.util.stylize_markdown"] = false,
            ["cmp.entry.get_documentation"] = false,
          },
          hover = {
            enabled = false,
          },
          signature = {
            enabled = false,
          },
        },
      })
      require("telescope").load_extension("noice")
    end,
  },

  -- 颜色显示
  {
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "InsertEnter", "VeryLazy" },
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = false, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = false, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = false,
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
      })
    end,
  },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = { "n" }, desc = "Comment" },
      { "gc", mode = { "x" }, desc = "Comment" },
    },
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "danymat/neogen",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("neogen").setup({
        snippet_engine = "luasnip",
        enabled = true,
        input_after_comment = true,
      })
    end,
  },

  -- markdown 预览插件
  {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    config = function()
      vim.fn["mkdp#util#install"]()
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_theme = "dark"
    end,
  },
  -- markdown cli 预览插件
  {
    "ellisonleao/glow.nvim",
    lazy = true,
    ft = "markdown",
    config = function()
      require("glow").setup({
        border = "",
        pager = false,
        style = "dark",
        width = 80,
        height = 129.5,
        width_ratio = 0.618,
        height_ratio = 0.618,
      })
    end,
  },
  -- pandoc 命令插件(用于md转pdf)
  {
    "aspeddro/pandoc.nvim",
    lazy = true,
    ft = "markdown",
    config = function()
      require("V9.plugins.config.pandoc")
    end,
  },

  -- 快捷键查看
  {
    "folke/which-key.nvim",
    lazy = true,
    event = { "VeryLazy" },
    config = function()
      require("V9.plugins.config.which-key")
    end,
  },

  -- 仪表盘
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
        " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
        " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
        " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
        " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
        " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
      }
      local opt = { noremap = true, silent = true }
      dashboard.section.buttons.val = {
        dashboard.button("<leader>  ff", "󰈞  Find File", ":Telescope find_files<CR>", opt),
        dashboard.button("<leader>  fg", "󰈭  Find Word  ", ":Telescope live_grep<CR>", opt),
        dashboard.button(
          "<leader>  fp",
          "  Recent Projects",
          ":lua require'telescope'.extensions.project.project{ display_type = 'full' }<CR>",
          opt
        ),
        dashboard.button("<leader>  fo", "  Recent File", ":Telescope oldfiles<CR>", opt),
        dashboard.button("<leader>  ns", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>", opt),
        dashboard.button("<leader>  q ", "󰅙  Quit NVIM", ":qa<CR>", opt),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- 翻译插件
  {
    "uga-rosa/translate.nvim",
    lazy = true,
    cmd = "Translate",
    config = function()
      require("translate").setup({
        default = {
          command = "translate_shell",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      })
    end,
  },
  -- StartupTime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },
  -- 自动对齐插件
  {
    "junegunn/vim-easy-align",
    lazy = true,
    cmd = "EasyAlign",
  },

  -- 表格模式插件
  {
    "dhruvasagar/vim-table-mode",
    lazy = true,
    cmd = { "TableModeEnable" },
  },

  -- () 自动补全
  --{
  --  "windwp/nvim-autopairs",
  --  event = { "InsertEnter", "VeryLazy" },
  --  config = function()
  --    local autopairs = require("nvim-autopairs")
  --    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  --    autopairs.setup({})
  --    local cmp = require("cmp")
  --    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  --  end,
  --},

  -- 任务插件
  {
    "itchyny/calendar.vim",
    lazy = true,
    cmd = {
      "Calendar",
    },
  },

  -- rust
  {
    "simrat39/rust-tools.nvim",
    lazy = true,
  },

  -- 选中高亮插件
  {
    "RRethy/vim-illuminate",
    lazy = true,
    event = { "BufReadPost" },
    config = function()
      require("V9.plugins.config.vim-illuminate")
    end,
  },

  -- 查找替换
  {
    "windwp/nvim-spectre",
    lazy = true,
    config = function()
      require("spectre").setup()
    end,
  },

  -- ASCII 图
  {
    "jbyuki/venn.nvim",
    lazy = true,
    cmd = { "VBox" },
  },

  -- databases
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    lazy = true,
    dependencies = { "tpope/vim-dadbod" },
    cmd = {
      "DBUI",
      "DBUIToggle",
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    lazy = true,
    dependencies = { "tpope/vim-dadbod" },
    ft = { "sql", "mysql", "plsql" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("V9_vim_dadbod_completion", { clear = true }),
        pattern = { "sql", "mysql", "plsql" },
        callback = function(event)
          require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
        end,
      })
    end,
    config = function() end,
  },

  {
    "aklt/plantuml-syntax",
    lazy = true,
    ft = "plantuml",
  },

  -- 浏览器搜索
--  {
--    "lalitmee/browse.nvim",
--    lazy = true,
--    event = { "VeryLazy" },
--    cmd = {
--      "Browse",
--    },
--    config = function()
--      require("V9.plugins.config.browse-nvim")
--    end,
--  },

  -- 环绕输入
  {
    "kylechui/nvim-surround",
    lazy = true,
    version = "*",
    event = { "VeryLazy" },
    config = function()
      require("nvim-surround").setup({})
    end,
  },

  --  Create custom submodes and menus
--  {
--    "anuvyklack/hydra.nvim",
--    lazy = true,
--  },

  -- 笔记
  {
    "mickael-menu/zk-nvim",
    lazy = true,
    cmd = {
      "ZkIndex",
      "ZkNew",
      "ZkNotes",
    },
    config = function()
      require("V9.plugins.config.zk-nvim")
    end,
  },

  {
    "akinsho/flutter-tools.nvim",
    lazy = true,
    ft = { "dart" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("V9_FlutterOutlineToggle", { clear = true }),
        pattern = "dart",
        callback = function(event)
          vim.keymap.set("n", "<leader>o", "<CMD>FlutterOutlineToggle<CR>", { buffer = event.buf, silent = true })
        end,
      })
      vim.api.nvim_create_autocmd("BufNewFile", {
        group = vim.api.nvim_create_augroup("V9__FlutterOutlineToggle", { clear = true }),
        pattern = "Flutter Outline",
        callback = function(event)
          vim.keymap.set("n", "<leader>o", "<CMD>FlutterOutlineToggle<CR>", { buffer = event.buf, silent = true })
        end,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("V9.plugins.config.flutter-tools")
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    ft = {
      "typescript",
      "javascript",
      "lua",
      "c",
      "cpp",
      "go",
      "python",
      "java",
      "php",
      "ruby",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup({})
    end,
  },

  -- ui
  {
    "MunifTanjim/nui.nvim",
    lazy = true,
  },

  -- chatgpt
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "gpg --decrypt " .. home .. "/Documents/nvim_api/nvim_api.gpg",
        openai_params = {
          model = "gpt-3.5-turbo",
          frequency_penalty = 0,
          presence_penalty = 0,
          max_tokens = 300,
          temperature = 0,
          top_p = 1,
          n = 1,
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    },
  },
  {
    "folke/todo-comments.nvim",
    lazy = true,
    config = function()
      require("todo-comments").setup({})
    end,
  },
  -- {
  --   "zbirenbaum/copilot.lua",
  --   enabled = config.plugin.copilot.enable,
  --   lazy = true,
  --   cmd = "Copilot",
  --   config = function()
  --     require("copilot").setup({})
  --   end,
  -- },
  {
    "github/copilot.vim",
    enabled = config.plugin.copilot.enable,
    config = function()
      vim.g.copilot_enabled = true
      vim.g.copilot_no_tab_map = true
      vim.cmd('imap <silent><script><expr> <C-C> copilot#Accept("")')
      vim.cmd([[
			let g:copilot_filetypes = {
	       \ 'TelescopePrompt': v:false,
	     \ }
			]])
    end,
  },
}, {
  ui = {
    icons = {
      task = "✓ ",
    },
  },
})
