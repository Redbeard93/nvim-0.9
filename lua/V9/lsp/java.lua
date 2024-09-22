--export JAVA_HOME=/usr/lib/jvm/java-17-openjdk 							#JDK的主目录，建议使用JDK11，使用JDK8会报错
--PATH=$PATH:$JAVA_HOME/bin
--export JDTLS_HOME=$HOME/AppData/Local/nvim-data/mason/packages/jdtls		# 包含 plugin 和 configs 的目录，由jdt-language-server-xxx.tar.gz解压出的
--export WORKSPACE=$HOME/AppData/Local/nvim/workspace # 不设置则默认是$HOME/workspace
local M = {}
local status, jdtls = pcall(require, "jdtls")
if not status then
    vim.notify("jdtls is down!!!")
    return
end

local utils = require("V9.core.utils")
local maven = require("V9.core.utils.maven")

-- HOME DIRECTORY
local home = vim.loop.os_homedir()

-- PATH Of JAR PACKAGES Of JDTLS & DEBUGER & TEST From MASON
local JAR_PATH = (function()
  if utils.is_win then
    return home .. "/AppData/Local/nvim-data/mason/packages/"
  elseif utils.is_mac then
    return home .. "/.local/share/nvim/mason/packages/"
  else
    return home .. "/.local/share/nvim/mason/packages/"
  end
end)()

-- SYSTEM CONFIG OF JDTLS
local _config = (function()
  if utils.is_win then
    return "config_win"
  elseif utils.is_mac then
    return "config_mac"
  else
    return "config_linux"
  end
end)()

-- JAVA WORKSPACE
if utils.is_mac then
    WORKSPACE_PATH = home .. "/workspace/"
elseif utils.is_win then
    WORKSPACE_PATH = home .. "/projects/project-data/jdtls-workspace/"
else
    WORKSPACE_PATH = home .. "/.config/nvim/workspace/"
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = WORKSPACE_PATH .. project_name

local function lombok_jar()
  return JAR_PATH .. "jdtls/lombok.jar"
end

local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "-javaagent:" .. lombok_jar(),
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        vim.fn.glob(JAR_PATH .. "jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        JAR_PATH .. "jdtls/" .. _config,
        "-data",
        workspace_dir,
    },

    filetypes = {"java"},

    root_dir = root_dir,

    settings = {
        java = {
          -- From JAVAHELLO
          maxConcurrentBuilds = 8,
          project = {
            encoding = "UTF-8",
            resourceFilters = {
              "node_modules",
              ".git",
              ".idea",
            },
          },
          import = {
            exclusions = {
              "**/node_modules/**",
              "**/.metadata/**",
              "**/archetype-resources/**",
              "**/META-INF/maven/**",
              "**/.git/**",
              "**/.idea/**",
            },
          },
          maven = {
            downloadSources = true,
            updateSnapshots = true,
          },
          templates = {
            fileHeader = {
              "/**",
              " * ${type_name}",
              " * @author ${user}",
              " */",
            },
            typeComment = {
              "/**",
              " * ${type_name}",
              " * @author ${user}",
              " */",
            },
          },

          -- ORIGINAL
            eclipse = {
                downloadSources = true,
            },
            --maven = {
            --    downloadSources = true,
            --},
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            format = {
                enabled = true,
                -- settings = {
                --   profile = "asdf"
                -- }
            },
        }
    },

    signatureHelp = { enabled = true, description = { enabled = true, }, },
    completion = {
        favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
        },
    },
    extendedClientCapabilities = extendedClientCapabilities,
    contentProvider = { preferred = "fernflower" },
    sources = {
        organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
        },
    },
    codeGeneration = {
        toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        useBlocks = true,
    },
    flags = {
        allow_incremental_sync = true,
    },
    configuration = {
        maven={
            userSettings = maven.get_maven_settings(),
            globalSettings = maven.get_maven_settings(),

        },
        runtimes = {
          -- {
            --         name = "JavaSE-11",
            --         path = "/usr/lib/jvm/java-11-openjdk/",
            --     },
            -- {
              --         name = "JavaSE-17",
              --         path = "/usr/lib/jvm/java-17-openjdk/",
              --     },
            }
    };
--    init_options = {
--        bundles = bundles;
--    }
}

local bundles = {
  vim.fn.glob(JAR_PATH .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
};

vim.list_extend(bundles, vim.split(vim.fn.glob(JAR_PATH .. "java-test/extension/server/*.jar"),"\n"))

config['init_options'] = {
  bundles = bundles;
}
-- 在语言服务器附加到当前缓冲区之后
-- 使用 on_attach 函数仅映射以下键
config['on_attach'] = function(client, buffer)

  -- if client.name == "jdt.ls"  then
  --     vim.notify('jdt.ls at your service!')
  -- end

  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.setup').add_commands()
 -- require('jdtls.dap').setup_dap_main_class_configs({ verbose = true})

  -- Mappings.
  require("V9.core.keybindings").maplsp(client, buffer)

  local opts = { silent = true, buffer = buffer }

  vim.keymap.set("n", "<leader>dc", jdtls.test_class, opts)
  vim.keymap.set("n", "<leader>dm", jdtls.test_nearest_method, opts)
  vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
  vim.keymap.set("v", "crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
  vim.keymap.set("n", "crc", jdtls.extract_constant, opts)

  local create_command = vim.api.nvim_buf_create_user_command
  create_command(buffer, "OI", require("jdtls").organize_imports, {
    nargs = 0,
  })
end
-- cmp-nvim-lsp增强补全体验
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
  return
end

capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
config.capabilities = capabilities;

config.handlers = {}
config.handlers["language/status"] = function(_, s)
  -- 使用 progress 查看状态
  -- print("jdtls " .. s.type .. ": " .. s.message)
  if "ServiceReady" == s.type then
    require("jdtls.dap").setup_dap_main_class_configs({ verbose = true })
  end
end

M.start = function ()
  jdtls.start_or_attach(config)
end

M.setup = function()
  vim.g.jdtls_dap_main_class_config_init = true
  -- au BufReadCmd jdt://* lua require('jdtls').open_jdt_link(vim.fn.expand('<amatch>'))
  -- command! JdtWipeDataAndRestart lua require('jdtls.setup').wipe_data_and_restart()
  -- command! JdtShowLogs lua require('jdtls.setup').show_logs()
  vim.api.nvim_create_autocmd({ "BufReadCmd" }, {
    pattern = "jdt://*",
    callback = function(e)
      require("jdtls").open_jdt_link(e.file)
    end,
  })
  vim.api.nvim_create_user_command("JdtWipeDataAndRestart", "lua require('jdtls.setup').wipe_data_and_restart()", {})
  vim.api.nvim_create_user_command("JdtShowLogs", "lua require('jdtls.setup').show_logs()", {})

  local group = vim.api.nvim_create_augroup("V9_jdtls_java", { clear = true })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = { "java" },
    desc = "jdtls",
    callback = function(e)
      -- vim.notify("load: " .. o.buf, vim.log.levels.INFO)
      -- print(vim.inspect(e))
      -- 忽略 telescope 预览的情况
      if e.file == "java" then
        -- ignore
      else
        M.start()
      end
    end,
  })
  return group
end

return M

