return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup({
            -- Install parsers for these languages
            ensure_installed = { "vimdoc", "markdown", "lua", "javascript", "scss","typescript", "tsx", "html", "css", "angular" },

            -- Enable Tree-sitter based highlighting
            highlight = {
                enable = true,
            },

            -- Enable Tree-sitter based indentation (optional)
            indent = {
                enable = true,
            },

            -- Enable rainbow parentheses (optional)
            rainbow = {
                enable = true,
                extended_mode = true,
            },

            modules = {},
            auto_install = true,
            sync_install = true,
            ignore_install = {},
        })
    end
}
