-- Default netrw to tree liststyle
vim.cmd("let g:netrw_liststyle = 3")
vim.g.mapleader = ","

---------------------------------------------------------------
-- => Text, tab, indent and lines
---------------------------------------------------------------
-- Use spaces instead of tabs
vim.opt.expandtab = true

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
vim.api.nvim_set_hl(0, "OverLength", {
  fg = "#ffffff",
  bg = "#9d0006"  -- Gruvbox faded_red. TODO: Source from actual gruvbox
})
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

---------------------------------------------------------------
-- => Colors and Fonts
---------------------------------------------------------------

vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.encoding = "utf-8"

-- Clear highlighting with ESC
vim.keymap.set("n", "<esc><esc>", "<cmd>noh<CR>")

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank({timeout=300})
    end,
})

---------------------------------------------------------------
-- => Moving around, tabs, windows and buffers
---------------------------------------------------------------
-- More natural split opening
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Move between windows without C-W
for _, key in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<C-" .. key .. ">", "<C-W>" .. key)
end

-- In visual mode, <leader>y will copy selection into the macOS clipboard
-- Only works on macOS
vim.keymap.set("v", "<leader>y", function()
  -- Save current register
  local save_reg = vim.fn.getreg('"')
  local save_type = vim.fn.getregtype('"')

  -- Copy the selected text to default register
  vim.cmd('normal! vgvy')

  -- Send it to macOS clipboard via pbcopy
  vim.fn.system('pbcopy', vim.fn.getreg('"'))

  -- Restore previous register
  vim.fn.setreg('"', save_reg, save_type)
end, { desc = "Copy visual selection to macOS clipboard", silent = true })
