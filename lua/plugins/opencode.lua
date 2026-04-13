return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	lazy = true,
	keys = {
		{
			"<C-a>",
			mode = { "n", "x" },
			desc = "Ask opencode (with @this)",
			function()
				require("opencode").ask("@this: ", { submit = true })
			end,
		},
		{
			"<M-C-a>",
			mode = { "n", "x" },
			desc = "Ask opencode",
			function()
				require("opencode").ask("", { submit = true })
			end,
		},
		{
			"<C-x>",
			mode = { "n", "x" },
			desc = "Execute opencode action",
			function()
				require("opencode").select()
			end,
		},
		{
			"<leader>go",
			mode = { "n" },
			desc = "Toggle opencode",
			function()
				require("opencode").toggle()
			end,
		},
		{
			"go",
			mode = { "n", "x" },
			expr = true,
			desc = "Add range to opencode",
			function()
				return require("opencode").operator("@this ")
			end,
		},
		{
			"goo",
			mode = { "n" },
			desc = "Add line to opencode",
			function()
				return require("opencode").operator("@this ") .. "_"
			end,
		},
		{
			"<M-C-u>",
			mode = { "n", "t" },
			desc = "Scroll opencode up",
			function()
				require("opencode").command("session.half.page.up")
			end,
		},
		{
			"<M-C-d>",
			mode = { "n", "t" },
			desc = "Scroll opencode down",
			function()
				require("opencode").command("session.half.page.down")
			end,
		},
		{
			"+",
			"<C-a>",
			mode = { "n" },
			desc = "Increment under cursor",
		},
		{
			"-",
			"<C-x>",
			mode = { "n" },
			desc = "Decrement under cursor",
		},
	},
	dependencies = {
		{
			"folke/snacks.nvim",
			priority = 1000,
			opts = {
				input = {},
				picker = {
					actions = {
						opencode_send = function(...)
							return require("opencode").snacks_picker_send(...)
						end,
					},
					win = {
						input = {
							keys = {
								["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
							},
						},
					},
				},
			},
		},
	},
	config = function()
		vim.g.opencode_opts = {}
		vim.o.autoread = true
	end,
}
