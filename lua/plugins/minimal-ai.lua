return {
    dir = "~/code/plugins/minimal-ai.nvim/",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("minimal-ai")
    end
}
