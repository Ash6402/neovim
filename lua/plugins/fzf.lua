return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostic disable: missing-fields
    opts = {},
    ---@diagnostic enable: missing-fields
    config = function()
        local fzf = require('fzf-lua')

        local function get_hl_color(group, attr)
            local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
            local color = hl[attr]
            if color then
                return string.format('#%06x', color)
            end
        end

        vim.api.nvim_create_autocmd('VimEnter', {
            callback = function()
                fzf.setup({
                    winopts = {
                        height  = 0.85,
                        width   = 0.80,
                        row     = 0.35,
                        col     = 0.50,
                        border  = 'rounded',
                    },
                    defaults = {
                        file_ignore_patterns = { 'node_modules', 'dist' },
                    },
                    keymap = {
                        builtin = {
                            ['<C-q>'] = 'select-all+accept',
                        },
                    },
                    fzf_opts = {
                        ['--color'] = string.format(
                            'hl:%s:bold,hl+:%s:bold:reverse',
                            get_hl_color('Search', 'bg'),
                            get_hl_color('Search', 'bg')
                        ),
                    },
                })
            end
        })

        -- Same keymaps as your telescope config
        vim.keymap.set('n', '<leader>ff', fzf.files,     { desc = 'FZF find files' })
        vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'FZF live grep' })
        vim.keymap.set('n', '<leader>fb', fzf.buffers,   { desc = 'FZF buffers' })
        vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'FZF help tags' })
    end
}
