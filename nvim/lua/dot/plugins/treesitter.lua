return {
  -- TODO: Figure out why treesitter plugin is necessary
  -- add more treesitter parsers
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
