local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
null_ls.register({ null_ls.builtins.diagnostics.yamllint})

