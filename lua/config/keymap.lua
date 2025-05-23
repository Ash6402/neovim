vim.g.mapleader=" "
vim.g.maplocalleader=","

-- keymaps for nvim-tree
vim.keymap.set("n", "<leader>pv", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>pF", "<cmd>NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>pf", "<cmd>NvimTreeFocus<CR>")

-- keymap to remove the highlight on the searched text
vim.keymap.set("n", "<ESC>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keymaps to easily switch between multiple windows
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- adding a newline while in normal mode
vim.keymap.set("n", "<leader>o", "o<Esc>", {desc = "adding a new line below"})
vim.keymap.set("n", "<leader>O", "O<Esc>", {desc = "adding a new line above"})

-------------------------------------------------------------------------
--- Disabling the arrow keys to get rid of the bad habbit
-------------------------------------------------------------------------
vim.keymap.set({ 'n', 'i' }, '<Up>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i' }, '<Down>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i' }, '<Left>', '<Nop>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'i' }, '<Right>', '<Nop>', { noremap = true, silent = true })

-- keymaps to dragging whole selections up and down
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>bc", function()
    local activesBuffers = vim.fn.bufnr('%')
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if buffer ~= activesBuffers and vim.api.nvim_buf_is_loaded(buffer) then
            if vim.bo[buffer].modified == false then
                vim.api.nvim_buf_delete(buffer, {force = false})
            end
        end
    end
    vim.notify("closed all saved, non-active buffers", vim.log.levels.INFO, { timeout = 1500})
end
)

vim.keymap.set("n", "<leader>p{", function()
        vim.cmd("%!prettierd --stdin-filepath % 2>/dev/null")
end, {desc = "Run Prettier Formatting"})
