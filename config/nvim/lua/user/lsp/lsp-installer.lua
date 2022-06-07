local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local servers = require 'user.lsp.lsp-list'.servers

--                            ╭────────────────────╮
--                            │ nvim-lsp-installer │
--                            ╰────────────────────╯

local settings = {
    ensure_installed = servers,
    -- automatic_installation = false,
    ui = {
        icons = {
            -- server_installed = "◍",
            -- server_pending = "◍",
            -- server_uninstalled = "◍", server_installed = "✓", server_pending = "➜",
            server_uninstalled = "✗",
        },
        keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
        },
    },

    log_level = vim.log.levels.INFO,
    -- max_concurrent_installers = 4,
    -- install_root_dir = path.concat { vim.fn.stdpath "data", "lsp_servers" },
}

lsp_installer.setup(settings)

--                                 ╭───────────╮
--                                 │ lspconfig │
--                                 ╰───────────╯

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    if server == "jsonls" then
        local jsonls_opts = require "user.lsp.settings.jsonls"
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    if server == "sumneko_lua" then
        local sumneko_opts = require "user.lsp.settings.sumneko_lua"
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
    end

    if server == "pyright" then
        local pyright_opts = require "user.lsp.settings.pyright"
        opts = vim.tbl_deep_extend("force", pyright_opts, opts)
    end

    if server == "solang" then
        local solang_opts = require "user.lsp.settings.solang"
        opts = vim.tbl_deep_extend("force", solang_opts, opts)
    end

    if server == "solc" then
        local solc_opts = require "user.lsp.settings.solc"
        opts = vim.tbl_deep_extend("force", solc_opts, opts)
    end

    if server == "emmet_ls" then
        local emmet_ls_opts = require "user.lsp.settings.emmet_ls"
        opts = vim.tbl_deep_extend("force", emmet_ls_opts, opts)
    end


    lspconfig[server].setup(opts)
end

-- TODO: add something to installer later
-- require("lspconfig").motoko.setup {}

lspconfig.tsserver.setup({
    -- Needed for inlayHints. Merge this table with your settings or copy
    -- it from the source if you want to add your own init_options.
    init_options = require("nvim-lsp-ts-utils").init_options,
    --
    on_attach = function(client, bufnr)
        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup({
            debug = false,
            disable_commands = false,
            enable_import_on_completion = false,

            -- import all
            import_all_timeout = 5000, -- ms
            -- lower numbers = higher priority
            import_all_priorities = {
                same_file = 1, -- add to existing import statement
                local_files = 2, -- git files or files with relative path markers
                buffer_content = 3, -- loaded buffer content
                buffers = 4, -- loaded buffer names
            },
            import_all_scan_buffers = 100,
            import_all_select_source = false,
            -- if false will avoid organizing imports
            always_organize_imports = true,

            -- filter diagnostics
            filter_out_diagnostics_by_severity = {},
            filter_out_diagnostics_by_code = {},

            -- inlay hints
            auto_inlay_hints = true,
            inlay_hints_highlight = "Comment",
            inlay_hints_priority = 200, -- priority of the hint extmarks
            inlay_hints_throttle = 150, -- throttle the inlay hint request
            inlay_hints_format = { -- format options for individual hint kind
                Type = {},
                Parameter = {},
                Enum = {},
                -- Example format customization for `Type` kind:
                -- Type = {
                --     highlight = "Comment",
                --     text = function(text)
                --         return "->" .. text:sub(2)
                --     end,
                -- },
            },

            -- update imports on file move
            update_imports_on_move = false,
            require_confirmation_on_move = false,
            watch_dir = nil,
        })

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        opts = { silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
    end,
})
