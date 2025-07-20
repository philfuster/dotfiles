return {
  "johmsalas/text-case.nvim",
  config = function()
    require("textcase").setup({})
  end,
  keys = {
    { "ga.", function() require("textcase").current_word("to_upper_case") end, mode = { "n" }, desc = "Upper case" },
    { "gal", function() require("textcase").current_word("to_lower_case") end, mode = { "n" }, desc = "Lower case" },
    { "gas", function() require("textcase").current_word("to_snake_case") end, mode = { "n" }, desc = "Snake case" },
    { "gac", function() require("textcase").current_word("to_camel_case") end, mode = { "n" }, desc = "Camel case" },
    { "gap", function() require("textcase").current_word("to_pascal_case") end, mode = { "n" }, desc = "Pascal case" },
    { "gad", function() require("textcase").current_word("to_dash_case") end, mode = { "n" }, desc = "Dash case" },
  },
  cmd = {
    "Subs",
    "TextCaseStartReplacingCommand",
  },
}
