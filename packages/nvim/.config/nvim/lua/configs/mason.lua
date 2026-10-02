-- Auto-install LSP servers, formatters, linters via mason's registry API.
-- mason.nvim v2 core has NO `ensure_installed` (that lived in mason-tool-installer /
-- mason-lspconfig only). This is the zero-dependency equivalent: refresh the registry,
-- install anything missing. Runs once at startup (mason spec is lazy=false).
-- ponytail: 15 lines of mason's own API beats adding mason-tool-installer (one more
-- dep, open mason-v2 compat issues). Switch to mason-tool-installer if this list grows
-- past ~30 tools or needs version pinning.

local ensure_installed = {
  "lua-language-server",
  "typescript-language-server",
  "stylua",
  "html-lsp",
  "css-lsp",
  "prettier",
  "pyright",
  "ruff",
  "gopls",
  "goimports",
  "yaml-language-server",
  "dockerfile-language-server",
  "bash-language-server",
}

local registry = require "mason-registry"

registry.refresh(function()
  for _, name in ipairs(ensure_installed) do
    local ok, pkg = pcall(registry.get_package, name)
    if ok and not pkg:is_installed() then
      pkg:install()
    end
  end
end)
