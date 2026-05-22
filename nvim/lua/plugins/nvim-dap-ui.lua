MiniDeps.add({
   source = 'rcarriga/nvim-dap-ui',
   depends = { 'nvim-neotest/nvim-nio' }
})

require('dapui').setup()
