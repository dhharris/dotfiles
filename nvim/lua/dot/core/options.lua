-- Default netrw to tree liststyle
vim.cmd("let g:netrw_liststyle = 3")

---------------------------------------------------------------
-- => Text, tab, indent and lines
---------------------------------------------------------------
-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Be smart when using tabs
vim.opt.smarttab = true

-- Default tab/indent settings
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Filetype-specific indentation rules
local ft_opts = {
    c        = { width = 8 },
    cpp      = { width = 2 },
    markdown = { width = 2 },
    text     = { width = 2 },
    php      = { width = 2 },
    python   = { width = 4 },
    go       = { width = 4, noexpandtab = true },
    starlark = { width = 2 },
    lua = { width = 2 },
}

for ft, opts in pairs(ft_opts) do
    vim.api.nvim_create_autocmd("FileType", {
        pattern = ft,
        callback = function()
            -- Fallback to default if needed
            local width = opts.width or vim.opt.shiftwidth
            vim.opt_local.tabstop = width
            vim.opt_local.shiftwidth = width
            vim.opt_local.softtabstop = width

            for k, v in pairs(opts) do
                -- extra arguments
                if k ~= "width" then
                    vim.opt_local[k] = v
                end
            end
        end,
    })
end

-- Line breaking
vim.opt.linebreak = true
vim.opt.textwidth = 80

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    command = "setlocal textwidth=88",
})

-- Highlight lines beyond the column limit
vim.api.nvim_set_hl(0, "OverLength", { fg = "#ffffff", bg = "#592929" })
vim.api.nvim_set_hl(0, "SpellBad", { underline = true })

-- Match highlight for long lines
vim.cmd([[match OverLength /\%81v.\+/]])

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    command = "match OverLength /\\%89v.\\+/",
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "hgcommit" },
    command = "match none",
})

-- Spellcheck for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "hgcommit" },
    command = "setlocal spell spelllang=en_us",
})

-- Disable auto text wrapping for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "hgcommit" },
    command = "setlocal textwidth=0 wrapmargin=0",
})

-- Auto indent and wrap
vim.opt.autoindent = true
vim.opt.wrap = true

---------------------------------------------------------------
-- => Colors and Fonts
---------------------------------------------------------------

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.encoding = "utf-8"

-- Clear highlighting with ESC
vim.keymap.set("n", "<esc><esc>", "<cmd>noh<CR>")
