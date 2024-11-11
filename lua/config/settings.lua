vim.opt.tabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true

vim.opt.number=true
vim.opt.relativenumber=true

vim.opt.cursorline=true

vim.wo.signcolumn="yes"

vim.o.scrolloff = 8

vim.opt.splitright = true

vim.g.loaded_netrw=1
vim.g.loaded_netrwPlugin=1

vim.opt.termguicolors=true

-- remove the underline from the highlight when doing incremental search
vim.cmd [[highlight IncSearch cterm=NONE gui=NONE]]

-- make the background transparent
vim.cmd [[highlight Normal guibg=NONE ctermbg=NONE]]

-- DapBreakpoint customization
vim.api.nvim_set_hl(0, "white",   { fg = "#ECEFF4" })
vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0})
vim.fn.sign_define('DapBreakpoint', { text='•',  texthl = "white", linehl='DapBreakpoint', numhl='DapBreakpoint' })

-- Highlight the yanked selection
vim.api.nvim_create_autocmd('TextYankPost', {

    group = vim.api.nvim_create_augroup('highlight-group', { clear = true }),

    callback = function()
        vim.highlight.on_yank()
    end
})

-- Fixing the popup windows theme in the nord theme
vim.cmd [[
    highlight NormalFloat guibg=#3B4252 guifg=#D8DEE9  
    highlight FloatBorder guifg=#81A1C1 guibg=#3B4252 
    highlight Pmenu guibg=#434C5E guifg=#D8DEE9      
    highlight PmenuSel guibg=#5E81AC guifg=#ECEFF4  
]]

-- run clang format on cpp files
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.cpp,*.h",
    callback = function()
        vim.cmd("silent! ClangFormat")
    end,
})
