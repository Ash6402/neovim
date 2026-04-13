vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FileType" }, {
  pattern = "*",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    
    if ft ~= "harpoon" then
      return
    end

    vim.defer_fn(function()
      local ok, harpoon = pcall(require, "harpoon")
      if not ok then return end

      vim.keymap.set("n", "<C-v>", function()
        harpoon.ui:select_menu_item({ vsplit = true })
      end, { buffer = args.buf, silent = true, noremap = false })

      vim.keymap.set("n", "<C-x>", function()
        harpoon.ui:select_menu_item({ split = true })
      end, { buffer = args.buf, silent = true, noremap = false })
    end, 100)
  end,
  group = vim.api.nvim_create_augroup("harpoon_menu_keymaps", { clear = true }),
})
