vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "anticuus"

local set = vim.api.nvim_set_hl

-- Base
set(0, "Normal", { fg = "#dadada", bg = "#000000" })
set(0, "Comment", { fg = "#00b300" })
set(0, "Constant", { fg = "#dadada" })
set(0, "String", { fg = "#00b300" })
set(0, "Character", { link = "Comment" })
set(0, "Number", { fg = "#dadada" })
set(0, "Boolean", { fg = "#ffcc00" })
set(0, "Float", { fg = "#dadada" })
set(0, "Identifier", { fg = "#dadada" })
set(0, "Function", { fg = "#dadada" })
set(0, "Statement", { fg = "#ffcc00" })
set(0, "Conditional", { fg = "#ffcc00" })
set(0, "Repeat", { fg = "#dadada" })
set(0, "Keyword", { fg = "#ffcc00" })
set(0, "Operator", { fg = "#dadada" })
set(0, "PreProc", { fg = "#00b300" })
set(0, "Include", { fg = "#00b300" })
set(0, "Define", { fg = "#00b300" })
set(0, "Macro", { fg = "#00b300" })
set(0, "Type", { fg = "#dadada" })
set(0, "Typedef", { fg = "#ffcc00" })
set(0, "Special", { link = "PreProc" })

-- UI
set(0, "CursorLineNr", { fg = "#dadada", bg = "#282828" })
set(0, "LineNr", { fg = "#dadada" })
set(0, "SignColumn", { fg = "#00b300", bg = "#000000" })
set(0, "Search", { fg = "#000000", bg = "#ffcc00" })
set(0, "Visual", { bg = "#3a3a3a" })
set(0, "StatusLine", { fg = "#dadada", bg = "#000000" })
set(0, "StatusLineNC", { fg = "#dadada", bg = "#000000" })

-- Popup menu / completion
set(0, "Pmenu", { fg = "#dadada", bg = "#181818" })
set(0, "PmenuSel", { fg = "#000000", bg = "#ffcc00" })
set(0, "PmenuSbar", { bg = "#181818" })
set(0, "PmenuThumb", { bg = "#3a3a3a" })

set(0, "DiagnosticError", { fg = "#ff6b6b" })
set(0, "DiagnosticWarn", { fg = "#ffcc00" })
set(0, "DiagnosticInfo", { fg = "#00b300" })
set(0, "DiagnosticHint", { fg = "#dadada" })

set(0, "DiagnosticVirtualTextError", { fg = "#dadada", bg = "NONE" })
set(0, "DiagnosticVirtualTextWarn", { fg = "#dadada", bg = "NONE" })
set(0, "DiagnosticVirtualTextInfo", { fg = "#dadada", bg = "NONE" })
set(0, "DiagnosticVirtualTextHint", { fg = "#dadada", bg = "NONE" })

set(0, "@comment", { fg = "#00b300" })
set(0, "@string", { fg = "#00b300" })
set(0, "@keyword", { fg = "#ffcc00" })
set(0, "@keyword.operator", { fg = "#ffcc00" })
set(0, "@variable", { fg = "#dadada" })
set(0, "@function", { fg = "#dadada" })
set(0, "@type", { fg = "#ffcc00" })
set(0, "@attribute", { fg = "#dadada" })
set(0, "@constant", { fg = "#dadada" })
set(0, "@constant.builtin", { fg = "#dadada" })
set(0, "@number", { fg = "#dadada" })
set(0, "@boolean", { fg = "#ffcc00" })
set(0, "@property", { fg = "#dadada" })
set(0, "@parameter", { fg = "#dadada" })

set(0, "markdownH1", { link = "PreProc" })
set(0, "markdownH2", { link = "PreProc" })
set(0, "markdownH3", { link = "PreProc" })
set(0, "markdownH4", { link = "PreProc" })
set(0, "markdownH5", { link = "PreProc" })
set(0, "markdownH6", { link = "PreProc" })
set(0, "markdownHeadingDelimiter", { link = "PreProc" })

set(0, "NormalFloat", { bg = "#000000" })
set(0, "FloatBorder", { fg = "#dadada", bg = "#000000" })
set(0, "ColorColumn", { bg = "#1a1a1a" })
set(0, "CursorLine", { bg = "#121212" })
