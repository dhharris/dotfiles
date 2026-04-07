local function finish_ok(message)
  print("OK: " .. message)
  vim.cmd("qall!")
end

local function finish_skip(message)
  print("SKIP: " .. message)
  vim.cmd("qall!")
end

local function finish_fail(message)
  error(message)
end

local function has_value(values, expected)
  return vim.iter(values):any(function(value)
    return value == expected
  end)
end

local jedi_language_server = vim.fn.stdpath("data") .. "/mason/bin/jedi-language-server"
if vim.fn.executable(jedi_language_server) == 0 then
  finish_skip("jedi-language-server is not installed in Mason")
end

local test_file = vim.fn.tempname() .. ".py"
vim.fn.writefile({
  "import os",
  "",
  "os.pa",
}, test_file)

vim.cmd("edit " .. vim.fn.fnameescape(test_file))

local attached = vim.wait(10000, function()
  return #vim.lsp.get_clients({ bufnr = 0, name = "jedi_language_server" }) > 0
end, 100)

if not attached then
  finish_fail("jedi_language_server did not attach")
end

local completeopt = vim.opt.completeopt:get()
for _, option in ipairs({ "menuone", "noselect", "popup" }) do
  if not has_value(completeopt, option) then
    finish_fail("missing completeopt flag: " .. option)
  end
end

if vim.bo.omnifunc ~= "v:lua.vim.lsp.omnifunc" then
  finish_fail("unexpected omnifunc: " .. vim.bo.omnifunc)
end

vim.api.nvim_win_set_cursor(0, { 3, 5 })

local client = vim.lsp.get_clients({ bufnr = 0, name = "jedi_language_server" })[1]
local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
params.context = {
  triggerKind = vim.lsp.protocol.CompletionTriggerKind.Invoked,
}

local responses = vim.lsp.buf_request_sync(0, "textDocument/completion", params, 5000)
if not responses or vim.tbl_isempty(responses) then
  finish_fail("no completion response from jedi_language_server")
end

local labels = {}
for _, response in pairs(responses) do
  local result = response.result
  if result then
    local items = result.items or result
    for _, item in ipairs(items) do
      labels[item.label] = true
    end
  end
end

if not labels.path then
  local seen = vim.tbl_keys(labels)
  table.sort(seen)
  finish_fail("expected completion item 'path', got: " .. table.concat(seen, ", "))
end

finish_ok("jedi completion returned 'path' for os.pa")
