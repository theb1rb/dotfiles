MiniDeps.add({
   source = 'mfussenegger/nvim-dap'
})

local dap = require('dap')

dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
}

dap.configurations.c = {
  {
    name = 'Launch with GDB',
    type = 'gdb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = false,
  },
}

dap.configurations.cpp = dap.configurations.c

-- vim.keymap.set('n', '<F5>', dap.continue)
-- vim.keymap.set('n', '<F10>', dap.step_over)
-- vim.keymap.set('n', '<F11>', dap.step_into)
-- vim.keymap.set('n', '<F12>', dap.step_out)
-- vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
-- vim.keymap.set('n', '<leader>dr', dap.repl.open)
