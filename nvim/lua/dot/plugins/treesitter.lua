-- Highlight, edit, and navigate code

local treesitter = {
  "nvim-treesitter/nvim-treesitter",

  lazy = false,
  branch = "main",
  build = ":TSUpdate",
}

treesitter.config = function()
  -- Keep alphabetical order when managing this list
  local parsers = {
    "c",
    "go",
    "bash",
    "proto",
    "python",
    "terraform",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  }

  require("nvim-treesitter").install(parsers)

  -- uncomment to automatically install syntax highlighting for new file types
  -- vim.api.nvim_create_autocmd("FileType", {
  --   callback = function(args)
  --     local buf, filetype = args.buf, args.match

  --     local language = vim.treesitter.language.get_lang(filetype)
  --     if not language then
  --       return
  --     end

  --     -- check if parser exists and load it
  --     if not vim.treesitter.language.add(language) then
  --       return
  --     end

  --     -- enables syntax highlighting and other treesitter features
  --     vim.treesitter.start(buf, language)

  --     -- enables treesitter based indentation
  --     vim.bo.indentexpr = "v:lua.require"nvim-treesitter".indentexpr()"
  --   end,
  -- })
end

return treesitter
