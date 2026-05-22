local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"

if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing mini.nvim" | redraw')

    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-mini/mini.nvim",
        mini_path,
    }

    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed mini.nvim" | redraw')
end

require("mini.deps").setup({
    path = {
        package = path_package,
    },
})

-- require("mini.basics").setup()
require("mini.icons").setup()
require("mini.comment").setup()
require("mini.trailspace").setup()
require("mini.surround").setup()
require("mini.pairs").setup()
require("mini.indentscope").setup()
require("mini.statusline").setup()
require("mini.starter").setup()
require("mini.git").setup()
require("mini.files").setup()
-- require("mini.fuzzy").setup()
-- require("mini.cmdline").setup()
require("mini.clue").setup({
   triggers = {
      -- Leader
      { mode = "n", keys = "<leader>"},
      -- Surround
      { mode = "n", keys = "s"},
      -- Gamma
      { mode = "n", keys = "g"},
   }
})
