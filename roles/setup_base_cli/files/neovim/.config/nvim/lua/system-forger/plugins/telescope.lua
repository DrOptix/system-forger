-- THIS FILE IS MANAGED BY ANSIBLE; ANY MANUAL CHANGES WILL BE LOST

return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        -- Utility library for Neovim plugins.
        "nvim-lua/plenary.nvim",

        -- Filetype icons for Neovim plugins and status lines.
        { "nvim-tree/nvim-web-devicons" },
    },
    keys = {
        {
            "<leader>ff",
            "<cmd>Telescope find_files<cr>",
            mode = "n",
            desc = "Fuzzy find files in CWD"
        },
        {
            "<leader>fs",
            "<cmd>Telescope live_grep<cr>",
            mode = "n",
            desc = "Find string in CWD"
        },
        {
            "<leader>fc",
            "<cmd>Telescope grep_string<cr>",
            mode = "n",
            desc = "Find string under cursor in CWD"
        },
        {
            "<leader>fb",
            "<CMD>Telescope buffers<cr>",
            mode = "n",
            desc = "Fuzzy find open buffers"
        },
        {
            "<leader>fk",
            "<CMD>Telescope keymaps<cr>",
            mode = "n",
            desc = "Fuzzy find keybindings"
        },
    },
}
