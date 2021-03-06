
    vim.fn.sign_define("LspDiagnosticsSignError",
                       {text = "◉", texthl = "LspDiagnosticsError"})
    vim.fn.sign_define("LspDiagnosticsSignWarning",
                       {text = "•", texthl = "LspDiagnosticsWarning"})
    vim.fn.sign_define("LspDiagnosticsSignInformation",
                       {text = "•", texthl = "LspDiagnosticsInformation"})
    vim.fn.sign_define("LspDiagnosticsSignHint",
                       {text = "H", texthl = "LspDiagnosticsHint"})

    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            signs = true,
            virtual_text = {spacing = 4, prefix = ''},
            -- delay update
            update_in_insert = false
        })

    -- Handle formatting in a smarter way
    -- If the buffer has been edited before formatting has completed, do not try to 
    -- apply the changes
    -- vim.lsp.handlers['textDocument/formatting'] =
    --     function(err, _, result, _, bufnr)
    --         if err ~= nil or result == nil then return end

    --         -- If the buffer hasn't been modified before the formatting has finished, 
    --         -- update the buffer
    --         if not vim.api.nvim_buf_get_option(bufnr, 'modified') then
    --             local view = vim.fn.winsaveview()
    --             vim.lsp.util.apply_text_edits(result, bufnr)
    --             vim.fn.winrestview(view)
    --             if bufnr == vim.api.nvim_get_current_buf() then
    --                 vim.api.nvim_command('noautocmd :update')

    --                 -- Trigger post-formatting autocommand which can be used to refresh 
    --                 -- gitgutter
    --                 vim.api.nvim_command(
    --                     'silent doautocmd <nomodeline> User FormatterPost')
    --             end
    --         end
    --     end


    local lspconfig = require'lspconfig'
    local lsp_status = require'lsp-status'
    lsp_status.register_progress()
    -- client log level
    vim.lsp.set_log_level('info')

    local on_attach = function(client, bufnr)
       require 'completion'
              local function buf_set_keymap(...)
            vim.api.nvim_buf_set_keymap(bufnr, ...)
        end
        local function buf_set_option(...)
            vim.api.nvim_buf_set_option(bufnr, ...)
        end

        -- omni completion source
        vim.bo.omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = {noremap = true, silent = true}
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>',
                       opts)
        buf_set_keymap('n', '<C-k>',
                       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>wa',
                       '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
        buf_set_keymap('n', '<space>wr',
                       '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
                       opts)
        buf_set_keymap('n', '<space>wl',
                       '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
                       opts)
        buf_set_keymap('n', '<space>D',
                       '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',
                       opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e',
                       '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',
                       opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',
                       opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',
                       opts)
        buf_set_keymap('n', '<space>q',
                       '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        vim.o.shortmess = vim.o.shortmess .. "c"

        -- Set some keybinds conditional on server capabilities
        if client.resolved_capabilities.document_formatting then
            buf_set_keymap("n", "<space>f",
                           "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        elseif client.resolved_capabilities.document_range_formatting then
            buf_set_keymap("n", "<space>f",
                           "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
        end

        -- Format on save
        if client.resolved_capabilities.document_formatting then
            vim.api.nvim_command [[augroup Format]]
            vim.api.nvim_command [[autocmd! * <buffer>]]
            vim.api
                .nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
            vim.api.nvim_command [[augroup END]]
        end

        -- Set autocommands conditional on server_capabilities
        if client.resolved_capabilities.document_highlight then
            require'lspconfig'.util.nvim_multiline_command [[
        :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
          autocmd!
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]]
        end

        print("LSP attached.")
    end
    -- define language servers
    lspconfig.pyls.setup {
        -- on_attach = require'completion'.on_attach,
        cmd = {"pyls", "--log-file", "/tmp/pyls.log", "--verbose"},
        settings = {
            pyls = {
                configurationSources = {"pycodestyle", "flake8"},
                plugins = {pyls_mypy = {enabled = true}}
            }
        }
    }
    -- lspconfig.vimls.setup {}
    -- lspconfig.jdtls.setup{}
    -- lspconfig.jsonls.setup {}
    lspconfig.tsserver.setup {
        on_attach = on_attach,
        root_dir = lspconfig.util
            .root_pattern("package.json", ".git/", ".zshrc"),
    }
        lspconfig.flow.setup {
        on_attach = on_attach,
        root_dir = lspconfig.util
            .root_pattern("package.json", ".git/", ".zshrc"),
    } 
