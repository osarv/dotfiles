-- Space as the leader for everything; olang's keys are <Space>r run, b build, t test, f format, e explain, i prompt
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set("n", "<Space>", "<Nop>")

vim.cmd.colorscheme("torte")

local o = vim.opt
o.mouse = "a"
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true
o.number = true
o.showmatch = true
o.ignorecase = true
o.incsearch = true
o.hlsearch = false
o.backup = false
o.swapfile = false
o.cursorline = true
o.cursorlineopt = "number"
o.complete:append("i")

-- the current line's number in magenta, in a terminal of 256 colours and of true colour alike
vim.api.nvim_set_hl(0, "CursorLineNr", { ctermfg = "magenta", fg = "Magenta" })

-- Markdown read comfortably: long lines wrap at word boundaries, wrapped list items keep their indentation, and the
-- ** and ` around text are hidden
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.conceallevel = 2
  end,
})

-- diagnostics written at the end of their line, as before Neovim 0.11 (which turned that off by default)
vim.diagnostic.config({ virtual_text = true })
