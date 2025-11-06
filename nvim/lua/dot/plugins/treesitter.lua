return {
  -- Treesitter provides better syntax highlighting by understanding the code as
  -- a tree of programming language constructs (field, method, etc)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = { enable = true },
        highlight = {
          enable = true,
        },
        ensure_installed = {
          "c",
          "go",
          "bash",
          "python",
          "terraform",
          "tsx",
          "typescript",
          "vim",
          "yaml",
        },
      })
    end,
  }
}
