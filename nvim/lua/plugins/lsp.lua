MiniDeps.add({
    source = "neovim/nvim-lspconfig",
    depends = {
        "williamboman/mason.nvim",
    },
})

require("mason").setup()
