local options = {
    ensure_installed = {
        "bash",
        "c_sharp",
        "lua",
        "luadoc",
        "markdown",
        "printf",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
    },

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    ident = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
