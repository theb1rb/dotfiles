
vim.g.mapleader = " "

-- Telescope mappings
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
    require("telescope.builtin").live_grep()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fb", function()
    require("telescope.builtin").buffers()
end, { desc = "Find buffers" })

vim.keymap.set("n", "<leader>fh", function()
    require("telescope.builtin").help_tags()
end, { desc = "Help tags" })
-- End Telescope mappings
-- Debug Adapter Protocol
vim.keymap.set('n', '<F5>', function()
   require('dap').continue()
end, { desc = "DAP Continue"})

vim.keymap.set('n', '<F10>', function()
	require('dap').step_over()
end, { desc = "DAP Step Over"})

vim.keymap.set('n', '<F11>', function()
	require('dap').step_into()
end, { desc = "DAP Step Into"})

vim.keymap.set('n', '<F12>', function()
	require('dap').step_out()
end, { desc = "DAP Step Out"})

vim.keymap.set('n', '<leader>b', function()
	require('dap').toggle_breakpoint()
end, { desc = "DAP Toggle Breakpoint"})

vim.keymap.set('n', '<leader>dr', function()
	require('dap').repl.open()
end, { desc = "DAP Open" })
-- End DAP
-- DAP UI
vim.keymap.set('n', '<leader>du', function()
   require('dapui').toggle()
end, { desc = "Open DAP UI" })
-- End DAP UI
-- Mini Files
vim.keymap.set('n', '<leader>mf', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0))
end, { desc = "Open Mini Files" })
-- End Mini Files

