return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	config = function()
		-- The new nvim-treesitter setup() only accepts install_dir.
		-- ensure_installed/highlight/indent/auto_install are silently ignored.
		-- Use install() directly to actually install parsers.
		require("nvim-treesitter").install({
			"vimdoc",
			"markdown",
			"lua",
			"javascript",
			"scss",
			"typescript",
			"tsx",
			"html",
			"css",
			"angular",
			"python",
			"json",
			"jsonc",
			"yaml",
			"graphql",
			"bash",
		})
	end,
}
