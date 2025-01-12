local M = {}

---@param doc string
local trim_whitespace = function(doc)
  return string.gsub(doc, "^%s*(.-)%s*$", "%1")
end

---Get the split string
---Ported from copilot-cmp
---@param inputstr string
---@param sep? string
---@return string[]
local function split(inputstr, sep)
  sep = sep or inputstr:find("\r") and "\r" or "\n"
  if sep == nil then
    sep = "\n"
  end
  if not string.find(inputstr, "[\r|\n]") then
    return { inputstr }
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

---@return blink.cmp.CompletionItem
M.format_item = function(item, ctx, opts)
  local splitText = split(item.text)
  item.range["end"].character = #splitText[1]

  return {
    label = trim_whitespace(item.text),
    kind = vim.lsp.protocol.CompletionItemKind.Text,
    textEdit = {
      newText = item.text,
      range = item.range,
    },
    documentation = {
      kind = "markdown",
      value = string.format("```%s\n%s\n```\n", vim.bo.filetype, trim_whitespace(item.text)),
    },
  }
end

return M
